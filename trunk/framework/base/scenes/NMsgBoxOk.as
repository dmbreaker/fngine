package base.scenes 
{
	import base.modelview.Widget;
	import base.core.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NMsgBoxOk extends NModalScene
	{
		// ============================================================
		public function NMsgBoxOk( core:NCore, name:String )
		{
			super( core, name );
		}
		// ============================================================
		override public function OnSceneEvent(event:int, data:*):void 
		{
			super.OnSceneEvent(event, data);
		}
		// ============================================================
		override public function OnCommand(widget:Widget, command:String = null, data:* = null):void 
		{
			if ( widget.Name == DefaultOk )
			{
				if( mCallback != null )
					mCallback( null );
				mCore.CloseLastModal();
			}
		}
		// ============================================================
	}
	
}