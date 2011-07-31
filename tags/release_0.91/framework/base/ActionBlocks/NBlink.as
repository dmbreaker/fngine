package base.ActionBlocks
{
	import base.tweening.NTweener;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NBlink
	{
		// ============================================================
		private var mBlinkMS:int;
		private var mUnblinkMS:int;
		private var mSummaryMS:int;
		public var mCurrentMS:Number;
		private var mMaxMS:Number;
		private var mBlinkStarted:Boolean;
		private var mBlinkCompleteFunction:Function;
		// ============================================================
		public function NBlink( blink_ms:int, unblink_ms:int, blinkCompleteFunction:Function = null )
		{
			Set( blink_ms, unblink_ms, blinkCompleteFunction );
		}
		// ============================================================
		public function Set( blink_ms:int, unblink_ms:int, blinkCompleteFunction:Function = null ):void
		{
			mBlinkMS = blink_ms;
			mUnblinkMS = unblink_ms;
			mSummaryMS = mBlinkMS + mUnblinkMS;
			mBlinkCompleteFunction = blinkCompleteFunction;
			
			mBlinkStarted = false;
			mCurrentMS = 0;
		}
		// ============================================================
		public function DoBlink( blinks_count:int ):void
		{
			mBlinkStarted = true;
			mCurrentMS = 0;
			mMaxMS = Number(mSummaryMS * blinks_count);
			
			NTweener.to( this, mMaxMS / 1000, { mCurrentMS:mMaxMS, onComplete:OnBlinkComplete } );
		}
		// ============================================================
		/**
		 * Данное св-во показывает в каком состоянии сейчас находится блинкер
		 */
		public function get IsBlinkOn():Boolean
		{
			if ( mBlinkStarted )
			{
				var msec:Number = mCurrentMS;
				while ( msec > mSummaryMS )
					msec -= mSummaryMS;
					
				if ( msec < mBlinkMS )
					return true;
				else
					return false;
			}
			else
				return false;
		}
		// ============================================================
		private function OnBlinkComplete( obj:* ):void
		{
			mBlinkStarted = false;
			
			if ( mBlinkCompleteFunction != null )
				mBlinkCompleteFunction.apply();
		}
		// ============================================================
	}
	
}