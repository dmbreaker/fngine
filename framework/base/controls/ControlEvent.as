package base.controls 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class ControlEvent extends Event
	{
		// ============================================================
		protected var mSender:Control;
		protected var mData:*;
		// ============================================================
		public function ControlEvent( type:String, sender:*, data:*=null ) 
		{
			super(type, false, false);
			mSender = sender;
			mData = data;
		}
		// ============================================================
		public function get sender():Control
		{
			return mSender;
		}
		
		/*protected function set sender(value:Control):void 
		{
			mSender = value;
		}*/
		// ============================================================
		public function get data():*
		{
			return mData;
		}
		
		/*public function set data( value:* ):void 
		{
			mData = value
		}*/
		// ============================================================
	}

}