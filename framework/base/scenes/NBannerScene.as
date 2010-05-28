package base.scenes
{
	import base.modelview.Widget;
	import base.core.*;
	import base.externals.TweenLite;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NBannerScene extends NScene
	{
		// ============================================================
		
		// ============================================================
		public function NBannerScene( core:NCore, name:String )
		{
			super( core, name );
		}
		// ============================================================
		override public function OnSceneEvent(event:int, data:*):void
		{
			//super.OnSceneEvent( event, data );
			
			if ( event == NSceneEvent.evtTransitionComplete )
			{
				if ( data == true )
				{
					TweenLite.to( this, 1, { onComplete:OnShowTimeEnd } );
				}
			}
		}
		// ============================================================
		protected function OnShowTimeEnd():void
		{
			mCore.SwitchTo( DefaultNextScene );
		}
		// ============================================================
	}
	
}