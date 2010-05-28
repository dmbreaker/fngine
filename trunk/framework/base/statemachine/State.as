package base.statemachine
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class State
	{
		// ============================================================
		public static const INACTIVE:int = 0;
		// ============================================================
		public var Type:int;
		public var TimeLeft:int;
		public var TotalTime:int;
		public var IsFreezed:Boolean;
		public var IsFired:Boolean;
		public var IsOneQuantFreezed:Boolean;
		// ============================================================
		public function State( state_value:int = 0, time_ms:int = 0 )
		{
			Init( state_value, time_ms );
		}
		// ============================================================
		public function Init( state_value:int = 0, time_ms:int = 0, freezed:Boolean = false, fired:Boolean = false ):void
		{
			Type = state_value;
			TotalTime = TimeLeft = time_ms;
			IsFreezed = freezed;
			IsFired = fired;
			IsOneQuantFreezed = false;
			
			if ( Type == State.INACTIVE )	// вроде это логично
				IsFired = true;
		}
		// ============================================================
		public function MakeInactive():void
		{
			Init( State.INACTIVE, 0, false, true );
		}
		// ============================================================
		internal function SubtractTime( time:int ):void
		{
			if ( !IsOneQuantFreezed )
			{
				TimeLeft -= time;
				if ( TimeLeft < 0 )
					TimeLeft = 0;
			}
			else
				IsOneQuantFreezed = false;
		}
		// ============================================================
		internal function IsActive():Boolean
		{
			return (Type > 0);
		}
		// ============================================================
		internal function IsTimeOut():Boolean
		{
			return (TimeLeft <= 0);
		}
		// ============================================================
		public function AddTime( time:int ):void
		{
			TimeLeft += time;
			TotalTime += time;	// верно ли это?
		}
		// ============================================================
		public function CopyFrom( state:State ):void
		{
			Type = state.Type;
			TimeLeft = state.TimeLeft;
			IsFired = state.IsFired;
			IsFreezed = state.IsFreezed;
		}
		// ============================================================
		public function toString():String
		{
			return "State[type:"+Type+", ttime:"+TotalTime+"]";
		}
		// ============================================================
	}
	
}