package base.parsers
{
	import base.graphics.CharData;
	import base.managers.XmlManager;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class CharDataXmlParser
	{
		// ============================================================
		static private var mCharArrays:Dictionary = new Dictionary();
		// ============================================================
		public function CharDataXmlParser()
		{
			
		}
		// ============================================================
		public function Parse( xml_name:String ):Array
		{
			var arr:Array = null;
			
			if ( mCharArrays[xml_name] )	// if array already exist
			{
				arr = mCharArrays[xml_name];
			}
			else							// if not, let's create one
			{
				arr = new Array( 256 );
				var xml:XML = XmlManager.Instance.GetXML(xml_name);
				var items:XMLList = xml.characters..char;
				var index:int = 0;
				
				for each (var it:XML in items)
				{
					arr[int(it.@code)] = new CharData( it.@code, it.@x, it.@y, it.@w, it.@h );
				}
				
				mCharArrays[xml_name] = arr;
			}
			
			return arr;
		}
		// ============================================================
	}
	
}