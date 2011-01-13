package base.utils
{
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.engine.*;

	/**
	 * ...
	 * @author dmbreaker
	 */
	public class TextGen
	{
		// ============================================================
		public static function CreateTextLine( text:String, fontName:String,
									params:* = null ):TextLine
		{
			var size:Number = 20;
			var color:uint = 0xFF000000;
			var bold:Boolean = false;
			var max_width:int = 3000;
			
			if ( params )
			{
				if ( params.size ) size = params.size;
				if ( params.color ) color = params.color;
				if ( params.bold ) bold = params.bold;
				if ( params.max_width ) max_width = params.max_width;
			}
			
			var fd:FontDescription = new FontDescription();
			fd.fontLookup = FontLookup.EMBEDDED_CFF;
			fd.fontName = fontName;
			fd.fontWeight = (bold) ? FontWeight.BOLD : FontWeight.NORMAL;
			//fd.fontPosture = FontPosture.NORMAL;
			//fd.renderingMode = RenderingMode.CFF;
			
			var ef:ElementFormat = new ElementFormat(fd);
			ef.color = color;
			ef.fontSize = size;
			
			var te:TextElement = new TextElement(text, ef);
			
			var tb:TextBlock = new TextBlock();
			tb.content = te;
			
			var textLine:TextLine = tb.createTextLine(null, max_width);
			
			return textLine;
		
			// fd.fontWeight = FontWeight.NORMAL; // will throw an error
			// Error 2185: FontDescription object is locked and cannot be modified
			// clone the font description
		}
		// ============================================================
		public static function CreateTextBlock( text:String, fontName:String,
									params:* = null ):TextLine
		{
			var size:Number = 20;
			var color:uint = 0xFF000000;
			var bold:Boolean = false;
			var max_width:int = 3000;
			
			if ( params )
			{
				if ( params.size ) size = params.size;
				if ( params.color ) color = params.color;
				if ( params.bold ) bold = params.bold;
				if ( params.max_width ) max_width = params.max_width;
			}
			
			var fd:FontDescription = new FontDescription();
			fd.fontLookup = FontLookup.EMBEDDED_CFF;
			fd.fontName = fontName;
			fd.fontWeight = (bold) ? FontWeight.BOLD : FontWeight.NORMAL;
			//fd.fontPosture = FontPosture.NORMAL;
			//fd.renderingMode = RenderingMode.CFF;
			
			var ef:ElementFormat = new ElementFormat(fd);
			ef.color = color;
			ef.fontSize = size;
			
			var te:TextElement = new TextElement(text, ef);
			
			var tb:TextBlock = new TextBlock();
			tb.content = te;
			
			var textLine:TextLine = tb.createTextLine(null, max_width);
			
			return textLine;
		
			// fd.fontWeight = FontWeight.NORMAL; // will throw an error
			// Error 2185: FontDescription object is locked and cannot be modified
			// clone the font description
		}
		// ============================================================
	}

}