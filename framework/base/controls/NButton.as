﻿package base.controls
{
	import base.core.NCore;
	import base.core.NScene;
	import base.core.NStyle;
	import base.graphics.BitmapGraphix;
	import base.graphics.ImageFont;
	import base.graphics.NBitmapData;
	import base.managers.ResourceManager;
	import base.managers.SoundsPlayer;
	import base.modelview.WidgetContainer;
	import base.types.*;
	import base.utils.Methods;
	import base.utils.SimpleProfiler;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NButton extends NText
	{
		/**
		 * settings:
		 * 	ver_text_shift - смещение текста относительно кнопки
		 * 
		 */
		// ============================================================
		public static var evtButtonClick:String = "buttonclick";
		// ============================================================
		protected static var sButtonNormal:int = 0;
		protected static var sButtonPressed:int = 1;
		protected static var sButtonOver:int = 2;
		protected static var sButtonDisabled:int = 3;
		protected static var sButtonFocused:int = 4;
		protected static var sButtonFocusedOver:int = 5;
		// ============================================================
		protected var mIsPressed:Boolean = false;
		protected var mImages:Array = new Array();
		protected var HasImages:Boolean = false;
		
		protected var mVerTextShift:int = 4;
		// ============================================================
		protected var mClickSample:String = "";
		protected var mOverSample:String = "";
		// ============================================================
		
		// ============================================================
		public function NButton( name:String, text:String = null, images:* = null, rect:* = null, settings:* = null, parent:WidgetContainer = null )
		{
			InitImages( images );
			super( name, text, rect, settings, parent );
			
			if ( settings )
			{
				if ( settings.sound_over )
					mOverSample = settings.sound_over;
				if ( settings.sound_click )
					mClickSample = settings.sound_click;
			}
			
			//	ApplySettings( settings );	// теперь вроде не нужно - он вызовется из родителя, т.к. метод ApplySettings переопределен
			//	ApplyRect( rect );
		}
		// ============================================================
		protected function InitImages( images:* ):void
		{
			var normal:BitmapData, over:BitmapData, pressed:BitmapData, disabled:BitmapData;
			var focused:BitmapData, focusedOver:BitmapData;
			
			if ( !images || images["normal"] == undefined || images["normal"] == null )
				HasImages = false;
			else
			{
				HasImages = true;
				
				normal = GM(images["normal"]);
				pressed = GM(images["pressed"]) || normal;	// если картинка не задана, то будет состояние "normal"
				over = GM(images["over"]) || normal;
				disabled = GM(images["disabled"]) || normal;
				focused = GM(images["focused"]) || normal;
				focusedOver = GM(images["focusedover"]) || over;	// именно "|| over"
				
				mImages[sButtonNormal] = normal;
				mImages[sButtonOver] = over;
				mImages[sButtonPressed] = pressed;
				mImages[sButtonDisabled] = disabled;
				mImages[sButtonFocused] = focused;
				mImages[sButtonFocusedOver] = focusedOver;
			}
		}
		// ============================================================
		protected function get State():int
		{
			if ( Enabled )
			{
				if ( !mIsPressed )
				{
					if ( !Focused && !IsMouseOver )
						return sButtonNormal;
					else if( Focused && IsMouseOver )
						return sButtonFocusedOver;
					else if( Focused )
						return sButtonFocused;
					else if( IsMouseOver )
						return sButtonOver;
				}
				else
					return sButtonPressed;
			}
			//else
			return sButtonDisabled;
		}
		// ============================================================
		protected function get CurrentImage():BitmapData
		{
			return BitmapData( mImages[State] );
		}
		// ============================================================
		public override function Resize(w:int, h:int):void
		{
			if ( Rect.Size.IsEmpty )	// если выставлен "автосайз"
			{
				w = w || CurrentImage.width;		// выставим размеры по картинке
				h = h || CurrentImage.height;
			}
			
			super.Resize(w, h);
		}
		// ============================================================
		public override function OnMouseDown(x:Number, y:Number):void
		{
			mIsPressed = true;
		}
		// ============================================================
		public override function OnMouseUp(x:Number, y:Number):void
		{
			mIsPressed = false;
			if ( ContainsRelative( x, y ) )
			{
				DoButtonClick();
			}
		}
		// ============================================================
		override public function OnMouseIn():void
		{
			if ( mOverSample.length > 0 )
				SoundsPlayer.Play( mOverSample );
			else
				SoundsPlayer.Play( NCore.Instance.MouseOverSampleName );
			super.OnMouseIn();// TODO: зачем-то удалял эту строку
		}
		// ============================================================
		protected function DoButtonClick():void
		{
			if ( mClickSample.length > 0 )
				SoundsPlayer.Play( mClickSample );
			else
				SoundsPlayer.Play( NCore.Instance.MouseClickSampleName );
			DispatchNotification( NButton.evtButtonClick );
			Parent.OnCommand( this, "button_click" );
		}
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
		SimpleProfiler.Start("NButtons");
			if ( HasImages )
			{
				var img:BitmapData = CurrentImage;
				var _x:Number = (Rect.Size.Width - img.width)*0.5;
				var _y:Number = (Rect.Size.Height - img.height)*0.5;
				g.DrawImageFast( CurrentImage, _x, _y );
			}
			
			var offx:Number = 0;
			var offy:Number = mVerTextShift;	// смещение текста по высоте
			
			if ( mIsPressed )
			{
				offx += 1;
				offy += 1;
			}
			
			g.AddOffset( offx, offy );
			super.Draw(g, diff_ms);
			g.AddOffset( -offx, -offy );
		SimpleProfiler.Stop("NButtons");
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML, parent:WidgetContainer = null ):NButton
		{
			var settings:* = {halign:int(0), valign:int(0)};
			var rect:* = {};
			var images:* = {};
			
			Methods.ApplyControlSettings( el, rect, settings, images, parent );
			
			var id:String = el.@id
			
			try
			{
				if ( id )
				{
					return new NButton( id, "", images, rect, settings, parent );
				}
			}
			catch( err:Error )
			{
				trace( "### Error:", err, err.getStackTrace() );
				return null;
			}
			
			return null;
		}
		// ============================================================
		public override function set Enabled( enabled:Boolean ):void
		{
			super.Enabled = enabled;
			
			// TODO: затычка для того, чтобы цвет текста стал "серее",
			// по хорошему - нужно будет сделать настраиваемым, для контролов, которые имеют отличный от черного цвета текст
			if ( enabled )
				SetColorTransform( 0, 0, 0 );
			else
				SetColorTransform( 64, 64, 64 );
		}
		// ============================================================
		public function ApplyXMLStyle( nameStyle:String ):void
		{
			var style:NStyle;
			style = NCore.GetStyle( nameStyle );
			if ( style )
			{
				InitImages( style.Images );
				ApplySettings( style.Settings );
				ApplyRect( style.Rect );	// должно быть внизу, иначе буфер не перерисуется
			}
			
		}
		// ============================================================
		protected override function ApplyRect( rect:* ):void 
		{
			if ( rect )
			{
				rect.w = rect.w || CurrentImage.width;
				rect.h = rect.h || CurrentImage.height;
				
				Methods.CalcControlRectAndResize( rect, this, Parent );
			}
		}
		// ============================================================
		protected override function ApplySettings( settings:* ):void 
		{
			super.ApplySettings( settings );
			
			if ( settings && settings.ver_text_shift )
				mVerTextShift = settings.ver_text_shift;
			
			if( settings )
			{
				HorAlign = settings.halign || 0;
				VerAlign = settings.valign || 0;
			}
			else
			{
				HorAlign = 0;
				VerAlign = 0;
			}
		}
		// ============================================================
	}
	
}