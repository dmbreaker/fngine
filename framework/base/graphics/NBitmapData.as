package base.graphics
{
	import base.types.*;
	import base.utils.SimpleProfiler;
	import base.utils.TextGen;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NBitmapData extends BitmapData
	{
		// ============================================================
		
		// ============================================================
		public function NBitmapData(_width:int, _height:int, transparent:Boolean = true, fillColor:uint = 0x0)
		{
			super(_width, _height, transparent, fillColor);
			
		}
		// ============================================================
		public function Clear():void
		{
			this.fillRect( rect, 0 );
		}
		// ============================================================
		public function FillNRect( rect:NRect, color:int ):void 
		{
			this.fillRect( rect.RectangleLinked, color );
		}
		// ============================================================
		public function TransformColor( r:int, g:int, b:int ):void
		{
			var ct:ColorTransform = new ColorTransform( 1, 1, 1, 1, r, g, b );
			this.colorTransform( this.rect, ct );
		}
		// ============================================================
		public function ResetColorTransform():void
		{
			this.colorTransform( this.rect, new ColorTransform() );
		}
		// ============================================================
		public function AlphaBlend( alpha:Number ):void
		{
			var ct:ColorTransform = new ColorTransform( 1, 1, 1, alpha );
			this.colorTransform( this.rect, ct );
		}
		// ============================================================
		public function MixInBitmap( mixin:BitmapData, pos:NPoint ):void
		{
			//var result:BitmapData;
			//result = new BitmapData( bmdDest.width, bmdDest.height, true, 0 );	// чтобы всегда изображение содержало прозрачность
			//result.draw( bmdDest );
			//result.copyPixels( bmdMixin, bmdMixin.rect, pos, null, null, true );
			
			copyPixels( mixin, mixin.rect, pos, null, null, true );
		}
		// ============================================================
		public static function CreateFromBitmap( bmdata:BitmapData ):NBitmapData
		{
			var nbmd:NBitmapData = new NBitmapData( bmdata.width, bmdata.height );
			nbmd.MixInBitmap( bmdata, new NPoint() );
			return nbmd;
		}
		// ============================================================
		/**
		 * Makes a shadow of content
		 */
		public function ShadowMe( blurX:int, blurY:int, blurCount:int ):void 
		{
			MakeGrayScale( 0.1, 0.6 );
			applyFilter( this, rect, new Point(), new BlurFilter( blurX, blurY, blurCount ) );
		}
		// ============================================================
		public function BlurMe( blurX:int, blurY:int, blurCount:int ):void 
		{
			applyFilter( this, rect, new Point(), new BlurFilter( blurX, blurY, blurCount ) );
		}
		// ============================================================
		public function MakeGrayScale( k:Number = 1, a:Number = 1 ):void 
		{
			var val:Number = 0.33 * k;
			var matrix:Array = new Array();
			matrix = matrix.concat([val, val, val, 0, 0]); // red
			matrix = matrix.concat([val, val, val, 0, 0]); // green
			matrix = matrix.concat([val, val, val, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, a, 0]); // alpha
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			
			applyFilter(this, rect, new Point(), filter);
		}
		// ============================================================
		public function Clone():NBitmapData 
		{
			var nbmd:NBitmapData = new NBitmapData( width, height, transparent, 0 );
			nbmd.lock();
			nbmd.copyPixels( this, rect, new Point() );
			nbmd.unlock();
			return nbmd;
		}
		// ============================================================
		private var sizeTmp:NSize = new NSize();
		private var matrixTmp:Matrix = new Matrix();
		private var rectTmp:NRect = new NRect(0, 0, 1000000, 1000000);
		public function DrawText( text:String, font:ImageFont, rect:NRect, halign:int = -1, valign:int = -1 ):void
		{
		SimpleProfiler.Start( "DrawText" );
			var r:NRect = rect.Clone();
			
			if ( font.IsTTFont )	// TTF rendering
			{
				sizeTmp.Reset();
				var tblock:TextBlock = TextGen.CreateTextBlock( text, font.Name, { size:font.Size, color:font.Color, bold:font.Bold, max_width:rect.Width } );
				var size:NSize = sizeTmp;
				
				var lineY:Number = 0;
				var rZ:NRect = rect || rectTmp;
		
				//@ memory allocation
				var tlines:Vector.<TextLine> = new Vector.<TextLine>();
				var tline:TextLine = tblock.createTextLine( null, rZ.Width );
				
				while (tline)
				{
					tlines.push( tline );
					size.Height += tline.height;
					tline.y = size.Height;
					if ( sizeTmp.Width < tline.width ) sizeTmp.Width = tline.width;
					size.Height += tline.descent;
					
					tline = tblock.createTextLine( tline, rZ.Width );
				}
				
				var sx:Number = 0;
				var sy:Number = 0;
				if ( valign == 0 )		sy = (r.Height - size.Height) * 0.5;
				else if ( valign > 0 )	sy = (r.Height - size.Height);

				var m:Matrix = matrixTmp;
				for each (var tl:TextLine in tlines) 
				{
					m.identity();
					//var rct:Rectangle = tline.getBounds(Global.Core);
					//m.translate( sx + r.Position.x - rct.x, sy + r.Position.y - rct.y );
					if ( halign == 0 )		sx = (r.Width - tl.width) * 0.5;
					else if ( halign > 0 )	sx = (r.Width - tl.width);
					
					m.translate( sx + r.Position.x + mOffsetX, sy + r.Position.y + tl.y + mOffsetY );
					draw( tl, m, null, BlendMode.NORMAL, null, false );
				}
				tblock = null;
			}
			else
			{
				if ( font.IsTextMultiline( text, rect ) )
				{
					var line_start_pos:NPoint = rect.Position.Clone();
					var strings:Array = font.SplitTextToLines( text, rect );
					for each( var s:String in strings )
					{
						DrawOneLine( s, font, line_start_pos, rect, halign, valign );
						line_start_pos.y += font.mMaxCharHeight + font.Leading;
					}
				}
				else
				{
					var shift:NPoint = DoOneLineAlignment( text, r, font, halign, valign );

					var pos:NPoint = r.Position.Clone();
					pos.offset( shift.x, shift.y );
					var right:Number = r.Right;
					var bottom:Number = r.Bottom;
				
					var count:int = text.length;
					for (var i:int = 0; i < count; i++)
					{
						var chIndex:int = int(text.charCodeAt(i));
						var chData:CharData = font.GetCharData( chIndex );
						if ( !chData ) continue;
						var bmpRect:NRect = chData.BitmapRect;
						var bmpPos:NPoint = bmpRect.Position;
						var bmpSize:NSize = bmpRect.Size;
					
						if ( pos.x + bmpSize.Width + font.Kerning > right )
						{
							pos.x = r.Position.x;
							pos.y += font.mMaxCharHeight + font.Leading;	// можно менять расстояние между строками
						}
					
						if ( pos.y > bottom )
							return;
					
						DrawChar( font.mBitmapData, pos, chData.BitmapRect.RectangleLinked );
					
						pos.x += bmpSize.Width + font.Kerning;
					}
				}
			}
		SimpleProfiler.Stop( "DrawText" );
		}
		// ============================================================
		/**
		 * Рисует одну строку. TODO: нужен серьезный рефакторинг всего, что связано с отрисовкой текста
		 * @param	text
		 * @param	font
		 * @param	start_pos
		 * @param	r
		 * @param	halign
		 * @param	valign
		 */
		private function DrawOneLine( text:String, font:ImageFont, start_pos:NPoint, r:NRect, halign:int = -1, valign:int = -1 ):void
		{
			var shift:NPoint = DoOneLineAlignment( text, r, font, halign, valign );

			var pos:NPoint = start_pos.Clone();
			pos.offset( shift.x, shift.y );
			
			var count:int = text.length;
			for (var i:int = 0; i < count; i++)
			{
				var chIndex:int = int(text.charCodeAt(i));
				var chData:CharData = font.GetCharData( chIndex ) as CharData;
				if ( !chData ) continue;
				
				var bmpRect:NRect = chData.BitmapRect;
				var bmpPos:NPoint = bmpRect.Position;
				var bmpW:Number = bmpRect.Size.Width;
				
				/*if ( pos.x + bmpSize.Width + font.Kerning > right )
				{
					pos.x = r.Position.x;
					pos.y += font.mMaxCharHeight + font.Leading;	// можно менять расстояние между строками
				}*/
				
				DrawChar( font.mBitmapData, pos, chData.BitmapRect.RectangleLinked );
				
				pos.x += bmpW + font.Kerning;
			}
		}
		// ============================================================
		// ============================================================
		private function DrawChar( bd:BitmapData, pos:Point, charRect:Rectangle ):void
		{
			//this.copyPixels( bd, charRect, pos );
			this.copyPixels( bd, charRect, pos, null, null, true );
		}
		// ============================================================
		//public function MeasureString( text:String, font:ImageFont, rect:NRect, halign:int = -1, valign:int = -1 ):void
		//{
			//var r:NRect = new NRect();
			//r.CopyFrom( rect );
			//
			//DoAlignment( text, r, font, halign, valign );
//
			//var pos:NPoint = new NPoint();
			//pos.CopyFrom( r.Position );
			//var right:Number = r.Right;
			//var bottom:Number = r.Bottom;
			//
			//var count:int = text.length;
			//for (var i:int = 0; i < count; i++)
			//{
				//var chData:CharData = font.GetCharData( int(text.charCodeAt(i)) );
				//if ( !chData ) continue;
				//var bmpRect:NRect = chData.BitmapRect;
				//var bmpPos:NPoint = bmpRect.Position;
				//var bmpSize:NSize = bmpRect.Size;
				//
				//if ( pos.x + bmpSize.Width + font.Kerning > right )
				//{
					//pos.x = r.Position.x;
					//pos.y += font.mMaxCharHeight + font.Leading;	// можно менять расстояние между строками
				//}
				//
				//if ( pos.y > bottom )
					//return;
				//
				//DrawChar( font.mBitmapData, pos, chData.BitmapRect.RectangleLinked );
				//
				//pos.x += bmpSize.Width + font.Kerning;
			//}
		//}
		// ============================================================
		/**
		 * Делает выранивание, НО НЕ учитывает перенос строк!
		 * @param	text
		 * @param	rect
		 */
		private function DoOneLineAlignment( text:String, rect:NRect, font:ImageFont, halign:int, valign:int ):NPoint
		{
			//@ memory allocation
			var shift:NPoint = new NPoint();
			var shift_hor:Number = 0;
			var shift_ver:Number = 0;
			var pix_width:Number = font.MeasureStringLength( text );
			//var pix_size:NSize = font.MeasureStringSize( text );
			//var pix_width:Number = pix_size.Width;
			//var pix_height:Number = pix_size.Height;
			
			if ( halign == 0 )
			{
				shift_hor = (rect.Size.Width - pix_width) * 0.5;
				shift.x = shift_hor;
			}
			else if ( halign == 1 )
			{
				shift_hor = rect.Size.Width - pix_width;
				shift.x = shift_hor;
			}
			
			if ( valign == 0 )
			{
				//shift_ver = (rect.Size.Height - pix_height) * 0.5;
				shift_ver = (rect.Size.Height - font.mMaxCharHeight) * 0.5;
				shift.y = shift_ver;
			}
			else if ( valign == 1 )
			{
				//shift_ver = rect.Size.Height - pix_height;// font.mMaxCharHeight;
				shift_ver = rect.Size.Height - font.mMaxCharHeight;
				shift.y = shift_ver;
			}
			
			return shift;
		}
		// ============================================================
		public function DrawNRect( r:NRect, color:int ):void
		{
			var x:Number = r.Position.x;
			var y:Number = r.Position.y;
			var w:Number = r.Width;
			var h:Number = r.Height;
			var right:Number = x + w;
			var bottom:Number = y + h;
			
			
			DrawHorLine( x, right, y, color );
			DrawHorLine( x, right, bottom, color );
			DrawVerLine( x, y, bottom, color );
			DrawVerLine( right, y, bottom, color );
		}
		// ============================================================
		public function DrawHorLine( beginx:Number, endx:Number, y:Number, color:int ):void
		{
			lock();
			
			var x:Number;
			if ( endx > beginx )
			{
				for (x = beginx; x <= endx; x++)
				{
					setPixel32( x, y, color );
				}
			}
			else
			{
				for (x = endx; x <= beginx; x++)
				{
					setPixel32( x, y, color );
				}
			}
			
			unlock();
		}
		// ============================================================
		public function DrawVerLine( x:Number, beginy:Number, endy:Number, color:int ):void
		{
			lock();
			
			var y:Number;
			if ( endy > beginy )
			{
				for (y = beginy; y <= endy; y++)
				{
					setPixel32( x, y, color );
				}
			}
			else
			{
				for (y = endy; y <= beginy; y++)
				{
					setPixel32( x, y, color );
				}
			}
			
			unlock();
		}
		// ============================================================
		public function DrawLine(sx:Number, sy:Number, ex:Number, ey:Number, color:int):void
		{
			var srx:int = int( sx + 0.5 );
			var erx:int = int( ex + 0.5 );
			var sry:int = int( sy + 0.5 );
			var ery:int = int( ey + 0.5 );
			
			//trace( srx, sry, erx, ery );
			
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var perc:Number;
			var tx:int;
			var ty:int;
			var tmpx:int;
			var tmpy:int;

			
			var abs_dy:int = ery - sry;
			if ( abs_dy < 0 )
				abs_dy = -abs_dy;
			var abs_dx:int = erx - srx;
			if ( abs_dx < 0 )
				abs_dx = -abs_dx;
				
			lock();
			
			if( abs_dy > abs_dx )
			{
				if (sry > ery)
				{
					tmpx = srx; srx = erx; erx = tmpx;
					tmpy = sry; sry = ery; ery = tmpy;
					/*srx ^= erx ^= srx ^= erx;
					sry ^= ery ^= sry ^= ery;*/
				}
				var dy:int = (ery - sry);
				var rdy:Number = 1 / Number(dy);
				ax = Number(srx);
				ay = Number(sry);
				bx = Number(erx);
				by = Number(ery);
				//trace( ax, ay, bx, by );
				for (var y:Number = 0; y <= dy; y++)
				{
					perc = y*rdy;
					tx = InterpolateToInt(ax, bx, perc);
					ty = InterpolateToInt(ay, by, perc);
					setPixel(tx, ty, color);
				}
			} else {
				if (srx > erx)
				{
					tmpx = srx; srx = erx; erx = tmpx;
					tmpy = sry; sry = ery; ery = tmpy;
					/*srx ^= erx ^= srx ^= erx;
					sry ^= ery ^= sry ^= ery;*/
				}
				var dx:int = (erx - srx);
				var rdx:Number = 1 / Number(dx);
				ax = Number(srx);
				ay = Number(sry);
				bx = Number(erx);
				by = Number(ery);
				//trace( ax, ay, bx, by );
				for (var x:Number = 0; x <= dx; x++)
				{
					perc = x * rdx;
					tx = InterpolateToInt(ax, bx, perc);
					ty = InterpolateToInt(ay, by, perc);
					setPixel(tx, ty, color);
				}
			}
			
			unlock();
		}
		// ============================================================
		protected function InterpolateToInt( a:Number, b:Number, percent:Number ):int
		{
			//return int( a * percent + b * (1 - percent) + 0.5 );
			return int( a + (b - a) * (1 - percent) + 0.5 );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		protected var mOffsetX:Number = 0;
		protected var mOffsetY:Number = 0;
		protected var part_r:Rectangle = new Rectangle();
		protected var startPnt:Point = new Point();
		protected var mBitmapColTr:ColorTransform = new ColorTransform(1, 1, 1, 1);
		protected var mDrawMatrix:Matrix = new Matrix(1, 0, 0, 1);
		public function DrawImageBDNoAlpha(bmd:BitmapData, sx:Number, sy:Number):void
		{
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			startPnt.x = sx + mOffsetX;
			startPnt.y = sy + mOffsetY;
			
			copyPixels( bmd, bmd.rect, startPnt, null, null, false );
		}
		// ============================================================
		public function DrawImageBDFast(bmd:BitmapData, sx:Number, sy:Number):void
		{
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			startPnt.x = sx + mOffsetX;
			startPnt.y = sy + mOffsetY;
			
			copyPixels( bmd, bmd.rect, startPnt, null, null, true );
		}
		// ============================================================
		public function DrawImageBD(bmd:BitmapData, sx:Number, sy:Number, alpha:Number = 1):void
		{
			if ( alpha <= 0 )
				return;
				
			if ( !bmd )
			{
				trace( "### !!! BitmapGraphix: bmd is NULL" );
				return;
			}
			
			mDrawMatrix.tx = sx + mOffsetX;
			mDrawMatrix.ty = sy + mOffsetY;
				
			if ( alpha == 1 )
			{
				draw(bmd, mDrawMatrix, null, BlendMode.NORMAL, null, true );
			}
			else
			{
				mBitmapColTr.alphaMultiplier = alpha;
				draw(bmd, mDrawMatrix, mBitmapColTr, BlendMode.NORMAL, null, true );
			}
		}
		// ============================================================
	}
	
}