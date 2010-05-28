package base.core
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NModalScene extends NScene
	{
		// ============================================================
		protected var mCallback:Function;
		// ============================================================
		public function NModalScene( core:NCore, name:String )
		{
			super( core, name );
		}
		// ============================================================
		override public function OnSceneEvent(event:int, data:*):void 
		{
			super.OnSceneEvent(event, data);
			
			if ( event == NSceneEvent.evtModalShowingStarted )
			{
				mCallback = data;
			}
		}
		// ============================================================
		protected function DoCallback( value:int ):void 
		{
			if ( mCallback != null )
				mCallback( value );
		}
		// ============================================================
	}
	
}