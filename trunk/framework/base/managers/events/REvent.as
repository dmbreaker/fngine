package base.managers.events 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class REvent
	{
		// ============================================================
		// ============================================================
		public var EventId:int = 0;
		public var Sender:* = null;
		public var Value:int = 0;
		public var Data:* = null;
		// ============================================================
		// ============================================================
		public function REvent(id:int, sender:*, value:int, data:*)
		{
			EventId = id;
			Sender = sender;
			Value = value;
			Data = data;
		}
		// ============================================================
		// ============================================================
	}

}