package base.controls
{
	import base.graphics.BitmapGraphix;
	import base.graphics.ImageFont;
	import base.NRect;
	import flash.geom.Rectangle;
	
	/**
	 * Это будет контрол, который сможет отображать многострочный текст,
	 * и изображения в нем (с возможностью выравнивания по высоте, смещения в пикселях).
	 * Текст должен иметь возможность выравниваться по горизонтали, менять цвет,
	 * можно указывать шрифт.
	 * Скорее всего на вход лучше скармливать xml - быстрее будет сделать, нежели свой парсер писать :)
	 * @author dmBreaker
	 */
	public class NMultiText extends Control
	{
		// ============================================================
		public var Text:String = "";
		// ============================================================
		protected var mFont:ImageFont = null;
		// ============================================================
		// ============================================================
		public function NMultiText()
		{
			
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
		public override function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			if ( mFont )
			{
				var rect:NRect = new NRect();
				rect.CopyFrom( Rect );
				rect.Position.Reset();				// чтобы не проводилось повторного смещения координат
				mFont.DrawText( g, Text, rect );
			}
		}
		// ============================================================
	}
	
}