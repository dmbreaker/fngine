package base.externals.FGL.GameTracker
{
	import flash.events.Event;

	public class GameTrackerErrorEvent extends Event
	{
		public var _msg:String;
		public function GameTrackerErrorEvent(type:String, msg:String)
		{
			_msg = msg;
			super(type, false, false);
		}
		
	}
}