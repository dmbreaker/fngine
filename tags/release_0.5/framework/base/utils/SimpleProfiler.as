package base.utils
{
	import base.core.NCore;
	import flash.utils.getTimer;
	
	public final class SimpleProfiler
	{
		private static var mTotal:* = new Object();
		private static var mStartTime:* = new Object();
		private static var mChecksCount:* = new Object();
		
		public function SimpleProfiler()
		{
		}

		public static function Reset( label:String ):void
		{
			mTotal[label] = 0;
			mStartTime[label] = 0;
			mChecksCount[label] = 0;
		}
		
		public static function Start( label:String ):void
		{
			if ( NCore.Instance.IsProfilerEnabled == true )
			{
				if( mTotal[label] == null )
					Reset(label);
				
				mChecksCount[label] = mChecksCount[label] + 1;
				mStartTime[label] = getTimer();
			}
		}
		
		public static function Stop( label:String ):void
		{
			if ( NCore.Instance.IsProfilerEnabled == true )
			{
				var time:int = getTimer();
				mTotal[label] = mTotal[label] + (time - mStartTime[label]);
			}
		}
		
		public static function StopEx( label:String ):void
		{
			var time:int = getTimer();
			mTotal[label] = mTotal[label] + (time - mStartTime[label]);
			var checks_count:int = mChecksCount[label];
			if( checks_count >= 300 )
			{
				var average_time:Number = mTotal[label] / checks_count;
				trace( "Profile("+label+") = " + average_time.toFixed(3) );
				Reset( label );
			}
		}
		
		public static function Trace( label:String ):void
		{
			var average_time:Number = mTotal[label] / mChecksCount[label];
			trace( "Profile("+label+") = " + average_time.toFixed(3) );
		}
		
		public static function GetFullStatistics():String
		{
			var result:String = "";
			var label:String;
			for ( label in mTotal )
			{
				var average_time:Number = mTotal[label] / mChecksCount[label];
				var tmp:String = label + ": " + average_time.toFixed(3) + " (" + mChecksCount[label] + "/" + mTotal[label] + ")\r\n";
				result += tmp;
			}
			
			return result + "\r\n-----";
		}
	}
}