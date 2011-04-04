package base.utils 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class NSignalEvent extends Event
	{
		// ============================================================
		public static const SIGNAL_GENERATED:String = "signal_generated";
		// ============================================================
		public var GeneratorID:String = "";
		public var SignalID:String = "";
		// ============================================================
		public function NSignalEvent( genId:String, signalID:String ):void
		{
			super(SIGNAL_GENERATED);
			GeneratorID = genId;
			SignalID = signalID;
		}
		// ============================================================
		override public function clone():Event 
		{
			var se:NSignalEvent = NSignalEvent(super.clone());
			se.GeneratorID = this.GeneratorID;
			se.SignalID = this.SignalID;
			return se;
		}
		// ============================================================
	}

}