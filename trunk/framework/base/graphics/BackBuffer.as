
package base.graphics
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;


	public class BackBuffer extends BitmapData
	{
		//[Embed(source = '../../res/fonts/NEURM.TTF', fontName = "neurm", unicodeRange = "U+0020-U+007F, U+00A0-U+00FF, U+0400-U+04FF")]
		//public var GameFont:Class;

		// ============================================================
		private var mTF:TextField = new TextField();
		private var mTFRight:TextField = new TextField();
		private var mTFCenter:TextField = new TextField();
		private var mTFormat:TextFormat = new TextFormat();
		// ============================================================
		public function BackBuffer(width:int, height:int, transparent:Boolean = true, fillColor:uint = 0x0)
		{
			super(width, height, transparent, fillColor);
			
			//mTFormat.font = "neurm";
			mTF.setTextFormat( mTFormat );
			mTF.embedFonts = true;
			mTFRight.embedFonts = true;
			mTFRight.autoSize = TextFieldAutoSize.NONE;
			mTFCenter.embedFonts = true;
			mTFCenter.autoSize = TextFieldAutoSize.NONE;
		}
		// ============================================================
		public function Clear():void
		{
			this.fillRect( new Rectangle(0, 0, width, height), 0xff000000 );
			//this.fillRect( new Rectangle(0, 0, width, height), 0xffffffff );
		}
		// ============================================================
		public function DrawSprite( s:Sprite, sx:Number, sy:Number ):void
		{
			lock();
			draw(s, new Matrix(1, 0, 0, 1, sx, sy));
			unlock();
		}
		// ============================================================
		public function DrawBitmap( bmp:Bitmap, sx:Number, sy:Number ):void
		{
			lock();
			draw(bmp, new Matrix(1, 0, 0, 1, sx, sy));
			unlock();
		}
		// ============================================================
		public function DrawBitmapData( bmd:BitmapData, sx:Number, sy:Number ):void
		{
			lock();
			draw(bmd, new Matrix(1, 0, 0, 1, sx, sy));
			unlock();
		}
		// ============================================================
		public function DrawSpecialSprite( bmp:SpecialSprite, sx:Number, sy:Number ):void
		{
			var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, bmp.Brightness, bmp.Brightness, bmp.Brightness);
			
			lock();
			var m:Matrix = new Matrix(1, 0, 0, 1);// , sx, sy);
			m.scale( bmp.ScaleX, bmp.ScaleY );
			m.translate( sx, sy );
			
			draw(bmp.GetCurrentFrame(), m, ct, null, null, true );
			//fillRect( new Rectangle( sx, sy, bmp.CurrentWidth, bmp.CurrentHeight ), 0x00ff00 );
			unlock();
		}
		// ============================================================
		public function DrawSpecialSpriteRot( bmp:SpecialSprite, sx:Number, sy:Number, angle:Number, cx:Number, cy:Number ):void
		{
			var ct:ColorTransform = new ColorTransform(1, 1, 1, 1, bmp.Brightness, bmp.Brightness, bmp.Brightness);
			
			lock();
			var m:Matrix = new Matrix(1, 0, 0, 1);// , sx, sy);
			m.scale( bmp.ScaleX, bmp.ScaleY );
			//m.translate( cx, cy );
			m.translate( -cx, -cy );
			m.rotate( angle );
			m.translate( cx, cy );
			//m.translate( -cx, -cy );
			m.translate( sx, sy );
			
			draw(bmp.GetCurrentFrame(), m, ct);
			//this.fillRect( new Rectangle(sx, sy, bmp.GetBitmapData().width, bmp.GetBitmapData().height), 0x00ff00 );
			unlock();
		}
		// ============================================================
		public function SetTextSize( size:Number ):void
		{
			mTFormat.size = size;
		}
		// ============================================================
		public function DrawText( txt:String, cx:Number, cy:Number, color:uint ):void
		{
			mTF.text = txt;
			mTF.width += 20;
			mTF.textColor = color;
			mTFormat.align = TextFormatAlign.LEFT;
			mTF.setTextFormat( mTFormat );
			var m:Matrix = new Matrix(1, 0, -0.5, 1, cx, cy);
			this.draw( mTF, m );
		}
		// ============================================================
		public function DrawTextRight( txt:String, cx:Number, cy:Number, color:uint, width:Number ):void
		{
			mTFRight.text = txt;
			mTFRight.width = width;
			mTFRight.textColor = color;
			mTFormat.align = TextFormatAlign.RIGHT;
			mTFRight.setTextFormat( mTFormat );
			var m:Matrix = new Matrix(1, 0, -0.5, 1, cx, cy);
			this.draw( mTFRight, m );
		}
		// ============================================================
		public function DrawTextCenter( txt:String, cx:Number, cy:Number, color:uint, width:Number ):void
		{
			mTFCenter.text = txt;
			mTFCenter.width = width;
			mTFCenter.textColor = color;
			mTFormat.align = TextFormatAlign.CENTER;
			mTFCenter.setTextFormat( mTFormat );
			var m:Matrix = new Matrix(1, 0, -0.5, 1, cx, cy);
			this.draw( mTFCenter, m );
		}
		// ============================================================
		public function BlitBuffer( g:Graphics, xs:Number, ys:Number ):void
		{
			var m:Matrix = new Matrix();
			m.translate( xs, ys );
			
			g.clear();
			lock();
			g.beginBitmapFill( this, m, false, true );
			g.drawRect( 0, 0, width, height );
			g.endFill();
			unlock();

		}
		// ============================================================
		public function Destroy():void
		{
			mTF = null;
			mTFRight = null;
			mTFCenter = null;
			mTFCenter = null;
			
			dispose();
		}
		// ============================================================
	}
	
}
