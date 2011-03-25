package base.statemachine
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IStatesObject
	{
		function OnStateEnter( state:State ):void;
		function OnStateExit( state:State ):void;
		function OnStateChange( current:State, next:State ):void;	// empty by default
	}
	
}