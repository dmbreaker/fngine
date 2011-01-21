package base.utils 
{
	import base.graphics.BitmapGraphix;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public interface IActiveItem 
	{
		// ============================================================
		function DrawItem(g:BitmapGraphix):void;
		function UpdateItem(ms:int):void;
		function get IsActiveItem():Boolean;
		function StartItem():void;
		function DisposeItem():void;
		// ============================================================
	}

}