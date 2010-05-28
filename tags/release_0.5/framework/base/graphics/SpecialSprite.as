package base.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SpecialSprite
	{
		// ============================================================
		public var Name:String = "";
		public var FramesCount:int = 0;
		public var Frames:Array = null;
		
		private var mActiveFrame:int = 0;
		public var ScaleX:Number = 1;
		public var ScaleY:Number = 1;
		
		public var Brightness:Number = 0;
		
		// ============================================================
		public function SpecialSprite()
		{
			
		}
		// ============================================================
		public function ScaleQuad( value:Number ):void
		{
			ScaleX = ScaleY = value;
		}
		// ============================================================
		public function SetDObjOld( _dobj:DisplayObject, scale_x:Number = 1, scale_y:Number = 1 ):void
		{
			FramesCount = 1;
			Frames = new Array(1);
			Frames[0] = GetOldMovieBitmapData( _dobj, scale_x, scale_y );
		}
		// ============================================================
		public function SetDObj( mc:MovieClip, scale_x:Number = 1, scale_y:Number = 1, xs:Number=0, ys:Number=0, ws:Number=0, hs:Number=0 ):void
		{
			FramesCount = mc.totalFrames;
			Frames = new Array(FramesCount);

			//trace( FramesCount );
			for (var i:int = 0; i < FramesCount; i++)
			{
				mc.gotoAndStop(i + 1);
				//trace( i + 1 );
				Frames[i] = GetMovieBitmapData( mc, scale_x, scale_y, xs, ys, ws, hs );
			}
		}
		// ============================================================
		public function SetBitmapData( bmd:BitmapData ):void
		{
			FramesCount = 1;
			Frames = new Array( FramesCount );
			Frames[0] = bmd;
		}
		// ============================================================
		public function GetCurrentFrame():BitmapData
		{
			if ( FramesCount > 0 )
				return Frames[mActiveFrame];
			else
				return null;
		}
		// ============================================================
		public function get CurrentWidth():Number
		{
			return GetCurrentFrame().width * ScaleX;
		}
		// ============================================================
		public function get CurrentHeight():Number
		{
			return GetCurrentFrame().height * ScaleY;
		}
		// ============================================================
		/**
		 * Возвращает битмап для указанного DisplayObject
		 * @param	_sprite
		 */
		private function GetMovieBitmapData( _sprite:DisplayObject, scale_x:Number = 1, scale_y:Number = 1, xs:Number=0, ys:Number=0, ws:Number=0, hs:Number=0 ):BitmapData
		{
			var drawable:IBitmapDrawable = _sprite as IBitmapDrawable;
			var bmd:BitmapData = null;
			var bmp:Bitmap = null;
			if ( drawable != null )
			{
				bmd = new BitmapData((_sprite.width + ws) * scale_x, (_sprite.height + hs) * scale_y, true, 0);
				bmp = new Bitmap( bmd );

				var rgn:Rectangle = _sprite.getBounds(bmp);
				//trace( rgn );
				var m:Matrix = new Matrix(1, 0, 0, 1, xs, ys);// , -rgn.x, -rgn.y);
				m.scale( scale_x, scale_y );
				
				bmd.draw(drawable, m, null, BlendMode.NORMAL, null, true);
				
				return bmd;
			}
			return null;
		}
		// ============================================================
		/**
		 * Возвращает битмап для указанного DisplayObject
		 * @param	_sprite
		 */
		private function GetOldMovieBitmapData( _sprite:DisplayObject, scale_x:Number = 1, scale_y:Number = 1 ):BitmapData
		{
			var drawable:IBitmapDrawable = _sprite as IBitmapDrawable;
			var bmd:BitmapData = null;
			var bmp:Bitmap = null;
			if ( drawable != null )
			{
				bmd = new BitmapData(_sprite.width*scale_x, _sprite.height*scale_y, true, 0);
				bmp = new Bitmap( bmd );

				var rgn:Rectangle = _sprite.getBounds(bmp);
				//trace( rgn );
				var m:Matrix = new Matrix(1, 0, 0, 1, -rgn.x, -rgn.y);
				m.scale( scale_x, scale_y );
				
				bmd.draw(drawable, m, null, BlendMode.NORMAL, null, true);
				
				return bmd;
			}
			return null;
		}
		// ============================================================
		public function Rasterize( g:Graphics ):void
		{
			var bmd:BitmapData = GetCurrentFrame();

			g.beginBitmapFill( bmd, null, true, true );
			g.drawRect( 0, 0, bmd.width, bmd.height );
			g.endFill();
		}
		// ============================================================
		public function NextFrame():void
		{
			++mActiveFrame;
			if ( mActiveFrame >= FramesCount )
			{
				mActiveFrame = 0;
			}
		}
		// ============================================================
		public function SetFrame( frame:int ):void
		{
			if ( frame < FramesCount )
			{
				mActiveFrame = frame;
			}
			else
				throw new Error( "Wrong frame number in 'SpecialSprite: SetFrame'" );
		}
		// ============================================================
		public function ResetActiveFrame():void
		{
			mActiveFrame = 0;
		}
		// ============================================================
		public function get ActiveFrame():int
		{
			return mActiveFrame;
		}
		// ============================================================
	}
	
}