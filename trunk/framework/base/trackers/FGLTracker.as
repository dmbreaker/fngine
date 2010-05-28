package base.trackers
{
	
	import base.core.NCore;
	import base.externals.FGL.GameTracker.GameTrackerErrorEvent;
	import base.externals.FGL.GameTracker.GameTracker;
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class FGLTracker
	{
		
		public function FGLTracker()
		{
			init();
		}
			
		private var tracker:GameTracker = new GameTracker();
		
		internal function init():void
		{
			try
			{
				tracker.addEventListener(GameTracker.GAMETRACKER_CODING_ERROR, onCodingError);
				tracker.addEventListener(GameTracker.GAMETRACKER_SERVER_ERROR, onCodingError);
				//blah.text =
			}
			catch ( er:Error )
			{
				// ...
			}
		}
		
		public function StartLevel( levelNumber:Number, score:Number, state:String = "none", customMsg:String = "none" ):void
		{
			try
			{
				if( NCore.Instance.IsFGLVersion )
					tracker.beginLevel(levelNumber, score, state, customMsg);
			}
			catch ( er:Error )
			{
				// ...
			}
		}
		
		public function EndLevel( score:Number, state:String = "none", customMsg:String = "none" ):void
		{
			try
			{
				if( NCore.Instance.IsFGLVersion )
					tracker.endLevel(score, state, customMsg);
			}
			catch ( er:Error )
			{
				// ...
			}
		}
		
		public function StartGame( score:Number, state:String = "none", customMsg:String = "none" ):void
		{
			try
			{
				if( NCore.Instance.IsFGLVersion )
					tracker.beginGame(score, state, customMsg);
			}
			catch ( er:Error )
			{
				// ...
			}
		}
		
		public function EndGame( score:Number, state:String = "none", customMsg:String = "none" ):void
		{
			try
			{
				if( NCore.Instance.IsFGLVersion )
					tracker.endGame( score, state, customMsg );
			}
			catch ( er:Error )
			{
				// ...
			}
		}
		// ============================================================
		public function SendMsg( msgType:String, msg:String = null ):void
		{
			try
			{
				tracker.customMsg( msgType, 0, null, msg );
			}
			catch (er:Error)
			{
				// ...
			}
		}
		// ============================================================
		
		internal function onCodingError(evt:GameTrackerErrorEvent):void
		{
			//blah.text = evt._msg;
		}
	}
	
}