package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.modelview.Widget;
	import base.types.NPoint;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NBaseTooltip extends Widget
	{
		// ============================================================
		protected var mIsAutohide:Boolean = true;
		public var Tag:* = { };
		// ============================================================
		public function NBaseTooltip( name:String )
		{
			super( "no_name_tooltip" );	// в поиске он всеравно не должен использоваться
			//IsSearchable = false;
			IsClickable = false;
			IsActiveWidget = false;
		}
		// ============================================================
		public function InitData( data:* ):void 
		{
			
		}
		// ============================================================
		public function Show( newPos:NPoint, cursorPos:NPoint ):void
		{
			
		}
		// ============================================================
		public function Hide():void
		{
			
		}
		// ============================================================
		// ============================================================
	}

}