package base.scenes
{
	import base.controls.NText;
	import base.modelview.Widget;
	import base.core.*;
	import base.externals.TweenLite;
	import base.utils.Key;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NProfilerScene extends NScene
	{
		// ============================================================
		public var ProfilerText:String = "";
		// ============================================================
		
		// ============================================================
		public function NProfilerScene( core:NCore, name:String )
		{
			super( core, name );
		}
		// ============================================================
		override public function OnSceneEvent(event:int, data:*):void
		{
			//super.OnSceneEvent( event, data );
			
			if ( event == NSceneEvent.evtTransitionComplete )
			{
				//var isShowing:Boolean = Boolean(data);
				//if ( isShowing == true )
				//{
					//var text:NText = mWidgets.FindWidget( "idText" );
					//if ( text )
						//text.Text = ProfilerText;
				//}
			}
			else if ( event == NSceneEvent.evtTransitionStarted )
			{
				var isShowing:Boolean = Boolean(data);
				if ( isShowing == true )
				{
					var text:NText = NText(mWidgets.FindWidget( "idText" ));
					if ( text )
						text.Text = ProfilerText;
				}
			}
		}
		// ============================================================
		override public function OnCommand(widget:Widget, command:String = null, data:* = null):void 
		{
			if ( widget.Name == DefaultOk )
			{
				mCore.SwitchToPrevious();
			}
		}
		// ============================================================
	}
	
}