package base.utils.settings
{
	import base.containers.AvDictionary;
	import base.utils.Methods;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class GlobalsLoader
	{
		// ============================================================
		private var mStrings:AvDictionary = new AvDictionary();
		private var mIntegers:AvDictionary = new AvDictionary();
		private var mFloats:AvDictionary = new AvDictionary();
		private var mBooleans:AvDictionary = new AvDictionary();
		// ============================================================
		public function GlobalsLoader() 
		{
			
		}
		// ============================================================
		// ============================================================
		public function Load( globals:XML ):void 
		{
			var str:XML = null;
			var id:String = null;
			
			Clear();
			
			// строки (String и WString - для флэша все в уникоде всеравно):
			var strings:XMLList = globals..String;
			for each (str in strings) 
			{
				id = Methods.GetAttributeValue( str, "id" ).toString();
				var text:String = str.valueOf().toString();
				mStrings.Add( id, text );
			}
			strings = globals..WString;
			for each (str in strings) 
			{
				id = Methods.GetAttributeValue( str, "id" ).toString();
				text = str.valueOf().toString();
				mStrings.Add( id, text );
			}
			
			// целые значения:
			var integers:XMLList = globals..Integer;
			for each (str in integers) 
			{
				id = Methods.GetAttributeValue( str, "id" ).toString();
				var valueI:int = int(Methods.GetAttributeValue( str, "value" ));
				mIntegers.Add( id, valueI );
			}
			
			// значения с плавающей запятой:
			var floats:XMLList = globals..Float;
			for each (str in floats) 
			{
				id = Methods.GetAttributeValue( str, "id" ).toString();
				var valueN:Number = Number(Methods.GetAttributeValue( str, "value" ));
				mFloats.Add( id, valueN );
			}
			
			// булевые значения:
			var booleans:XMLList = globals..Boolean;
			for each (str in floats) 
			{
				id = Methods.GetAttributeValue( str, "id" ).toString();
				var valueB:Boolean = Boolean(Methods.GetAttributeValue( str, "value" ));
				mBooleans.Add( id, valueB );
			}
		}
		// ============================================================
		public function Clear():void
		{
			mStrings.Clear();
			mIntegers.Clear();
			mFloats.Clear();
			mBooleans.Clear();
		}
		// ============================================================
		public function GetString(id:String):String
		{
			return String(mStrings.GetValue(id));
		}
		// ============================================================
		public function GetInt(id:String):int
		{
			return int(mIntegers.GetValue(id));
		}
		// ============================================================
		public function GetFloat(id:String):Number
		{
			return Number(mFloats.GetValue(id));
		}
		// ============================================================
		public function GetBool(id:String):Boolean
		{
			return Boolean(mBooleans.GetValue(id));
		}
		// ============================================================
	}

}