package base.utils.settings
{
	import base.containers.AvDictionary;
	import base.utils.Methods;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class StringsLoader
	{
		// ============================================================
		private var mStrings:AvDictionary = new AvDictionary();
		// ============================================================
		// ============================================================
		public function StringsLoader() 
		{
			
		}
		// ============================================================
		// ============================================================
		public function Load( strings:XML ):void 
		{
			mStrings.Clear();
			
			var list:XMLList = strings..String;
			for each (var str:XML in list) 
			{
				var id:String = Methods.GetAttributeValue( str, "id" ).toString();
				var text:String = str.valueOf().toString();
				
				mStrings.Add( id, text );
			}
		}
		// ============================================================
	}

}