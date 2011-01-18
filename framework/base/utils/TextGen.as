package base.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
									params:* = null ):TextBlock
		{
			var vec:Vector.<ContentElement> = new Vector.<ContentElement>();	// all text items here
			
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
			
			var curColor:uint = color;
			
			var fd:FontDescription = new FontDescription();
			fd.fontLookup = FontLookup.EMBEDDED_CFF;
			fd.fontName = fontName;
			//fd.fontWeight = FontWeight.NORMAL;
			//fd.fontPosture = FontPosture.NORMAL;
			//@ fd.fontWeight = (bold) ? FontWeight.BOLD : FontWeight.NORMAL;

			
			// firstly split text and images:
			var items:Array = text.split("|");
			
			// алгоритмы неверные! Пока только для тестового использования
			
			var i:int;
			for ( i = 0; i < items.length; i++ )
			{
				var stringLine:String = items[i];
				if ( (i & 1) )	// image (неверный алгоритм, если первое будет изображение, то скосячит)
				{
					var bmd:BitmapData = RM.GetImage( stringLine );	// get an image
					var bmp:Bitmap = new Bitmap( bmd );
					var grEl:GraphicElement = new GraphicElement( bmp, bmd.width, bmd.height );
					vec.push( grEl );
					grEl.elementFormat = new ElementFormat(fd);
				}
				else			// text
				{
					var subitems:Array = stringLine.split("^");

					for (var j:int = 0; j < subitems.length; j++) 
					{
						var subitem:String = subitems[j];
					
						if ( (j & 1) && subitems.length > 1 )	// цвет
						{
							curColor = uint("0xff" + subitem);
						}
						else				// текст
						{
							var ef:ElementFormat = new ElementFormat(fd);
							ef.color = curColor;
							ef.fontSize = size;
							
							var te:TextElement = new TextElement(subitem, ef);

							vec.push( te );
						}
					}
				}
			}
			
			
			var groupElement:GroupElement = new GroupElement( vec );
			
			var tb:TextBlock = new TextBlock();
			tb.content = groupElement;
			
			return tb;
			
			//var textLine:TextLine = tb.createTextLine(null, max_width);
			//return textLine;
		}
		// ============================================================
	}

}