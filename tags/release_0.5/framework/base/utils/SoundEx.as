package base.utils
{
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SoundEx
	{
		private var mSoundObj:Sound;
		private var mSkip:Number;
		
		public function SoundEx( sound:Sound, skip:Number=0 )
		{
			mSoundObj = sound;
			mSkip = skip;
		}
		
		public function get SoundObj():Sound
		{
			return mSoundObj;
		}
		
		public function get SkipValue():Number
		{
			return mSkip;
		}
	}
	
}