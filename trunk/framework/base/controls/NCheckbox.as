package base.controls
{
	import base.core.NCore;
	import base.core.NStyle;
	import base.graphics.BitmapGraphix;
	import base.graphics.ImageFont;
	import base.types.*;
	import base.utils.Methods;
	
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NCheckbox extends NText
	{
		// ============================================================
		protected static var sCheckboxUnchecked:int = 0;
		protected static var sCheckboxUncheckedPressed:int = 1;
		protected static var sCheckboxChecked:int = 2;
		protected static var sCheckboxCheckedPressed:int = 3;
		protected static var sCheckboxDisabled:int = 4;
		protected static var sCheckboxUncheckedOver:int = 5;
		protected static var sCheckboxCheckedOver:int = 6;
		// no "focused" states at this moment (are they needed?)
		// ============================================================
		protected var mIsPressed:Boolean = false;
		protected var mIsChecked:Boolean = false;
		
		protected var mImages:Array = new Array();
		protected var HasImages:Boolean = false;
		// ============================================================
		public function NCheckbox( name:String, text:String = null, images:* = null, rect:* = null, settings:* = null )
		{
			super( name, text, null, settings );
			//mCanHasFocus = false;		// пока фокус не держит
			InitImages( images );
			
			if( rect )
			{
				if ( rect.x ) Rect.Position.x = rect.x;
				if ( rect.y ) Rect.Position.y = rect.y;
				Resize( rect.w || CurrentImage.width, rect.h || CurrentImage.height );
			}
			
			if( settings )
				IsChecked = settings.checked || true;
		}
		// ============================================================
		protected function InitImages( images:* ):void
		{
			var uncheck:BitmapData, check:BitmapData;
			var pressed_unch:BitmapData, pressed_ch:BitmapData;
			var over_unch:BitmapData, over_ch:BitmapData;
			var disabled:BitmapData;
			
			if ( !images || images["unchecked"] == undefined || images["unchecked"] == null || images["checked"] == undefined || images["checked"] == null )
				HasImages = false;
			else
			{
				HasImages = true;
				
				uncheck = GM(images["unchecked"]);
				check = GM(images["checked"]);
				
				pressed_unch = GM(images["pressed_unchecked"]) || uncheck;	// если картинка не задана, то будет состояние "unchecked"
				pressed_ch = GM(images["pressed_checked"]) || check;
				over_unch = GM(images["over_unchecked"]) || uncheck;
				over_ch = GM(images["over_checked"]) || check;
				
				disabled = GM(images["disabled"]) || uncheck;
				
				mImages[sCheckboxUnchecked] = uncheck;
				mImages[sCheckboxChecked] = check;
				mImages[sCheckboxUncheckedPressed] = pressed_unch;
				mImages[sCheckboxCheckedPressed] = pressed_ch;
				mImages[sCheckboxUncheckedOver] = over_unch;
				mImages[sCheckboxCheckedOver] = over_ch;

				mImages[sCheckboxDisabled] = disabled;
			}
		}
		// ============================================================
		public function get IsChecked():Boolean
		{
			return mIsChecked;
		}
		// ============================================================
		public function set IsChecked( is_checked:Boolean ):void
		{
			mIsChecked = is_checked;
		}
		// ============================================================
		protected function get State():int
		{
			if ( Enabled )
			{
				if ( !mIsPressed )
				{
					if ( !IsMouseOver )
						return (mIsChecked) ? sCheckboxChecked : sCheckboxUnchecked;
					else
						return (mIsChecked) ? sCheckboxCheckedOver : sCheckboxUncheckedOver;
				}
				else
				{
					return (mIsChecked) ? sCheckboxCheckedPressed : sCheckboxUncheckedPressed;
				}
			}
			//else
			return sCheckboxDisabled;
		}
		// ============================================================
		protected function get CurrentImage():BitmapData
		{
			return BitmapData( mImages[State] );
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
				mIsChecked = !mIsChecked;
				Parent.OnCommand( this, "checkbox_check_changed" );
			}
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
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			if ( HasImages )
			{
				var img:BitmapData = CurrentImage;
				var _x:Number;
				var _y:Number;
				if ( Text )
				{
					_x = 0;
					_y = 0;
				}
				else
				{
					_x = int((Rect.Size.Width - img.width) * 0.5);	// не допускаем дробных координат
					_y = int((Rect.Size.Height - img.height) * 0.5);// не допускаем дробных координат
				}
				g.DrawBitmapDataFast( CurrentImage, _x, _y );
			}
			
			if ( Text )
			{
				var offx:Number = img.width+1;
				g.AddOffset( offx, 0 );
				super.Draw(g, diff_ms);
				g.AddOffset( -offx, 0 );
			}
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML ):NCheckbox
		{
			var rect:* = {};
			var settings:* = { halign:int(-1), valign:int(0) };
			var images:* = {};
			
			Methods.ApplyControlSettings( el, rect, settings, images );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NCheckbox( id, "", images, rect, settings );
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
	}
	
}