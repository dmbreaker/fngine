package base.utils
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SoundEx
	{
		// ============================================================
		// ============================================================
		private var mSoundObj:Sound;
		private var mSkip:Number;
		private var mSndChannel:SoundChannel;
		private var mDefaultVolume:Number;
		// ============================================================
		// ============================================================
		public function SoundEx( sound:*, skip:Number=0, volume:Number = 100 )
		{
			mSoundObj = Sound(sound);
			mSkip = skip;
			mDefaultVolume = volume / 100.0;
		}
		// ============================================================
		public function get SoundObj():Sound
		{
			return mSoundObj;
		}
		// ============================================================
		public function get SkipValue():Number
		{
			return mSkip;
		}
		// ============================================================
		public function get SndChannel():SoundChannel
		{
			return mSndChannel;
		}
		// ============================================================
		public function set SndChannel( channel:SoundChannel ):void
		{
			mSndChannel = channel;
		}
		// ============================================================
		public function Stop():void
		{
			if ( mSndChannel )
				mSndChannel.stop();
			mSndChannel = null;
		}
		// ============================================================
		public function get IsCycledSoundPlaying():Boolean
		{
			if ( !mSndChannel )
				return false;
			else
				return true;	// only for cycled sounds!
		}
		// ============================================================
		
	}
	
}