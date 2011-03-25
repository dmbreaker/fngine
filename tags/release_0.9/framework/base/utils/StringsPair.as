package base.utils 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StringsPair
	{
		// ============================================================
		// ============================================================
		public var First:String;
		public var Second:String;
		// ============================================================
		// ============================================================
		public function StringsPair(first:String="", second:String="") 
		{
			Init( first, second );
		}
		// ============================================================
		public function Init( first:String, second:String ):void 
		{
			First = first;
			Second = second;
		}
		// ============================================================
	}
	// ============================================================
}