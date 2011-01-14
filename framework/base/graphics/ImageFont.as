package base.graphics
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import base.utils.Key;
	import base.types.*;
	import base.parsers.CharDataXmlParser;
	import flash.text.engine.TextBlock;

	import base.utils.TextGen;
	import flash.text.engine.TextLine;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class ImageFont
	{
		// ============================================================
		internal var mBitmapData:BitmapData;
		private var mCharsData:Array;	// аррэй из элементов CharData
		// ============================================================
		public var Name:String;
		
		// для TTF шрифтов:
		public var Size:Number = 0;
		public var Color:uint = 0xFF000000;
		public var Bold:Boolean = false;
		
		public var IsTTFont:Boolean = false;
		// ============================================================
		private var mHorAlignment:int = 0;
		private var mVerAlignment:int = 0;
		private var mWordWrap:Boolean = true;
		private var mKerning:int = 0;
		private var mLeading:int = 0;
		
		internal var mMaxCharHeight:int = 0;
		// ============================================================
		public function ImageFont( name:String, bmd:BitmapData, xml_name:String )
		{
			if ( name.charAt(0) == ":" )
			{
				var font_params:String = name.substring(1);
				var params:Array = font_params.split(";");
				Name = params[0];	// 0 - всегда имя
				Size = Number(params[1]);	// 1 - всегда размер
				Color = uint(params[2]);	// 2 - всегда цвет шрифта
				Bold = Boolean(params[3]);	// 3 - всегда жирный ли шрифт
				IsTTFont = true;
				
				bmd = null;
				mCharsData = null;
			}
			else
			{
				IsTTFont = false;
				Name = name;
				mBitmapData = bmd.clone();	// чтобы операции над одним шрифтом не отражлись на других контролах
			
				mCharsData = new CharDataXmlParser().Parse( xml_name );
			
				// определим самый высокий символ - на него будем ориентироваться при учете высоты строк:
				for (var i:int = 0; i < mCharsData.length; i++)
				{
					var charData:CharData = mCharsData[i];
					if ( charData != null )
					{
						if ( mMaxCharHeight < charData.BitmapRect.Size.Height )
							mMaxCharHeight = charData.BitmapRect.Size.Height;
					}
				}
			}
		}
		// ============================================================
		public function set HorizontalAlignment( value:int ):void
		{
			mHorAlignment = value;
		}
		// ============================================================
		public function set VerticalAlignment( value:int ):void
		{
			mVerAlignment = value;
		}
		// ============================================================
		public function set WordWrap( value:Boolean ):void
		{
			mWordWrap = value;
		}
		// ============================================================
		public function set Kerning( value:int ):void
		{
			mKerning = value;
		}
		// ============================================================
		public function get Kerning():int
		{
			return mKerning;
		}
		// ============================================================
		public function set Leading( value:int ):void
		{
			mLeading = value;
		}
		// ============================================================
		public function get Leading():int
		{
			return mLeading;
		}
		// ============================================================
		// ============================================================
		
		
		
		// ============================================================
		//public function DrawText( g:IGraphix, text:String, rect:NRect ):void
		//{
			//var r:NRect = new NRect();
			//r.CopyFrom( rect );
			//
			//DoAlignment( text, r );
//
			//var pos:NPoint = new NPoint();
			//pos.CopyFrom( r.Position );
			//var right:Number = r.Right;
			//var bottom:Number = r.Bottom;
			//
			//var count:int = text.length;
			//for (var i:int = 0; i < count; i++)
			//{
				//var chData:CharData = mCharsData[int(text.charCodeAt(i))];
				//if ( !chData ) continue;
				//var bmpRect:NRect = chData.BitmapRect;
				//var bmpPos:NPoint = bmpRect.Position;
				//var bmpSize:NSize = bmpRect.Size;
				//
				//if ( pos.x + bmpSize.Width + mKerning > right )
				//{
					//pos.x = r.Position.x;
					//pos.y += mMaxCharHeight + mLeading;	// можно менять расстояние между строками
				//}
				//
				//if ( pos.y > bottom )
					//return;
				//
				//DrawChar( g, pos, bmpPos, bmpSize );
				//
				//pos.x += bmpSize.Width + mKerning;
			//}
		//}
		// ============================================================
		//private function DrawChar( g:IGraphix, pos:NPoint, bmpPos:NPoint, bmpSize:NSize ):void
		//{
			//g.DrawBitmapDataPart( mBitmapData, pos.x, pos.y, bmpPos.x, bmpPos.y, bmpSize.Width, bmpSize.Height );
		//}
		// ============================================================
		/**
		 * Делает выранивание, НО НЕ учитывает перенос строк!
		 * @param	text
		 * @param	rect
		 */
		private function DoOneLineAlignment( text:String, rect:NRect ):void
		{
			var shift_hor:Number = 0;
			var shift_ver:Number = 0;
			var pix_width:Number = MeasureStringLength( text );
			
			if ( mHorAlignment == 0 )
			{
				shift_hor = (rect.Size.Width - pix_width) * 0.5;
				rect.Position.x += shift_hor;
			}
			else if ( mHorAlignment == 1 )
			{
				shift_hor = rect.Size.Width - pix_width;
				rect.Position.x += shift_hor;
			}
			
			if ( mVerAlignment == 0 )
			{
				shift_ver = (rect.Size.Height - mMaxCharHeight) * 0.5;
				rect.Position.y += shift_ver;
			}
			else if ( mVerAlignment == 1 )
			{
				shift_ver = rect.Size.Height - mMaxCharHeight;
				rect.Position.y += shift_ver;
			}
		}
		// ============================================================
		public function GetCharData( char_code:int ):CharData
		{
			return mCharsData[ char_code ];
		}
		// ============================================================
		/**
		 * Функция неполноценная - нужен еще учет ограничений по размерам, а по хорошему - нужно проводить предрасчет по пробелам и текст бить на слова и в массив в вызывающем контроле
		 * @param	text
		 * @return
		 */
		public function MeasureStringLength( text:String ):Number
		{
			var pixel_length:Number = 0;
			var count:int = text.length;
			for (var i:int = 0; i < count; i++)
			{
				var chIndex:int = int(text.charCodeAt(i));
				if ( mCharsData[chIndex] == undefined )
					continue;
				var chData:CharData = mCharsData[chIndex];
				var bmpRect:NRect = chData.BitmapRect;
				var bmpPos:NPoint = bmpRect.Position;
				var bmpSize:NSize = bmpRect.Size;
				
				pixel_length += bmpSize.Width + mKerning;
			}
			
			return pixel_length;
		}
		// ============================================================
		/**
		 * Считает размер одной строки (не учитывает перенос строки
		 * Нужен еще один метод, который учитывал бы переносы и ограничивал бы текст по ширине
		 * @param	text
		 * @param	rect
		 * @return
		 */
		private var sizeTmp:NSize = new NSize();
		private var rectTmp:NRect = new NRect(0,0, 1000000, 1000000);
		public function MeasureStringSize( text:String, rect:NRect = null ):NSize
		{
			var pixel_length:Number = 0;
			var pixel_height:Number = 0;
			var count:int = text.length;
			
			if ( IsTTFont )
			{
				sizeTmp.Reset();
				var r:NRect = rect || rectTmp;
				
				var tblock:TextBlock = TextGen.CreateTextBlock( text, Name, { size:Size, color:Color, bold:Bold } );
				var tline:TextLine = tblock.createTextLine( null, r.Width );
				while (tline)
				{
					tline.y = sizeTmp.Height;
					if ( sizeTmp.Width < tline.width ) sizeTmp.Width = tline.width;
					sizeTmp.Height += tline.height;
					
					tline = tblock.createTextLine( tline, r.Width );
				}
				
				sizeTmp.Init( int(sizeTmp.Width + 0.5), int(sizeTmp.Height + 0.5) );
				return sizeTmp;
			}
			
			/*if ( rect )
			{
				var last_w:int = 0;
				var lastSpace:int = -1;
				var prevSym:int = 0;
				
				var r:NRect = rect.Clone();

				// T O D O: выравнивание в многострочных текстах пока не поддерживается
				//DoAlignment( text, r, font, halign, valign );

				var pos:NPoint = new NPoint();
				var right:Number = r.Right;
				var bottom:Number = r.Bottom;
				
				for (var i:int = 0; i < count; i++)
				{
					var chIndex:int = int(text.charCodeAt(i));
					if ( chIndex == Key.Spacebar && prevSym != Key.Spacebar )
					{
						lastSpace = i;
					}
					
					prevSym = chIndex;
					
					var chData:CharData = GetCharData( chIndex ) as CharData;
					if ( !chData ) continue;
					
					var bmpSize:NSize = chData.BitmapRect.Size;
					
					if ( pos.x + bmpSize.Width + Kerning > right )	// если выходим за пределы контура
					{
						pos.x = r.Position.x;							// восстановим начальную позицию
						pos.y += mMaxCharHeight + Leading;	// сместимся строкой ниже (можно менять расстояние между строками)
						
						if ( lastSpace != -1 )// если пробелы на этой строке были
						{
							i = lastSpace;	// чтобы перенос был по последнему пробелу
							lastSpace = -1;
						}
					}
					
					if ( pos.y > bottom )		// если вышли за пределы контрола снизу, то
						return new NSize( pixel_length, pixel_height );	// вернем текущий размер
					
					pos.x += bmpSize.Width + Kerning;
					
					if ( pixel_length < pos.x )
						pixel_length = pos.x;
					if ( pixel_height < pos.y )
						pixel_height = pos.y;
				}
				
				return new NSize( pixel_length, pixel_height );
			}
			else/**/
			{
				for (var i:int = 0; i < count; i++)
				{
					var chIndex:int = int(text.charCodeAt(i));
					if ( mCharsData[chIndex] == undefined )
						continue;
					var chData:CharData = mCharsData[chIndex];
					//trace( "CODE:", int(text.charCodeAt(i)) );
					var bmpRect:NRect = chData.BitmapRect;
					var bmpPos:NPoint = bmpRect.Position;
					var bmpSize:NSize = bmpRect.Size;
					if ( pixel_height < bmpSize.Height )
						pixel_height = bmpSize.Height;
					
					pixel_length += bmpSize.Width + mKerning;
				}
				
				return new NSize( pixel_length, pixel_height );
			}
		}
		// ============================================================
		/**
		 * Генерит массив строк, разбитых так, чтобы переносы строк были на пробелах
		 * @param	text
		 * @param	rect
		 * @return
		 */
		public function SplitTextToLines( text:String, r:NRect = null ):Array
		{
			var result_array:Array = new Array();
			var count:int = text.length;
			
			if ( r )
			{
				var start_index:int = 0;
				var lastSpace:int = -1;
				var prevSym:int = 0;
				
				var posX:Number = 0;
				var right:Number = r.Width;
				
				for (var i:int = 0; i < count; i++)
				{
					var chSym:int = int(text.charCodeAt(i));
					
					if ( chSym == Key.NewLine )	// если перервод строки
					{
						result_array.push( text.substring( start_index, i ) );
		//trace( "line:", text.substring( start_index, i ) + "!1" );
						start_index = i + 1;
						prevSym = 0;
						lastSpace = -1;
						posX = 0;
						continue;
					}
					
					if ( chSym == Key.Spacebar && prevSym != chSym )
					{
						lastSpace = i;
					}
					prevSym = chSym;
					
					var chData:CharData = GetCharData( chSym ) as CharData;
					if ( !chData ) continue;
					
					var bmpW:Number = chData.BitmapRect.Size.Width;
					
					if ( posX + bmpW + Kerning > right )	// если выходим за пределы контура
					{
				//trace( "posX:", posX, posX + bmpW + Kerning, right );
						posX = 0;							// восстановим начальную позицию
						if ( lastSpace != -1 )// если пробелы на этой строке были
						{
							result_array.push( text.substring(start_index, lastSpace) );
		//trace( "line:", text.substring( start_index, lastSpace ) + "!2" );
							i = lastSpace;	// чтобы перенос был по последнему пробелу
							start_index = lastSpace + 1;	// исключаем "разрывающий" пробел
						}
						else
						{
							result_array.push( text.substring(start_index, i) );
		//trace( "line:", text.substring( start_index, i ) + "!3" );
							start_index = i;
							--i;
						}
						
						prevSym = 0;
						lastSpace = -1;
					}
					
					posX += bmpW + Kerning;
				}
				
				var last_part:String = text.substring( start_index );
				if( last_part.length > 0 )
					result_array.push( last_part );	// чтобы добавить последнюю часть
			}
			else
				result_array.push( text );
			
			return result_array;
		}
		// ============================================================
		public function IsTextMultiline( text:String, rect:NRect=null ):Boolean
		{
			if ( !text )
				return false;
			
			var index:int = text.indexOf( "\r" );
			if ( index != -1 )
				return true;
			
			if ( rect )
			{
				var pixel_length:Number = 0;
				var count:int = text.length;
				
				var pos:NPoint = new NPoint();
				var right:Number = rect.Right;
				
				for (var i:int = 0; i < count; i++)
				{
					var chIndex:int = int(text.charCodeAt(i));
					
					var chData:CharData = GetCharData( chIndex ) as CharData;
					if ( !chData ) continue;
					
					var bmpSize:NSize = chData.BitmapRect.Size;
					
					if ( pos.x + bmpSize.Width + Kerning > right )	// если выходим за пределы контура
						return true;
					
					pos.x += bmpSize.Width + Kerning;
				}
			}
			
			return false;
		}
		// ============================================================
	}
	
}