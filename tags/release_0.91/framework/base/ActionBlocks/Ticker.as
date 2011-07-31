package base.ActionBlocks
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Ticker extends EventDispatcher
	{
		// ============================================================
		public static const TICKER_VALUE_CHANGED:String = "tickerchanged";
		public static const TICKER_ADDED_VALUE:String = "tickervalueadded";
		public static const TICKER_RESET_VALUE:String = "tickervaluereset";
		public static const TICKER_ATTENTION:String = "tickerattention";
		// ============================================================
		private var mValue:int = 0;
		// ============================================================
		public function Ticker()
		{
			
		}
		// ============================================================
		public function Add( value:int ):void
		{
			mValue += value;
			
			dispatchEvent( new Event( TICKER_VALUE_CHANGED ) );
			dispatchEvent( new TickerEvent( TICKER_ADDED_VALUE, value ) );
		}
		// ============================================================
		public function Increment():void
		{
			Add( 1 );
		}
		// ============================================================
		public function Decrement():void
		{
			Add( -1 );
		}
		// ============================================================
		public function Get():int
		{
			return mValue;
		}
		// ============================================================
		public function Reset():void
		{
			mValue = 0;
			
			dispatchEvent( new Event( TICKER_VALUE_CHANGED ) );
			dispatchEvent( new Event( TICKER_RESET_VALUE ) );
		}
		// ============================================================
		public function Set( value:int ):void
		{
			mValue = value;
			dispatchEvent( new Event( TICKER_RESET_VALUE ) );
			//dispatchEvent( new TickerEvent( TICKER_ADDED_VALUE, value ) );	// !!! затычка, но пока она достаточна
			dispatchEvent( new Event( TICKER_VALUE_CHANGED ) );
		}
		// ============================================================
		public function DoAttention( value:int ):void
		{
			dispatchEvent( new TickerEvent( TICKER_ATTENTION, value ) );
		}
		// ============================================================
	}
	
}