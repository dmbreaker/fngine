package base.graphics
{
	import base.types.NPoint;
	import base.types.NRect;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Graphics;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.display.BlendMode;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class BitmapGraphix extends NBitmapData implements IGraphix
	{
		// ============================================================
		private var mOffsetX:Number;
		private var mOffsetY:Number;
		private var mClearRect:Rectangle;
		
		private var mIsLocked:Boolean = false;
		// ============================================================
		public function BitmapGraphix(_width:int, _height:int, transparent:Boolean = true, fillColor:uint = 0x0)
		{
			super(_width, _height, true, fillColor);
			mClearRect = new Rectangle( 0, 0, _width, _height );
		}
		// ============================================================
		// ============================================================
		/* INTERFACE base.graphics.IGraphix */
		public override function Clear():void
		{
			this.fillRect( mClearRect, 0x00000000 );
		}
		// ============================================================
		//private var mColorTransform:ColorTransform = new ColorTransform();
		//public function SetColorTransform( r:Number, g:Number, b:Number, alpha:Number ):void
		//{
			//mColorTransform.alphaMultiplier = value;
		//}
		// ============================================================
		private var mBitmapColTr:ColorTransform = new ColorTransform(1, 1, 1, 1);
		private var mDrawMatrix:Matrix = new Matrix(1, 0, 0, 1);
		public function DrawBitmapData(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1):void
		{
			if ( alpha <= 0 )
				return;
				
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			/*if ( alpha == 1 )
			{
				DrawBitmapDataFast( bmd, sx, sy );
				return;
			}*/
			
			mBitmapColTr.alphaMultiplier = alpha;
			
			//lock();
			mDrawMatrix.tx = sx + mOffsetX;
			mDrawMatrix.ty = sy + mOffsetY;
			draw(bmd, mDrawMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
			//copyPixels( bmd, bmd.rect, new Point(sx+mOffsetX,sy+mOffsetY) );
			
			//unlock();
		}
		// ============================================================
		public function DrawBitmapDataScaled(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, scaleX:Number=1, scaleY:Number=1):void
		{
			if ( alpha <= 0 )
				return;

			mBitmapColTr.alphaMultiplier = alpha;
			mDrawRotMatrix.identity();		// reset matrix to defaults
			
			mDrawRotMatrix.scale( scaleX, scaleY );
			
			mDrawRotMatrix.tx += sx + mOffsetX;
			mDrawRotMatrix.ty += sy + mOffsetY;
			
			draw( bmd, mDrawRotMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );

			//copyPixels( bmd, bmd.rect, new Point(sx+mOffsetX,sy+mOffsetY) );
			
			//unlock();
		}
		// ============================================================
		public function DrawBitmapDataCentered(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1):void
		{
			if ( alpha <= 0 )
				return;
			
			/*var hw:int = int(bmd.width * 0.5);
			var hh:int = int(bmd.height * 0.5);*/
			
			var hw:int = bmd.width >> 1;
			var hh:int = bmd.height >> 1;
			
			/*if ( alpha == 1 )
			{
				DrawBitmapDataFast( bmd, sx-hw, sy-hh );
				return;
			}*/
			
			mBitmapColTr.alphaMultiplier = alpha;
			
			//lock();
			mDrawMatrix.tx = sx + mOffsetX - hw;
			mDrawMatrix.ty = sy + mOffsetY - hh;
			draw(bmd, mDrawMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
			//copyPixels( bmd, bmd.rect, new Point(sx+mOffsetX,sy+mOffsetY) );
			
			//unlock();
		}
		// ============================================================
		private var mTmpCenterPoint:NPoint = new NPoint();
		public function DrawBitmapDataFastCentered(bmd:BitmapData, sx:Number, sy:Number):void
		{
			var hw:int = bmd.width >> 1;
			var hh:int = bmd.height >> 1;
			
			mDrawMatrix.tx = sx + mOffsetX - hw;
			mDrawMatrix.ty = sy + mOffsetY - hh;
			//draw(bmd, mDrawMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
			//copyPixels( bmd, bmd.rect, new Point(sx+mOffsetX,sy+mOffsetY) );
			mTmpCenterPoint.Init( sx - hw, sy - hh );
			copyPixels( bmd, bmd.rect, mTmpCenterPoint, null, null, true );
		}
		// ============================================================
		private var mDrawRotMatrix:Matrix = new Matrix(1, 0, 0, 1);
		private var mHalfScale:Number;
		private var mHalfW:Number, mHalfH:Number;
		public function DrawBitmapDataRot(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, angle:Number = 0, scaleFactor:Number = 1):void
		{
			if ( alpha <= 0 )
				return;

			mBitmapColTr.alphaMultiplier = alpha;
			mDrawRotMatrix.identity();		// reset matrix to defaults
			
			mHalfScale = 0.5 * scaleFactor;
			mHalfW = bmd.width * mHalfScale;
			mHalfH = bmd.height * mHalfScale;
			
			mDrawRotMatrix.scale( scaleFactor, scaleFactor );
			mDrawRotMatrix.translate( -mHalfW, -mHalfH );
			
			if ( angle != 0 )
				mDrawRotMatrix.rotate( angle );
			
			mDrawRotMatrix.tx += sx + mOffsetX;
			mDrawRotMatrix.ty += sy + mOffsetY;
			
			draw(bmd, mDrawRotMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
		}
		// ============================================================
		/**
		 * Данный метод отличается от DrawBitmapDataRot тем, что центрирует поворачиваемое изображение только по ширине
		 * @param	bmd
		 * @param	sx
		 * @param	sy
		 * @param	alpha
		 * @param	angle
		 * @param	scaleFactor
		 */
		private var mZeroCenterOffset:NPoint = new NPoint();
		public function DrawBitmapRotFreeCenter(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, angle:Number = 0, scaleFactor:Number = 1, centerOffset:NPoint = null ):void
		{
			if ( alpha <= 0 )
				return;

			mBitmapColTr.alphaMultiplier = alpha;
			mDrawRotMatrix.identity();		// reset matrix to defaults
			
			if ( !centerOffset ) centerOffset = mZeroCenterOffset;	// чтобы избавиться от выделения памяти ( new NPoint() )
			
			if ( scaleFactor != 1 )
			{
				mDrawRotMatrix.scale( scaleFactor, scaleFactor );
				mHalfW = centerOffset.x * scaleFactor;
				mHalfH = centerOffset.y * scaleFactor;
			}
			else
			{
				mHalfW = centerOffset.x;
				mHalfH = centerOffset.y;
			}
			mDrawRotMatrix.translate( -mHalfW, -mHalfH );
			
			if ( angle != 0 )
				mDrawRotMatrix.rotate( angle );
			
			mDrawRotMatrix.tx += sx + mOffsetX;
			mDrawRotMatrix.ty += sy + mOffsetY;
			
			draw(bmd, mDrawRotMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
		}
		// ============================================================
		private var part_r:Rectangle = new Rectangle();
		private var startPnt:Point = new Point();
		
		public function DrawBitmapDataPart(bmd:BitmapData, sx:Number, sy:Number, offx:Number = 0, offy:Number = 0, w:Number = 0, h:Number = 0):void
		{
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			part_r.x = offx;
			part_r.y = offy;
			part_r.width = w;
			part_r.height = h;
			
			startPnt.x = sx + mOffsetX;
			startPnt.y = sy + mOffsetY;
			
			//lock();
			copyPixels( bmd, part_r, startPnt, null, null, true );
			// clipRect можно и в draw указать
			//unlock();
			
			//trace( "HERE !!!" );
		}
		// ============================================================
		private var mScaleRect:Rectangle = new Rectangle();
		public function DrawBitmapDataPartScaled(bmd:BitmapData, sx:Number, sy:Number, part:NRect, scaleX:Number = 1, scaleY:Number = 1, alpha:Number = 1 ):void
		{
			if ( alpha <= 0 )
				return;

			mBitmapColTr.alphaMultiplier = alpha;
			mDrawRotMatrix.identity();		// reset matrix to defaults
			
			mDrawRotMatrix.scale( scaleX, scaleY );
			mDrawRotMatrix.translate( -part.Left*scaleX, -part.Top*scaleY );
			
			mDrawRotMatrix.tx += sx + mOffsetX;
			mDrawRotMatrix.ty += sy + mOffsetY;
			
			mScaleRect.x = sx;
			mScaleRect.y = sy;
			mScaleRect.width = part.Width * scaleX;
			mScaleRect.height = part.Height * scaleY;
			
			draw(bmd, mDrawRotMatrix, mBitmapColTr, BlendMode.NORMAL, mScaleRect, true );
		}
		// ============================================================
		public function DrawBitmapDataFast(bmd:BitmapData, sx:Number, sy:Number):void
		{
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			startPnt.x = sx + mOffsetX;
			startPnt.y = sy + mOffsetY;
			
			//bmd.lock();	- без них вроде немного быстрее  ХЗ...
			copyPixels( bmd, bmd.rect, startPnt, null, null, true );
			//bmd.unlock();
		}
		// ============================================================
		private var offsetRect:Rectangle = new Rectangle();
		public function FillRect(rect:Rectangle, color:int):void
		{
			offsetRect.x = rect.x + mOffsetX;
			offsetRect.y = rect.y + mOffsetY;
			offsetRect.width = rect.width;
			offsetRect.height = rect.height;
			
			fillRect( offsetRect, color );
		}
		// ============================================================
		public override function FillNRect(rect:NRect, color:int):void
		{
			offsetRect.x = rect.Position.x + mOffsetX;
			offsetRect.y = rect.Position.y + mOffsetY;
			offsetRect.width = rect.Size.Width;
			offsetRect.height = rect.Size.Height;
			
			fillRect( offsetRect, color );
		}
		// ============================================================
		public function DrawRect( rect:Rectangle, color:int ):void
		{
			offsetRect.width = rect.width;
			offsetRect.height = rect.height;
			offsetRect.x = rect.x + mOffsetX;
			offsetRect.y = rect.y + mOffsetY;
			
			DrawHorLine( offsetRect.x, offsetRect.right, offsetRect.y, color );
			DrawHorLine( offsetRect.x, offsetRect.right, offsetRect.bottom, color );
			DrawVerLine( offsetRect.x, offsetRect.y, offsetRect.bottom, color );
			DrawVerLine( offsetRect.right, offsetRect.y, offsetRect.bottom, color );
		}
		// ============================================================
		private var matrix:Matrix = new Matrix();
		public function BlitOn(g:Graphics, sx:Number, sy:Number):void
		{
			matrix.translate( sx, sy );
			
			if ( mIsLocked )
			{
				unlock();
				mIsLocked = false;
			}
			
			g.clear();
			//lock();
			g.beginBitmapFill( this, matrix, false, false );
			g.drawRect( 0, 0, width, height );
			g.endFill();
			//unlock();
			
			if ( !mIsLocked )
			{
				lock();
				mIsLocked = true;
			}
			
			matrix.translate( -sx, -sy );
		}
		// ============================================================
		public function SetOffset( x:Number, y:Number ):void
		{
			mOffsetX = x;
			mOffsetY = y;
		}
		// ============================================================
		public function ResetOffset():void
		{
			SetOffset( 0, 0 );
		}
		// ============================================================
		public function AddOffset( x:Number, y:Number ):void
		{
			mOffsetX += x;
			mOffsetY += y;
		}
		// ============================================================
		public function Destroy():void
		{
			if ( mIsLocked )
			{
				mIsLocked = false;
				unlock();
			}
			dispose();
		}
		// ============================================================
		private var mBlur:BlurFilter = new BlurFilter();
		private var mZeroPoint:Point = new Point();
		public function DoBlur():void
		{
			applyFilter( this, this.rect, mZeroPoint, mBlur );
		}
		// ============================================================
	}
	
}