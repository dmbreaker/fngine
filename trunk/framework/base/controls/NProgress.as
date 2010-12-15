package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.managers.ResourceManager;
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
		protected var mHorAlign:int;
		protected var mVerAlign:int;
		// ============================================================
		// ============================================================
		public function NProgress( name:String, rect:*=null, settings:*=null )
		{
			super( name );
			mCanHasFocus = false;
			mCanCatchClicks = false;
			if( settings.image )
				mImage = ResourceManager.GetImage( settings.image );
				
			if ( settings.progress )
				Progress = Number(settings.progress) / 100;
			
			if ( rect )
			{
				if ( rect.x ) Rect.Position.x = rect.x;
				if ( rect.y ) Rect.Position.y = rect.y;
				if( mImage )
					Resize( rect.w || mImage.width, rect.h || mImage.height );
				else
					Resize( rect.w || 0, rect.h || 0 );
			}
			
			mHorAlign = settings.halign;
			mVerAlign = settings.valign;
		}
		// ============================================================
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
		//SimpleProfiler.Start("NImages");
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
				
				var progress:Number = Progress;
				var w:int = int(mImage.width * progress + 0.5);
				g.DrawBitmapDataPart( mImage, _x, _y, 0,0,w,mImage.height );	// отрисовка выровненная
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
		// ============================================================
		public static function Create( el:XML ):NProgress
		{
			var rect:* = { };
			var settings:* = { halign:int(0), valign:int(0) };
			
			Methods.ApplyControlSettings( el, rect, settings );
			
			var id:String = el.@id;
			
			try
			{
				if ( id )
				{
					return new NProgress( id, rect, settings );
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