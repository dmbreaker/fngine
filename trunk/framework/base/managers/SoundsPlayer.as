package base.managers
{
	import base.utils.NSettings;
	import base.core.NCore;
	import base.utils.SoundEx;
	
	import base.externals.TweenLite;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SoundsPlayer
	{
		// ============================================================
		private static const MAX_VOLUME:Number = 0.15;
		// ============================================================
		
		// ============================================================
		protected static var mSounds:Object = new Object();
		protected static var mMusicSamples:Object = new Object();
		//private static var mMusic:Sound;
		private static var mMusicSoundChannel:SoundChannel;
		private static var mMusicTransform:SoundTransform = new SoundTransform(MAX_VOLUME);
		
		private static var mIsMusicPlaying:Boolean = false;
		private static var mCurMusicObj:Object = {};
		private static var mCurMusicMaxVolume:Number = MAX_VOLUME;
		// ============================================================
		public function SoundsPlayer()
		{
			
		}
		// ============================================================
		public static function Init():void
		{
			// !!! проблема в том, что на разных машинах смещение по звуку считается по разному :(
			
			mCurMusicObj.volume = MAX_VOLUME;
			NSettings.eventDispatcher.addEventListener( NSettings.MUSIC_ENABLED_CHANGED, OnMusicEnabledChanged, false, 0, true );
		}
		// ============================================================
		private static function OnMusicEnabledChanged(e:Event):void
		{
			if ( NCore.Settings.MusicVolumeEnabled )
			{
				mCurMusicMaxVolume = MAX_VOLUME;
				mMusicTransform.volume = CurrentVolume;
				if ( mMusicSoundChannel )
				{
					mMusicSoundChannel.soundTransform = mMusicTransform;
				}
			}
			else
			{
				mCurMusicMaxVolume = 0;
				mMusicTransform.volume = CurrentVolume;
				if ( mMusicSoundChannel )
				{
					mMusicSoundChannel.soundTransform = mMusicTransform;
				}
			}
		}
		// ============================================================
		private static function get CurrentVolume():Number
		{
			return Math.min( mCurMusicMaxVolume, mCurMusicObj.volume );
		}
		// ============================================================
		public static function Play( sample_name:String, cycled:Boolean = false ):SoundChannel
		{
			if ( NCore.Settings.SoundVolumeEnabled == true )
			{
				var snd:SoundEx = SoundEx(mSounds[sample_name]);
				if ( snd != null )
				{
					var sndChannel:SoundChannel = snd.SoundObj.play(snd.SkipValue, (cycled)?int.MAX_VALUE:0);
					snd.SndChannel = sndChannel;
					return sndChannel;
				}
			}

			return null;
		}
		// ============================================================
		public static function PlayCycledIfNotPlaying( name:String ):SoundChannel
		{
			if ( NCore.Settings.SoundVolumeEnabled == true )
			{
				var snd:SoundEx = SoundEx(mSounds[name]);
				if ( snd )
				{
					if ( !snd.IsCycledSoundPlaying )
						return Play( name, true );
					else
						return snd.SndChannel;
				}
			}
			
			return null;
		}
		// ============================================================
		public static function PlayMusic( name:String ):void
		{
			mCurMusicObj.volume = MAX_VOLUME;
			
			if ( mMusicSoundChannel )
			{
				mMusicSoundChannel.stop();
			}
			
			var snd:SoundEx = SoundEx(mMusicSamples[name]);
			if ( snd != null )
			{
				//mMusic = snd.SoundObj;
				mMusicSoundChannel = snd.SoundObj.play(snd.SkipValue, int.MAX_VALUE);
				mIsMusicPlaying = true;
				mMusicTransform.volume = CurrentVolume;
				mMusicSoundChannel.soundTransform = mMusicTransform;
			}
		}
		// ============================================================
		private static var mPausePosition:int;
		public static function PauseMusic():void
		{
			if( mMusicSoundChannel )
			{
				TweenLite.killTweensOf( mCurMusicObj );
				TweenLite.to( mCurMusicObj, 0.25, { volume:0, onUpdate:OnMusicChange, onComplete:OnPause } );
			}
		}
		// ============================================================
		static private function OnMusicChange():void
		{
			mMusicTransform.volume = CurrentVolume;
			if ( mMusicSoundChannel )
			{
				mMusicSoundChannel.soundTransform = mMusicTransform;
			}
		}
		// ============================================================
		static private function OnPause():void
		{
			mPausePosition = mMusicSoundChannel.position;
			//mMusicSoundChannel.stop();
			//mIsMusicPlaying = false;
		}
		// ============================================================
		public static function ResumeMusic():void
		{
			
			/*if ( !mIsMusicPlaying )
			{
				if ( mMusic )
				{
					mMusicSoundChannel = mMusic.play( mPausePosition, int.MAX_VALUE );
					trace( "mMusicSoundChannel:", mMusicSoundChannel, "mMusicTransform:", mMusicTransform );
					if ( !mMusicSoundChannel )
						mMusicSoundChannel = mMusic.play( 0, int.MAX_VALUE );
					trace( "mMusicSoundChannel:", mMusicSoundChannel, "mMusicTransform:", mMusicTransform );
					mMusicSoundChannel.soundTransform = mMusicTransform;
					mIsMusicPlaying = true;
				}
			}*/
			
			TweenLite.killTweensOf( mCurMusicObj );
			TweenLite.to( mCurMusicObj, 0.25, { volume:MAX_VOLUME, onUpdate:OnMusicChange } );
		}
		// ============================================================
		public static function StopMusic():void
		{
			if( mMusicSoundChannel )
			{
				TweenLite.killTweensOf( mCurMusicObj );
				TweenLite.to( mCurMusicObj, 0.25, { volume:0, onUpdate:OnMusicChange, onComplete:OnStop } );
			}
		}
		// ============================================================
		public static function StopMusicNow():void
		{
			if ( mMusicSoundChannel )
			{
				mMusicSoundChannel.stop();
			}
			mIsMusicPlaying = false;
			mMusicSoundChannel = null;
			//mMusic = null;
		}
		// ============================================================
		public static function StopSound( name:String ):void
		{
			var snd:SoundEx = SoundEx(mSounds[name]);
			if( snd )
				snd.Stop();
		}
		// ============================================================
		public static function StopAllSounds():void 
		{
			for ( var name:String in mSounds )
			{
				var snd:SoundEx = SoundEx(mSounds[name]);
				if( snd )
					snd.Stop();
			}
		}
		// ============================================================
		static private function OnStop():void
		{
			mMusicSoundChannel.stop();
			mIsMusicPlaying = false;
			mMusicSoundChannel = null;
			//mMusic = null;
		}
		// ============================================================
		static public function get IsPlayingMusic():Boolean
		{
			return mIsMusicPlaying;
		}
		// ============================================================
	}
	
}