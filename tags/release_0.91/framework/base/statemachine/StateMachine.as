package base.statemachine
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class StateMachine
	{
		// ============================================================
		private var mAreStatesStopped:Boolean;
		private var mState:State = new State();
		private var mNextState:State = new State();	// чисто оптимизация (чтобы избежать выделения памяти в SetState
		private var mStateFired:Boolean;	// нужно ли вызвать OnStateEnter на ближайшей итерации
		
		private var mStatesReceiver:IStatesObject = null;
		// ============================================================
		public function StateMachine( states_object:IStatesObject )
		{
			mStatesReceiver = states_object;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public function StopAllActivities():void
		{
			trace( "StopAllActivities["+getQualifiedClassName(mStatesReceiver)+"]" );
			mState.MakeInactive();
			mAreStatesStopped = true;
		}	// останавливает все стэйт-машины объекта
		// ============================================================
		public function SetState( state_value:int, state_time:int ):void	// iTicks - длительность состояние в миллисекундах(Update)
		{
			if( state_time == -1 )
			{
				mNextState.Init( state_value, 100 );
				mNextState.IsContinuous = true;
			}
			else
				mNextState.Init( state_value, state_time );
			
			if( mState.IsActive() )
				mStatesReceiver.OnStateChange( mState, mNextState );
			mState.CopyFrom( mNextState );
			
			//trace( "SetState[" + getQualifiedClassName(mStatesReceiver) + "]: " + state_value + "(" + state_time + ")" );
		}
		// ============================================================
		public function ReinitStates():void
		{
			trace( "ReinitStates["+getQualifiedClassName(mStatesReceiver)+"]" );
			mState.MakeInactive();
			mAreStatesStopped = false;
		}
		// ============================================================
		public function get CurrentState():State
		{
			return mState;
		}
		// ============================================================
		private function StopStateObject():void
		{
			trace( "StopStateObject["+getQualifiedClassName(mStatesReceiver)+"]" );
			mState.MakeInactive();
		}
		// ============================================================
		public function FreezeState( freeze:Boolean ):void
		{
			mState.IsFreezed = freeze;
		}
		// ============================================================
		public function FreezeForOneQuant():void
		{
			
		}
		// ============================================================
		// ============================================================
		public function GetStateCompletePercent():Number
		{
			if( mState.IsActive() )
			{
				return mState.GetCompletePercent();
			}
			else
				return 0;
		}
		// ============================================================
//public function OnStateEnter( state:State ):void {};
//public function OnStateExit( state:State ):void {};
//public function OnStateChange( current:State, next:State ):void {};	// empty by default
		// ============================================================
		public function Quant( diff_ms:int ):void
		{
			if( !mAreStatesStopped )
			{
				if( mState.IsActive() )
				{
					// вызываем новые события:
					if( !mState.IsFired )
					{
						mState.IsFired = true;
						mStatesReceiver.OnStateEnter( mState );
					}

					// вызываем отработавшие события:
					if( mState.IsFired )
					{
						if( mState.IsTimeOut() )
						{
							mStatesReceiver.OnStateExit( mState );
							if ( mState.IsTimeOut() )	// в процедуре состояние не изменилось (время осталось нулевым), то
							{
								mState.MakeInactive();			// ставим в пустое состояние
								mStatesReceiver.OnStateEnter( mState );	// всеравно нужно вызвать, чтобы объект знал о переходе
							}
						}
						else
						{
							if( !mState.IsFreezed )			// если объект не заморожен
								mState.SubtractTime(diff_ms);			// уменьшаем тики
						}
					}
				}
			}

			if( mAreStatesStopped )
			{
				mAreStatesStopped = false;
				mState.MakeInactive();
				mState.IsFired = true;
			}
		}
		// ============================================================
	}
	
}