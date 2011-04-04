package base.managers.events
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class EventsManager
	{
		// ============================================================
		// ============================================================
		private var mListeners:Vector.<EventListener> = new Vector.<EventListener>();
		private var mEvents:Vector.<REvent> = new Vector.<REvent>();
		private var mEventsClone:Vector.<REvent> = new Vector.<REvent>();

		private static var mInstance:EventsManager = null;
		// ============================================================
		// ============================================================
		public function EventsManager() 
		{
			
		}
		// ============================================================
		public static function get Instance():EventsManager
		{
			if ( !mInstance )
				mInstance = new EventsManager();
				
			return mInstance;
		}
		// ============================================================
		// ============================================================
		public function DispatchEvent( eventId:int, sender:*, value:int = 0, data:* = null ):void
		{
			var ev:REvent = new REvent( eventId, sender, value, data );
			mEvents.push( ev );
		}
		// ============================================================
		public function DispatchCompleteEvent( eventId:int, sender:*, tag:String, value:int = 0 ):void
		{
			var ev:CompleteEvent = new CompleteEvent( eventId, sender, tag, value );
			mEvents.push( ev );
		}
		// ============================================================
		public function DispatchEventTag( eventId:int, sender:*, tag:String, value:int = 0 ):void
		{
			var ev:TagEvent = new TagEvent( eventId, sender, tag, value );
			mEvents.push( ev );
		}
		// ============================================================
		public function Reinit():void
		{
			mListeners.length = 0;
			mEvents.length = 0;
			mEventsClone.length = 0;
		}
		// ============================================================
		public function AddListener( listener:EventListener ):void
		{
			mListeners.push( listener );
		}
		// ============================================================
		public function RemoveAllListeners():void
		{
			mListeners.length = 0;
		}
		// ============================================================
		public function Update():void
		{
			var count:int = mEvents.length;
			if( !count )
				return;

			// следующий код нужен для того, чтобы можно было генерировать новые события внутри цикла рассылки событий
			//mEventsClone.resize(count);
			//copy( mEvents.begin(), mEvents.end(), mEventsClone.begin() );
			mEventsClone.length = 0;
			mEventsClone = mEvents.slice();
			mEvents.length = 0;

			for( var i:int=0; i<count; i++ )
			{
				var ev:REvent = mEventsClone[i];
				
				var size:int = mListeners.length;
				for( var k:int=0; k<size; k++ )
				{
					var listener:EventListener = mListeners[k];
					//if( pEvent->Sender != listener )
					listener.OnEvent( ev );	// слушатели сами фильтруют то, что им нужно, на события они не подписываются... Надеюсь не будет тормозить
				}
			}

			mEventsClone.length = 0;
		}
		// ============================================================
	}

}