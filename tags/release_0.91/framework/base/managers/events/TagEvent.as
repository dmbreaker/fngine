package base.managers.events 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class TagEvent extends REvent
	{
		// ============================================================
		// ============================================================
		public var Tag:String = "";
		// ============================================================
		// ============================================================
		public function TagEvent(id:int, sender:*, tag:String, value:int)
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