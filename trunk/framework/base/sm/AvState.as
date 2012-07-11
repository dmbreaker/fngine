package base.sm 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AvState 
	{
		// ============================================================
		public var ID:String = "none";
		public var IsWorking:Boolean = false;	// need updates
		// ============================================================
		public var OnEnter:Function = null;
		public var OnExit:Function = null;
		public var OnHandle:Function = null;
		public var OnUpdate:Function = null;
		// ============================================================
		// ============================================================
		public function AvState() 
		{
			
		}
		// ============================================================
		// ============================================================
		/*
		 * Handle event
		 */
		public function DoHandle(event:String):void//String
		{
			if ( OnHandle )
				OnHandle(event);
			//else
			//	return "";	// do not change current state
		}
		// ============================================================
		public function DoEnter(/*event:String*/):void
		{
			if ( OnEnter )
				OnEnter(/*event*/);
		}
		// ============================================================
		public function DoExit(/*event:String*/):void
		{
			if ( OnExit )
				OnExit();
		}
		// ============================================================
		public function DoUpdate(ms:int):void
		{
			if ( OnUpdate && IsWorking )
				OnUpdate(ms);
		}
		// ============================================================
	}

}