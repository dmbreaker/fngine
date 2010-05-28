package base.trackers
{
	import com.google.analytics.GATracker;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class GAnalytics 
	{
		// ============================================================
		private static const GA_Account:String = "";	// FIX "UA-XXXXXXXXXXXXXXXXXXX"
		// ============================================================
		private var mTracker:GATracker;
		// ============================================================
		public function GAnalytics() 
		{
			
		}
		// ============================================================
		public function Initialize( parent:MovieClip ):void 
		{
			try
			{
				mTracker = new GATracker( parent, GA_Account, "AS3", false );
			}
			catch (e:Error)
			{
				trace( "[GoogleA] Error(" + e.errorID + "): " + e.message );
			}
		}
		// ============================================================
		public function TrackPage( pageURL:String ):void 
		{
			try
			{
				if( mTracker )
					mTracker.trackPageview( pageURL );
			}
			catch (e:Error)
			{
				trace( "[GoogleA] Error(" + e.errorID + "): " + e.message );
			}
		}
		// ============================================================
		public function TrackEvent( category:String, action:String, label:String = null, value:Number = NaN ):void 
		{
			try
			{
				if( mTracker )
					mTracker.trackEvent( category, action, label, value );
			}
			catch (e:Error)
			{
				trace( "[GoogleA] Error(" + e.errorID + "): " + e.message );
			}
		}
		// ============================================================
	}
	
}