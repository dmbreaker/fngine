package base.parsers
{
	import base.graphics.CharData;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class CharDataXmlParser
	{
		// ============================================================
		public function CharDataXmlParser()
		{
			
		}
		// ============================================================
		public function Parse( xml:XML ):Array
		{
			var items:XMLList = xml.characters..char;
			var arr:Array = new Array( 256 );
			
			var index:int = 0;
			for each (var it:XML in items)
			{
				arr[int(it.@code)] = new CharData( it.@code, it.@x, it.@y, it.@w, it.@h );
			}
			
			return arr;
		}
		// ============================================================
	}
	
}