package base.controls 
{
	import base.core.NCore;
	import base.externals.bulkloader.BulkLoader;
	import base.externals.bulkloader.loadingtypes.LoadingItem;
	import base.graphics.NBitmapData;
	import base.modelview.Widget;
	import base.types.NRect;
	import base.types.NSize;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Incomplete!
	 * @author dmbreaker
	 */
	public class NMiniature
	{
		// ============================================================
		public var Size:NSize = new NSize();
		// ============================================================
		public function NMiniature() 
		{
			
		}
		// ============================================================
		private var count:int = 0;
		protected function GetLoadedImage( data:* ):BitmapData
		{
			var img:BitmapData;
			var bmp:Bitmap;
			
			if( data.image is BitmapData )
			{
				img = data.image as BitmapData;
				//BlastCore.Trace( "image BitmapData" );
			}
			else if ( data.image is LoadingItem )
			{
				var litem:LoadingItem = data.image as LoadingItem;
				if ( litem && litem.status == LoadingItem.STATUS_FINISHED )
				{
					if ( litem.isImage() )
					{
						bmp = (litem.content as Bitmap);
						if ( bmp )
						{
							img = bmp.bitmapData;
							data.image = img;
							NCore.Trace( "image loaded" );
						}
					}
				}
			}
			
			return img;
		}
		// ============================================================
		public function Draw( buff:NBitmapData, sx:Number, sy:Number, data:* ):void
		{
			var img:BitmapData = GetLoadedImage( data );
			
			DrawMiniature( buff, sx, sy, img, data );
		}
		// ============================================================
		protected function DrawMiniature( buff:NBitmapData, sx:Number, sy:Number, img:BitmapData, data:* ):void 
		{
			buff.fillRect( new Rectangle(sx, sy, Size.Width, Size.Height), 0xff323232 );
			if ( img )
			{
				buff.copyPixels( img, img.rect, new Point( sx + (Size.Width - img.width) * 0.5, sy + (Size.Height - img.height) * 0.5 ) );
			}
			buff.DrawNRect( new NRect(sx, sy, Size.Width - 1, Size.Height - 1), 0xffcccccc );
		}
		// ============================================================
	}

}