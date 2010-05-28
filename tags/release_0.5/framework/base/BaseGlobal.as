package base 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BaseGlobal
	{
		// ============================================================
		// ============================================================
		// ============================================================
		public function BaseGlobal() 
		{
			
		}
		// ============================================================
		public static function get MouseOutTime():Number
		{
			return 3000;
		}
		// ============================================================
		public static function get MouseNoMoveTime():Number
		{
			return 15000;	// 15 seconds... possible not needed at all
		}
		// ============================================================
		public static function get Width():int
		{
			return 640;
		}
		// ============================================================
		public static function get Height():int
		{
			return 480;
		}
		// ============================================================
		// ============================================================
		public static function get DebugEnabled():Boolean
		{
			// TODO: в DebugEnabled релизе сделать FALSE
			return true;
			//return false;
		}
		// ============================================================
	}

}