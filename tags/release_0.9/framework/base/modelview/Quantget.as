package base.modelview
{
	import base.statemachine.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Quantget extends QuantgetContainer implements IStatesObject, IQuantget
	{
		// ============================================================
		protected var mStateMachine:StateMachine;
		// ============================================================
		public function Quantget()
		{
			mStateMachine = new StateMachine( this );
		}
		// ============================================================
		protected function SetState( state_value:int, state_time:int ):void
		{
			mStateMachine.SetState( state_value, state_time );
		}
		// ============================================================
		public function FreezeState():void
		{
			mStateMachine.FreezeState( true );
		}
		// ============================================================
		public function UnfreezeState():void
		{
			mStateMachine.FreezeState( false );
		}
		// ============================================================
		internal final override function InternalQuant(diff_ms:int):void
		{
			mStateMachine.Quant( diff_ms );
			Quant( diff_ms );
			super.InternalQuant( diff_ms );
		}
		// ============================================================
		internal final override function InternalPrecisionQuant(diff_ms:int):void
		{
			//mStateMachine.Quant( diff_ms );
			PrecisionQuant( diff_ms );
			super.InternalPrecisionQuant( diff_ms );
		}
		// ============================================================
		public function Quant( diff_ms:int ):void
		{
			
		}
		// ============================================================
		public function PrecisionQuant( diff_ms:int ):void
		{
			
		}
		// ============================================================
		
		/* INTERFACE base.IStatesObject */
		// IStatesObject >> ============================================================
		public function OnStateEnter(state:State):void
		{
			
		}
		// ============================================================
		public function OnStateExit(state:State):void
		{
			
		}
		// ============================================================
		public function OnStateChange(current:State, next:State):void
		{
			
		}
		// IStatesObject << ============================================================
		/* INTERFACE base.model.IQuantget */
		// ============================================================
		public function OnAdded():void
		{
			
		}
		// ============================================================
		public function OnRemoving():void
		{
			
		}
		// ============================================================
		
	}
	
}