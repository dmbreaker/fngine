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
		public var CanExit:Function = null;
		public var CanEnter:Function = null;
		// ============================================================
		// ============================================================
		public function AvState(id:String, params:* = null)
		{
			ID = id;
			
			if ( params )
			{
				if ("is_working" in params)
					IsWorking = params["is_working"] as Boolean;
			}
		}
		// ============================================================
		// ============================================================
		/*
		 * Handle event
		 */
		public function DoHandle(event:String):void
		{
			if ( OnHandle != null )
				OnHandle(event);
		}
		// ============================================================
		public function DoEnter(event:String):void
		{
			if ( OnEnter != null )
				OnEnter(event);
		}
		// ============================================================
		public function DoExit(/*event:String*/):void
		{
			if ( OnExit != null )
				OnExit();
		}
		// ============================================================
		public function DoUpdate(ms:int):void
		{
			if ( OnUpdate != null && IsWorking )
				OnUpdate(ms);
		}
		// ============================================================
		public function DoCanExit(event:String):Boolean
		{
			if ( CanExit != null )
				return CanExit(event);
			else
				return true;
		}
		// ============================================================
		public function DoCanEnter(event:String):Boolean
		{
			if ( CanEnter != null )
				return CanEnter(event);
			else
				return true;
		}
		// ============================================================
	}

}