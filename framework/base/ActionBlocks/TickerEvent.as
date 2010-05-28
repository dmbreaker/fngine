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
		
	}
	
}