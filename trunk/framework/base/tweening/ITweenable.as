package base.tweening
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface ITweenable
	{
		function OnComplete():void;
		function get TAlpha():Number;
		function set TAlpha( value:Number ):void;
		function get TX():Number;
		function set TX( value:Number ):void;
		function get TY():Number;
		function set TY( value:Number ):void;
		function get TParam():Number;
		function set TParam( value:Number ):void;
		
		
	}
	
}