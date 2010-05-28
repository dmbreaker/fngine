package base.utils
{
	import base.controls.Control;
	import base.core.NCore;
	import base.core.NStyle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Methods
	{
		
		public function Methods()
		{
			
		}
		// ============================================================
		public static function CopyFields( src:*, dest:* ):void
		{
			for( var field:* in src )
			{
				dest[field] = src[field];
			}
		}
		// ============================================================
		public static function GetAttributeValue( xml:XML, attrName:String ):*
		{
			var attrValue:XMLList = xml.attribute( attrName );

			if ( attrValue && attrValue.length() > 0 )
			{
				return attrValue[0].valueOf();
			}
			
			return null;
		}
		// ============================================================
		public static function ApplyControlSettings( el:XML, rect:*, settings:*, images:* = null ):void
		{
			var style:NStyle;
			var parentValue:* = GetAttributeValue( el, "style" );
			if ( parentValue )
			{
				style = NCore.GetStyle( parentValue.toString() );
				if ( style )
				{
					CopyFields( style.Rect, rect );
					CopyFields( style.Settings, settings );
					if( images )
						CopyFields( style.Images, images );
				}
			}
			
			CopyFields( Control.ParseRect( el ), rect );
			CopyFields( Control.ParseSettings( el ), settings );
			if( images )
				CopyFields( Control.ParseImages( el ), images );
		}
		// ============================================================
		public static function RandF(from:Number, till:Number):Number
		{
			return from + Math.random() * (till+0.00001 - from);
		}
		// ============================================================
		public static function Rand(from:int, till:int):int
		{
			return from + int(Math.random() * (till - from) + 0.5);
		}
		// ============================================================
		public static function ActivateEscapeSymbols( txt:String ):String
		{
			var escapeSymIndex:int = txt.indexOf( "\\" );
			if ( escapeSymIndex == -1 )	// изменения не нужны
				return txt;
			else
			{
				return txt.replace( /\\\\/g, "\\" ).replace( /\\n/g, "\n" );	// заменяем "\\" на '\', а затем "\n" на '\n'
			}
		}
		// ============================================================
	}
	
}