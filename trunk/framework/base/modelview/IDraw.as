package base.modelview
{
	import base.graphics.BitmapGraphix;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public interface IDraw
	{
		function Draw( g:BitmapGraphix, diff_ms:int ):void;
	}
	
}