package base.utils 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSound 
	{
		// ============================================================
		// ============================================================
		private var mSoundObj:Sound;
		private var mSkip:Number;
		private var mSndChannel:SoundChannel;
		
		private var mIsCycled:Boolean = false;
		private var mTransform:SoundTransform = null;
		
		private var mIsPlaying:Boolean = false;
		
		private var mLiveTime:int;
		// ============================================================
		// ============================================================
		public function NSound( sound:*, skip:Number = 0, transform:SoundTransform = null, cycled:Boolean = false ) 
		{
			mSoundObj = Sound(sound);
			mSkip = skip;
			mIsCycled = cycled;
		}
		// ============================================================
		// ============================================================
		public function Play():void
		{
			mLiveTime = 0;
			mIsPlaying = true;
			
			mSndChannel = mSoundObj.play(mSkip, (mIsCycled)?int.MAX_VALUE:0, mTransform);
			if ( mSndChannel )
				mSndChannel.addEventListener(Event.SOUND_COMPLETE, OnSoundComplete, false, 0, true);
		}
		// ============================================================
		private function OnSoundComplete(e:Event):void 
		{
			mIsPlaying = false;
		}
		// ============================================================
		public function get IsPlaying():Boolean
		{
			return mIsPlaying;
		}
		// ============================================================
		public function Stop():void
		{
			if ( mIsPlaying )
			{
				mLiveTime = 0;
				mIsPlaying = false;
				if( mSndChannel )
					mSndChannel.stop();
			}
		}
		// ============================================================
		public function Update( ms:int ):void
		{
			mLiveTime += ms;
		}
		// ============================================================
		public function get LiveTime():int
		{
			if( mIsPlaying )
				return mLiveTime;
			else
				return -1;
		}
		// ============================================================
	}

}