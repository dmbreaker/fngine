package base.graphics
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.BlendMode;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SpriteGraphix extends Sprite implements IGraphix
	{
		// ============================================================
		private var mMatrix:Matrix = new Matrix();
		private var mSavedOffsetX:Number;
		private var mSavedOffsetY:Number;
		
		private var mTemporarySprite:Sprite = new Sprite();
		// ============================================================
		public function SpriteGraphix()
		{
			//addChild(mTemporarySprite);
		}
		// ============================================================
		private function SetTranslation( sx:Number, sy:Number ):void
		{
			mSavedOffsetX = mMatrix.tx;
			mSavedOffsetY = mMatrix.ty;
			
			mMatrix.tx += sx;
			mMatrix.ty += sy;
		}
		// ============================================================
		private function RestoreTranslation():void
		{
			mMatrix.tx = mSavedOffsetX;
			mMatrix.ty = mSavedOffsetY;
		}
		// ============================================================
		/* INTERFACE base.graphics.IGraphix */
		public function Clear():void
		{
			graphics.clear();
		}
		// ============================================================
		public function DrawBitmapData(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1):void
		{
			if ( alpha <= 0 )	// если рисовать нечего, то выйдем
				return;
			
			SetTranslation( sx, sy );
			var tx:Number = mMatrix.tx;
			var ty:Number = mMatrix.ty;
			//var bmdWasCreated:Boolean = false;
			
			//if ( alpha < 1 )	// если есть полупрозрачность
			//{
				//bmd = CreateBitmapDataWithAlpha( bmd, alpha );	// то создадим полупрозрачный вариант
				//bmdWasCreated = true;
			//}
			
			var bmdW:Number = bmd.width;
			var bmdH:Number = bmd.height;
			
			bmd.lock();
			//graphics.lineStyle( 1, 0x00ff00 );
			graphics.moveTo( tx, ty );
			graphics.beginBitmapFill( bmd, mMatrix, false, true );
			graphics.lineTo( tx+bmdW, ty );
			graphics.lineTo( tx+bmdW, ty+bmdH );
			graphics.lineTo( tx, ty+bmdH );
			//graphics.drawRect( 0, 0, bmd.width, bmd.height );
			graphics.endFill();
			bmd.unlock();
			
			//if ( bmdWasCreated )	// если создавали битмап с альфой
			//{
				//bmd.dispose();		// освободим его
				//bmd = null;			// и удалим
			//}
			
			RestoreTranslation();
		}
		// ============================================================
		public function DrawBitmapDataCentered(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1):void
		{
			if ( alpha <= 0 )	// если рисовать нечего, то выйдем
				return;
			
			SetTranslation( sx, sy );
			var tx:Number = mMatrix.tx - int(bmd.width*0.5);
			var ty:Number = mMatrix.ty - int(bmd.height*0.5);
			
			var bmdW:Number = bmd.width;
			var bmdH:Number = bmd.height;
			
			bmd.lock();
			
			graphics.moveTo( tx, ty );
			graphics.beginBitmapFill( bmd, mMatrix, false, true );
			graphics.lineTo( tx+bmdW, ty );
			graphics.lineTo( tx+bmdW, ty+bmdH );
			graphics.lineTo( tx, ty+bmdH );
			//graphics.drawRect( 0, 0, bmd.width, bmd.height );
			graphics.endFill();
			bmd.unlock();
			
			RestoreTranslation();
		}
		// ============================================================
		public function DrawBitmapDataFast( bmd:BitmapData, sx:Number, sy:Number ):void
		{
			DrawBitmapData( bmd, sx, sy );
		}
		// ============================================================
		public function DrawBitmapDataRot(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1, angle:Number = 0, scaleFactor:Number = 1):void
		{
			// not implemented
		}
		// ============================================================
		/*private var mCT:ColorTransform = new ColorTransform(1, 1, 1, 1);	// менять можно только альфу
		private function CreateBitmapDataWithAlpha( bmd:BitmapData, alpha:Number ):BitmapData
		{
			var g:Graphics = mTemporarySprite.graphics;

			g.clear();				// чистим то, что было в буфере ранее
			bmd.lock();
			
			//g.lineStyle( 1, 0x00ff00 );
			g.moveTo( 0, 0 );
			g.beginBitmapFill( bmd );
			g.drawRect( 0, 0, bmd.width, bmd.height );
			g.endFill();
			
			bmd.unlock();
			
			//trace( "TEMP: ", mTemporarySprite.width, mTemporarySprite.height );
			var result:BitmapData = new BitmapData( mTemporarySprite.width, mTemporarySprite.height, true, 0 );
			mCT.alphaMultiplier = alpha;
			result.draw( mTemporarySprite, null, mCT, BlendMode.NORMAL, null, true );
			g.clear();

			return result;
		}*/
		// ============================================================
		public function DrawBitmapDataPart(bmd:BitmapData, sx:Number, sy:Number, offx:Number = 0, offy:Number = 0, w:Number = 0, h:Number = 0):void
		{
			SetTranslation( sx - offx, sy - offy );
			var tx:Number = mMatrix.tx + offx;
			var ty:Number = mMatrix.ty + offy;
			
			if ( w == 0 && h == 0 )
			{
				w = bmd.width;
				h = bmd.height;
			}
			
			bmd.lock();
			graphics.moveTo( tx, ty );
			graphics.beginBitmapFill( bmd, mMatrix );
			graphics.lineTo( tx+w, ty );
			graphics.lineTo( tx+w, ty+h );
			graphics.lineTo( tx, ty+h );
			//graphics.drawRect( 0, 0, bmd.width, bmd.height );
			graphics.endFill();
			bmd.unlock();
			
			RestoreTranslation();
		}
		// ============================================================
		//public function DrawString( text:String, font:ImageFont, horAlign:int ):void
		//{
			//
		//}
		// ============================================================
		// ============================================================
		// ============================================================
		
		public function DrawSpecialSprite(bmp:SpecialSprite, sx:Number, sy:Number):void
		{
			SetTranslation( sx, sy );
			var tx:Number = mMatrix.tx;
			var ty:Number = mMatrix.ty;
			var bmd:BitmapData = bmp.GetCurrentFrame();
			
			bmd.lock();
			graphics.moveTo( tx, ty );
			graphics.beginBitmapFill( bmd, mMatrix, false, false );
			graphics.lineTo( tx+bmd.width, ty );
			graphics.lineTo( tx+bmd.width, ty+bmd.height );
			graphics.lineTo( tx, ty+bmd.height );
			graphics.drawRect( 0, 0, bmd.width, bmd.height );
			graphics.endFill();
			bmd.unlock();
			
			RestoreTranslation();
		}
		
		public function FillRect( rect:Rectangle, color:int ):void
		{
			graphics.beginFill( color );
			graphics.drawRect( rect.x + mMatrix.tx, rect.y + mMatrix.ty, rect.width, rect.height );
			graphics.endFill();
		}
		
		public function BlitOn( g:Graphics, sx:Number, sy:Number ):void
		{
			// do nothing
		}
		
		public function SetOffset( x:Number, y:Number ):void
		{
			mMatrix.tx = x;
			mMatrix.ty = y;
		}
		
		public function ResetOffset():void
		{
			SetOffset( 0, 0 );
		}
		// ============================================================
		public function AddOffset( x:Number, y:Number ):void
		{
			mMatrix.tx += x;
			mMatrix.ty += y;
		}
		// ============================================================
		public function DrawRect( rect:Rectangle, color:int ):void
		{
			graphics.lineStyle( 1, color );
			graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
		}
		// ============================================================
		public function Destroy():void
		{
			Clear();
			parent.removeChild( this );	// is it normal?
		}
		
	}
	
}