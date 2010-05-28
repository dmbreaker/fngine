package base.scenes
{
	import base.modelview.Widget;
	import base.core.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NYesNoScene extends NModalScene
	{
		// ============================================================
		public function NYesNoScene( core:NCore, name:String )
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
			if ( widget.Name == DefaultYes )
			{
				if( mCallback != null )
					mCallback( true );
				mCore.CloseLastModal();
			}
			else if ( widget.Name == DefaultNo )
			{
				if( mCallback != null )
					mCallback( false );
				mCore.CloseLastModal();
			}
		}
		// ============================================================
	}
	
}