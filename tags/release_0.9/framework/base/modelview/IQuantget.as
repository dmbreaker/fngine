package base.modelview
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IQuantget extends IQuant
	{
		function OnAdded( /*parent:IQuantget*/ ):void;
		function OnRemoving( /*parent:IQuantget*/ ):void;
	}
	
}