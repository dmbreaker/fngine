package base.scenes
{
	import base.modelview.Widget;
	import base.core.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NOkScene extends NModalScene
	{
		// ============================================================
		public function NOkScene( core:NCore, name:String )
		{
			super( core, name );
		}
		// ============================================================
		override public function OnCommand(widget:Widget, command:String = null, data:* = null):void
		{
			if ( widget.Name == DefaultOk )
			{
				mCore.CloseLastModal();
				DoCallback( 0 );
				//mCore.SwitchToPrevious();
			}
		}
		// ============================================================
	}
	
}