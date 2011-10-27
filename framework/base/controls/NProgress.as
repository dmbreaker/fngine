package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.graphics.NAnimatedBitmap;
	import base.managers.ResourceManager;
	import base.modelview.WidgetContainer;
	import base.utils.Methods;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NProgress extends Control
	{
		// ============================================================
		// ============================================================
		private var mProgress:Number = 0;
		protected var mImage:BitmapData;
		protected var mMImage:NAnimatedBitmap;
		protected var mHorAlign:int;
		protected var mVerAlign:int;
		protected var mForeImageIndex:int = 0;
		protected var mBackImageIndex:int = 0;
		// ============================================================
		// ============================================================
		public function NProgress( name:String, rect:*=null, settings:*=null, parent:WidgetContainer = null )
		{
			super( name );
			Parent = parent;
			
			mCanHasFocus = false;
			mCanCatchClicks = false;
			if( settings.image )
				mImage = ResourceManager.GetImage( settings.image );
			else if ( settings.multi_image )
				MultiImage = ResourceManager.GetAnimation( settings.multi_image );
				
			if ( settings.progress )
				Progress = Number(settings.progress) / 100.0;
			
			if ( rect )
			{
				if ( mImage )
				{
					rect.w = rect.w || mImage.width;
					rect.h = rect.h || mImage.height
				}
				else if ( mMImage )
				{
					rect.w = rect.w || mMImage.FrameWidth;
					rect.h = rect.h || mMImage.FrameHeight;
				}
				else
				{
					rect.w = rect.w || 0;
					rect.h = rect.h || 0;
				}
				
				Methods.CalcControlRectAndResize( rect, this, Parent );
			}
			
			mHorAlign = settings.halign;
			mVerAlign = settings.valign;
		}
		// ============================================================
		// ============================================================
		public function SetBackFrameIndex( value:int ):void
		{
			mBackImageIndex = value;
		}
		// ============================================================
		public function SetForeFrameIndex( value:int ):void
		{
			mForeImageIndex = value;
		}
		// ============================================================
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
		//SimpleProfiler.Start("NImages");
			var _x:Number = 0;
			var _y:Number = 0;
			var w:int = 0;
			var h:int = 0;
		
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
				
				var progress:Number = Progress;
				w = int(mImage.width * progress + 0.5);
				g.DrawBitmapDataPart( mImage, _x, _y, 0,0,w,mImage.height );	// отрисовка выровненная
			}
			else if ( mMImage )
			{
				if( mBackImageIndex >= 0 )
					g.DrawImage( mMImage.GetFrame(mBackImageIndex), 0, 0 );
					
				w = int(mProgress * Number(mMImage.FrameWidth) + 0.5);
				h = mMImage.FrameHeight;
				if( mForeImageIndex >= 0 )
					g.DrawBitmapDataPart( mMImage.GetFrame(mForeImageIndex), 0, 0, 0, 0, w, h );
			}
			/*else if ( mAnimImage )
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
			}*/
		//SimpleProfiler.Stop("NImages");
		}
		// ============================================================
		public function get Progress():Number
		{
			return mProgress;
		}
		// ============================================================
		public function set Progress( progress:Number ):void 
		{
			if ( progress > 1 ) progress = 1;
			if ( progress < 0 ) progress = 0;
			
			mProgress = progress;
		}
		// ============================================================
		public function set Image( img:BitmapData ):void
		{
			mImage = img;
		}
		// ============================================================
		public function set MultiImage( mimg:NAnimatedBitmap ):void
		{
			mMImage = mimg;
			mBackImageIndex = 0;
			mForeImageIndex = 1;
		}
		// ============================================================
		// ============================================================
		public static function Create( el:XML, parent:WidgetContainer = null ):NProgress
		{
			var rect:* = { };
			var settings:* = { halign:int(0), valign:int(0) };
			
			Methods.ApplyControlSettings( el, rect, settings, null, parent );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NProgress( id, rect, settings, parent );
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