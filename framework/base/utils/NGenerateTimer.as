package base.utils 
{
	import base.utils.Methods;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NGenerateTimer 
	{
		// ============================================================
		// ============================================================
		private var mIsStarted:Boolean;
		private var mIsLatencyComplete:Boolean;
		
		private var mLatencyMinTime:int;
		private var mLatencyMaxTime:int;
		private var mLatencyTime:int;

		private var mGenMinTime:int;
		private var mGenMaxTime:int;
		private var mGenTime:int;
		private var mCurTime:int;

		private var mListener:IGenerateTimerListener;
		private var mGenerateOnStart:Boolean;
		// ============================================================
		// ============================================================
		public function NGenerateTimer() 
		{
			mListener = null;
			Init();
		}
		// ============================================================
		// ============================================================
		private function Init():void
		{
			mIsStarted = false;
			mIsLatencyComplete = false;
			mLatencyMinTime = 0;
			mLatencyMaxTime = 0;
			mLatencyTime = 0;
			mGenMinTime = 1000;
			mGenMaxTime = 1000;
			mGenTime = 1;
			mCurTime = 0;
			mGenerateOnStart = false;
		}
		// ============================================================
		public function Initialize( latency_min:int, latency_max:int, gen_min:int, gen_max:int ):void
		{
			Init();
			mLatencyMinTime = latency_min;
			mLatencyMaxTime = latency_max;

			mGenMinTime = gen_min;
			mGenMaxTime = gen_max;
		}
		// ============================================================
		public function Start():void
		{
			if( !mIsStarted )
			{
				mLatencyTime = Methods.Rand( mLatencyMinTime, mLatencyMaxTime );
				mGenTime = Methods.Rand( mGenMinTime, mGenMaxTime );
				mIsLatencyComplete = false;

				mIsStarted = true;
			}
		}
		// ============================================================
		public function Restart():void
		{
			mIsStarted = false;
			Start();
		}
		// ============================================================
		public function Stop():void
		{
			mIsStarted = false;
		}
		// ============================================================
		public function StartNext():void
		{
			mCurTime = 0;
			mIsStarted = true;
		}
		// ============================================================
		public function Generate():void
		{
			mCurTime = 0;			// после генерации сбросим таймер
			mIsStarted = false;		// после генерации притормозим таймер
			mGenTime = Methods.Rand( mGenMinTime, mGenMaxTime );		// перегенерим время генерации

			if( mListener )
				mListener.DoGeneration();		// вызовем событие генерации
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
				else if( mCurTime >= mGenTime )
				{
					Generate();
				}
			}
		}
		// ============================================================
		public function SetGenerateOnStart( value:Boolean ):void
		{
			mGenerateOnStart = value;
		}
		// ============================================================
		public function ResetTimer():void
		{
			mCurTime = 0;
		}	// сбрасывает тики в ноль
		// ============================================================
		public function IsStarted():Boolean
		{
			return mIsStarted;
		}
		// ============================================================
		public function GetGenerationProgress():Number
		{
			return Number(mCurTime) / Number(mGenTime);
		}
		// ============================================================
		public function SetGenerationProgressPercent( percent:Number ):void
		{
			mCurTime = int(percent * Number(mGenTime));
		}
		// ============================================================
		public function AddListener( listener:IGenerateTimerListener ):void
		{
			mListener = listener;
		}
		// ============================================================
		// ============================================================
	}

}