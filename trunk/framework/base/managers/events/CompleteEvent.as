package base.managers.events 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class CompleteEvent extends REvent
	{
		// ============================================================
		// ============================================================
		public var Tag:String = "";
		// ============================================================
		// ============================================================
		public function CompleteEvent(id:int, sender:*, tag:String, value:int) 
		{
			super(id, sender, value, null);

			EventId = id;
			Sender = sender;
			Value = value;
			Tag = tag;
		}
		// ============================================================
		// ============================================================
	}

}