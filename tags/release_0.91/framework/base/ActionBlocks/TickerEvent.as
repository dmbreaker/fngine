package base.ActionBlocks
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class TickerEvent extends Event
	{
		public var Data:Object;
		
		public function TickerEvent( type:String, data:* )
		{
			super(type);
			Data = data;
		}
		
		override public function clone():Event 
		{
			var te:TickerEvent = TickerEvent(super.clone());
			te.Data = this.Data;
			return te;
		}
	}
	
}