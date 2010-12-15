﻿package base.controls
{
	import base.core.NCore;
	import base.core.NStyle;
	import base.graphics.BitmapGraphix;
	import base.managers.FontsManager;
	import base.graphics.IGraphix;
	import base.graphics.ImageFont;
	import base.graphics.NBitmapData;
	import base.types.*;
	import base.utils.Methods;
	
	//import fonts.SomeFont;
	
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NText extends Control
	{
		/**
		 * settings:
		 * 	text
		 * 	font
		 *  font_leading - расстояние между строками
		 *  font_kerning - расстояние между символами
		 * 	halign
		 * 	valign
		 * 
		 * images:
		 * 	control dependant fields
		 * 
		 * rect:
		 * 	x
		 * 	y
		 * 	w
		 * 	h
		 */
		// ============================================================
		public var HorAlign:int = -1;
		public var VerAlign:int = -1;
		// ============================================================
		protected var mFont:ImageFont = null;
		// ============================================================
		protected var mBuffer:NBitmapData = null;
		protected var mText:String = "";
		
		private var mR:int = 0;
		private var mG:int = 0;
		private var mB:int = 0;
		protected var mIsDirty:Boolean = true;	// нужно ли перерисовать
		
		private var mInitText:String;	// переменная - используется вместо передачи параметра в ApplySettings (чтобы без проблем можно было переопределять этот метод
		// ============================================================
		public function NText( name:String, text:String = null, rect:* = null, settings:* = null )
		{
			super( name );
			
			mInitText = text;	// mInitText может измениться в ApplySettings
			ApplySettings( settings );
			Text = mInitText;
			
			ApplyRect( rect );
		}
		// ============================================================
		public function get Font():ImageFont
		{
			return mFont;
		}
		// ============================================================
		public function set Font( font:ImageFont ):void
		{
			mFont = font;
		}
		// ============================================================
		public function SetColorTransform( r:int, g:int, b:int ):void
		{
			mR = r; mG = g; mB = b;
			
			DisposeBufferIfExist();
			mIsDirty = true;
			Text = mText;

			if( mBuffer )
				mBuffer.TransformColor( mR, mG, mB );
		}
		// ============================================================
		public override function Resize(w:int, h:int):void
		{
			mIsDirty = true;
			
			super.Resize( w, h );	// чтобы обновились размеры контрола
			DisposeBufferIfExist();	// удалим буфер
			Text = mText;	// восстановим текст
			
			if ( Rect.Size.IsEmpty )	// если выставлен пустой размер/автосайз, то подгоним под размер текста
				if( mBuffer )
					super.Resize(mBuffer.width, mBuffer.height);	// если нарисовали текст

			// CreateBufferIfNeed() не нужен, так как Text сделает всю работу
		}
		// ============================================================
		public function get Text():String
		{
			return mText;
		}
		// ============================================================
		public function set Text( txt:String ):void
		{
			// !!! требуется хороший рефакторинг:
			// добавить поле AutoSize
			// упростить код здесь
			// избавиться в данном классе от (Rect.Size.IsEmpy == AutoSize)
			var w:Number = 0;
			var h:Number = 0;
			
			CreateBufferIfNeed( txt );
			
			if ( mBuffer )
			{
				w = mBuffer.width;
				h = mBuffer.height;
			}
			
			if ( mIsDirty || mText != txt || w != Rect.Size.Width || h != Rect.Size.Height )// если изменился текст или размеры контрола
			{
				mIsDirty = false;
				mText = txt;
				
				var rect:NRect = new NRect();
				if ( !Rect.Size.IsEmpty )
				{
					rect.CopyFrom( Rect );
					rect.Position.Reset();				// чтобы не проводилось повторного смещения координат
				}
				else
				{
					rect.Size.Width = w;
					rect.Size.Height = h;
				}
					
				
				if ( mBuffer )
					mBuffer.Clear();
				
				if ( mText && mBuffer && mFont )
				{
					mBuffer.DrawText( mText, mFont, rect, HorAlign, VerAlign );
					mBuffer.TransformColor( mR, mG, mB );
				}
			}
		}
		// ============================================================
		protected function CreateBufferIfNeed( txt:String = null ):void
		{
			if ( !mBuffer )
			{
				if( !Rect.Size.IsEmpty )
					mBuffer = new NBitmapData( Rect.Size.Width, Rect.Size.Height );
				else if( txt != null && mFont != null )
				{
					var size:NSize = mFont.MeasureStringSize( txt );
					if( !size.IsEmpty )
						mBuffer = new NBitmapData( size.Width, size.Height );
				}
			}
		}
		// ============================================================
		protected function DisposeBufferIfExist():void
		{
			if ( mBuffer )
			{
				mBuffer.dispose();
				mBuffer = null;
			}
		}
		// ============================================================
		public override function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			if ( mFont && mBuffer )
			{
				g.DrawBitmapDataFast( mBuffer, 0, 0 );
			}
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML ):NText
		{
			var settings:* = {halign:int(0), valign:int(0)};
			var rect:* = { };
			
			Methods.ApplyControlSettings( el, rect, settings );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NText( id, "", rect, settings );
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
		protected function ApplyRect( rect:* ):void 
		{
			if ( rect )
			{
				if ( rect.x ) Rect.Position.x = rect.x;
				if ( rect.y ) Rect.Position.y = rect.y;
				Resize( rect.w || 0, rect.h || 0 );
			}
		}
		// ============================================================
		protected function ApplySettings( settings:* ):void 
		{
			if ( !mInitText )
			{
				if( settings && settings.text )
					mInitText = settings.text;
				else
					mInitText = "";
			}

			if ( !settings || !settings.font )
				mFont = FontsManager.Instance.GetDefaultFont();
			else
			{
				mFont = FontsManager.Instance.GetFont( settings.font );
				if ( settings.font_leading )
				{
					mFont.Leading = settings.font_leading;
				}
				if ( settings.font_kerning )
				{
					mFont.Kerning = settings.font_kerning;
				}
			}

			if( settings )
			{
				HorAlign = settings.halign;
				VerAlign = settings.valign;
			}
			else
			{
				HorAlign = -1;
				VerAlign = -1;
			}
		}
		// ============================================================
	}
	
}