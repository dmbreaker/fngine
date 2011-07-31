package base.utils 
{
	import base.utils.Methods;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author ...
	 */
	public class NSignalsGenerator extends EventDispatcher
	{
		// ============================================================
		// ============================================================
		private var mID:String = "";

		private var mSignalsID:Vector.<String> = new Vector.<String>();
		private var mSignalsTime:Vector.<int> = new Vector.<int>();

		private var mIsStarted:Boolean = false;
		private var mIsLatencyComplete:Boolean = false;
		
		private var mLatencyMinTime:int;
		private var mLatencyMaxTime:int;
		private var mLatencyTime:int;
		private var mGenTime:int;
		private var mCurTime:int;

		private var mGenerateOnStart:Boolean = false;
		//ISignalsGeneratorListener* mListener;
		// ============================================================
		// ============================================================
		public function NSignalsGenerator() 
		{
			Init();
		}
		// ============================================================
		// ============================================================
		public function SetGenerateOnStart( value:Boolean ):void
		{
			mGenerateOnStart = value;
		}
		// ============================================================
		public function ResetTimer():void
		{
			mCurTime = 0;
		}
		// ============================================================
		public function IsStarted():Boolean
		{
			return mIsStarted;
		}
		// ============================================================
		public function HasSignals():Boolean
		{
			return mSignalsID.length > 0;
		}
		// ============================================================
		private function Init():void
		{
			mIsStarted = false;
			mIsLatencyComplete = false;
			mLatencyMinTime = 0;
			mLatencyMaxTime = 0;
			mLatencyTime = 0;
			mGenTime = 1;
			mCurTime = 0;
			mGenerateOnStart = false;
		}
		// ============================================================
		public function Initialize( id:String, latency_min:int, latency_max:int ):void
		{
			mID = id;
			Init();
			mLatencyMinTime = latency_min;
			mLatencyMaxTime = latency_max;
		}
		// ============================================================
		public function Start():void
		{
			if( !mIsStarted )
			{
				mGenTime = GetFirstSignalTime();
				mLatencyTime = Methods.Rand( mLatencyMinTime, mLatencyMaxTime );
				mIsLatencyComplete = false;

				mIsStarted = true;
			}
		}
		// ============================================================
		public function Restart():void
		{
			mCurTime = 0;
			mIsStarted = false;
			Start();
		}
		// ============================================================
		public function Stop():void
		{
			mCurTime = 0;
			mIsStarted = false;
		}
		// ============================================================
		public function StartNext():void
		{
			mGenTime = GetFirstSignalTime();
			mCurTime = 0;
			mIsStarted = true;
		}
		// ============================================================
		public function Generate():void
		{
			dispatchEvent(new NSignalEvent(mID, GetFirstSignalID()));

			RemoveFirstSignal();
			if( HasSignals() )
				StartNext();
			else
				Stop();
		}
		// ============================================================
		public function Update( ms:int ):void
		{
			if( mIsStarted )
			{
				mCurTime += ms;

				if( !mIsLatencyComplete )
				{
					if( mCurTime >= mLatencyTime )
					{
						mIsLatencyComplete = true;
						mCurTime = 0;
						if( mGenerateOnStart )
						{
							Generate();
						}
					}
				}
				else if( mCurTime >= mGenTime && HasSignals() )
				{
					Generate();
				}
			}
		}
		// ============================================================
		public function Clear():void
		{
			mSignalsID.length = 0;
			mSignalsTime.length = 0;
		}
		// ============================================================
		public function AddSignal( id:String, time:int ):void
		{
			mSignalsID.push( id );
			mSignalsTime.push( time );
		}
		// ============================================================
		public function GetFirstSignalTime():int
		{
			if( mSignalsTime.length > 0 )
				return mSignalsTime[0];
			else
			{
				return 0;
			}
		}
		// ============================================================
		public function GetFirstSignalID():String
		{
			if( mSignalsID.length > 0 )
				return mSignalsID[0];
			else
				return "";
		}
		// ============================================================
		public function RemoveFirstSignal():void
		{
			if( mSignalsTime.length > 0 )
			{
				mSignalsTime.shift();	// erase( mSignalsTime.begin() );
				mSignalsID.shift();		// erase( mSignalsID.begin() );
			}
		}
		// ============================================================
		// ============================================================
	}

}