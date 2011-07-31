package base.utils 
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSoundContainer 
	{
		// ============================================================
		// ============================================================
		private var mContainer:Vector.<NSound> = new Vector.<NSound>();
		
		private var mDefaultVolume:Number;
		private var mSoundObj:Sound;
		private var mSkip:Number;
		private var mIsCycled:Boolean;
		
		private var mTransform:SoundTransform = null;
		private var mMaxSounds:int = 0;
		private var mCurSounds:int = 0;
		// ============================================================
		// ============================================================
		public function NSoundContainer( sound:*, maxSounds:int = 0, skip:Number = 0,
											defaultVolume:Number = 1, cycled:Boolean = false ) 
		{
			if ( maxSounds > 0 )	// if streams per sound is limited
			{
				mMaxSounds = maxSounds;
				mContainer.length = maxSounds;
				mContainer.fixed = true;
			}
			
			mSoundObj = sound;
			mSkip = skip;
			mDefaultVolume = defaultVolume;
			mIsCycled = cycled;
			
			mTransform = new SoundTransform(defaultVolume);
		}
		// ============================================================
		// ============================================================
		public function Play():void
		{
			var count:int;
			var i:int;
			var item:NSound;
			
			if ( mMaxSounds > 0 )	// if limited streams count
			{
				count = mContainer.length;
				for (i = 0; i < count; i++) 
				{
					item = mContainer[i];
					if ( !item )
					{
						item = new NSound(mSoundObj, mSkip, mTransform, mIsCycled);
						mContainer[i] = item;
						item.Play();
						++mCurSounds;
						return;
					}
					else if ( !item.IsPlaying )
					{
						item.Play();
						++mCurSounds;
						return;
					}
				}
				
				// if free sound was not found:
				StopOldest();
				Play();		// yeah, recursive, but only once
			}
			else
			{
				count = mContainer.length;
				for (i = 0; i < count; i++) 
				{
					item = mContainer[i];
					if ( !item )
					{
						item = new NSound(mSoundObj, mSkip, mTransform, mIsCycled);
						mContainer[i] = item;
						item.Play();
						return;
					}
					else if ( !item.IsPlaying )
					{
						item.Play();
						return;
					}
				}
				
				var snd:NSound = new NSound(mSoundObj, mSkip, mTransform, mIsCycled);
				mContainer.push( snd );
				snd.Play();
			}
		}
		// ============================================================
		public function PlayIfNotPlaying():void
		{
			if ( !IsPlayingSome )
			{
				Play();
			}
		}
		// ============================================================
		public function get IsPlayingSome():Boolean
		{
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item && item.IsPlaying )
					return true;
			}
			
			return false;
		}
		// ============================================================
		public function StopAll():void 
		{
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item && item.IsPlaying )
					item.Stop();
			}
			
			mCurSounds = 0;
		}
		// ============================================================
		public function StopOldest():void
		{
			var oldest_time:int = -1;
			var oldest_index:int = -1;
			
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item && item.IsPlaying )
				{
					var cur_time:int = item.LiveTime;
					if ( cur_time > oldest_time )
					{
						oldest_time = cur_time;
						oldest_index = i;
					}
				}
			}
			
			if ( oldest_index >= 0 )
			{
				mContainer[oldest_index].Stop();
				if( mMaxSounds > 0 )
					--mCurSounds;
			}
		}
		// ============================================================
		public function Update( ms:int ):void
		{
			var playingCount:int = 0
			
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item && item.IsPlaying )
				{
					item.Update( ms );
					++playingCount
				}
			}
			
			if( mMaxSounds > 0 )
				mCurSounds = playingCount;
		}
		// ============================================================
		public function set Volume( volume:Number ):void
		{
			mTransform.volume = volume * mDefaultVolume;
			
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item )
				{
					item.UpdateTransform();
				}
			}
		}
		// ============================================================
		public function Pause():void 
		{
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item )
				{
					item.Pause();
				}
			}
		}
		// ============================================================
		public function Resume():void 
		{
			var count:int = mContainer.length;
			for (var i:int = 0; i < count; i++) 
			{
				var item:NSound = mContainer[i];
				if ( item )
				{
					item.Resume();
				}
			}
		}
		// ============================================================
	}

}