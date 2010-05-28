package base.containers
{
	import base.modelview.IQuant;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IMsgItem extends IQuant
	{
		function get IsComplete():Boolean;
		function Dispose():void;
	}
	
}