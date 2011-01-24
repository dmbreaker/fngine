package base.controls
{
	import base.core.NCore;
	import base.core.NStyle;
	import base.graphics.BitmapGraphix;
	import base.graphics.NAnimatedBitmap;
	import base.managers.ResourceManager;
	import base.types.*;
	import base.core.NScene;
	import base.utils.Methods;
	import base.utils.SimpleProfiler;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NImage extends Control
	{
		// ============================================================
		protected var mImage:BitmapData;
		protected var mAnimImage:NAnimatedBitmap;
		protected var mHorAlign:int;
		protected var mVerAlign:int;
		// ============================================================
		public function NImage( name:String, rect:*=null, settings:*=null )
		{
			super( name );
			mCanHasFocus = false;
			mCanCatchClicks = false;
			if( settings.image )
				mImage = ResourceManager.GetImage( settings.image );
			else if ( settings.anim )
				mAnimImage = ResourceManager.GetAnimation( settings.anim );
				
			if ( settings.visible )
			{
				if ( settings.visible == "false" || settings.visible == "0" )
					Visible = false;
			}
			
			if ( rect )
			{
				if ( rect.x ) Rect.Position.x = rect.x;
				if ( rect.y ) Rect.Position.y = rect.y;
				Resize( rect.w || ImgWidth, rect.h || ImgHeight );
			}
			
			mHorAlign = settings.halign;
			mVerAlign = settings.valign;
		}
		// ============================================================
		public function get Image():BitmapData
		{
			return mImage;
		}
		// ============================================================
		public function get AnimImage():NAnimatedBitmap
		{
			return mAnimImage;
		}
		// ============================================================
		public function get ImgWidth():int
		{
			if ( mImage )
				return mImage.width;
			else if ( mAnimImage )
				return mAnimImage.HalfWidth * 2;
			else
				return 0;
		}
		// ============================================================
		public function get ImgHeight():int
		{
			if ( mImage )
				return mImage.height;
			else if ( mAnimImage )
				return mAnimImage.HalfHeight * 2;
			else
				return 0;
		}
		// ============================================================
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
		SimpleProfiler.Start("NImages");
			var _x:Number = 0;
			var _y:Number = 0;
				
			if ( mImage )
			{
				if( mHorAlign == 0 )
					_x = (Rect.Size.Width - mImage.width) * 0.5;
				else if ( mHorAlign > 0 )
					_x = (Rect.Size.Width - mImage.width);
					
				if( mVerAlign == 0 )
					_y = (Rect.Size.Height - mImage.height) * 0.5;
				else if ( mVerAlign > 0 )
					_y = (Rect.Size.Height - mImage.height);
					
				g.DrawBitmapDataFast( mImage, _x, _y );	// отрисовка выровненная
			}
			else if ( mAnimImage )
			{
				//mAnimImage.Quant( diff_ms );
				mAnimImage.Quant( NScene.MsPerFrame );	// чтобы не "выпадали кадры"
				
				if( mHorAlign == 0 )
					_x = (Rect.Size.Width*0.5) - mAnimImage.HalfWidth;
				else if ( mHorAlign > 0 )
					_x = (Rect.Size.Width - mAnimImage.HalfWidth*2);
					
				if( mVerAlign == 0 )
					_y = (Rect.Size.Height*0.5) - mAnimImage.HalfHeight;
				else if ( mVerAlign > 0 )
					_y = (Rect.Size.Height - mAnimImage.HalfHeight*2);
				
				g.DrawBitmapDataFast( mAnimImage.GetNBD(), _x, _y );	// отрисовка выровненная
			}
		SimpleProfiler.Stop("NImages");
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Create( el:XML ):NImage
		{
			var rect:* = { };
			var settings:* = { halign:int(0), valign:int(0) };
			
			Methods.ApplyControlSettings( el, rect, settings );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NImage( id, rect, settings );
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