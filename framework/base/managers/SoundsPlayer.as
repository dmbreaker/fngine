package base.managers
{
	import base.utils.NSettings;
	import base.core.NCore;
	import base.utils.NSoundContainer;
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
		protected static var mCurMusicTrack:String = "";
		//private static var mMusic:Sound;
		private static var mMusicSoundChannel:SoundChannel;
		private static var mMusicTransform:SoundTransform = new SoundTransform(MAX_VOLUME);
		
		private static var mIsMusicPlaying:Boolean = false;
		private static var mCurMusicObj:Object = {};
		private static var mCurMusicMaxVolume:Number = MAX_VOLUME;
		
		private static var mPrevSoundVolume:Number = 1;
		private static var mPrevMusicVolume:Number = 1;
		private static var mPrevMuteState:Boolean = false;
		// ============================================================
		public function SoundsPlayer()
		{
		}
		// ============================================================
		public static function Init():void
		{
			// !!! проблема в том, что на разных машинах смещение по звуку считается по разному :(
			
			mCurMusicObj.volume = MAX_VOLUME;
			//NSettings.eventDispatcher.addEventListener( NSettings.SOUND_MUTE_CHANGED, OnMuteChanged, false, 0, true );
		}
		// ============================================================
		public static function SaveSound(name:String, snd:*, skip:Number = 0, volume:Number = 100, cycled:Boolean = false, maxSounds:int = 0):void
		{
			mSounds[name] = new NSoundContainer( snd, maxSounds, skip, volume / 100.0, cycled );
		}
		// ============================================================
		/*private static function OnMuteChanged(e:Event):void
		{
			if ( !NCore.Settings.SoundMuted )
			{
				mCurMusicMaxVolume = MAX_VOLUME;
				mMusicTransform.volume = CurrentMusicVolume;
				if ( mMusicSoundChannel )
				{
					mMusicSoundChannel.soundTransform = mMusicTransform;
				}
			}
			else
			{
				mCurMusicMaxVolume = 0;
				mMusicTransform.volume = CurrentMusicVolume;
				if ( mMusicSoundChannel )
				{
					mMusicSoundChannel.soundTransform = mMusicTransform;
				}
			}
		}*/
		// ============================================================
		private static function get CurrentMusicVolume():Number
		{
			if ( mPrevMuteState )
				return 0;
			else
				return mPrevMusicVolume;
		}
		// ============================================================
		public static function Play( sample_name:String ):SoundChannel
		{
			var snd:NSoundContainer = mSounds[sample_name];
			if( snd )
				snd.Play();
			
			return null;
		}
		// ============================================================
		public static function PlayIfNotPlaying( name:String ):SoundChannel
		{
			var snd:NSoundContainer = mSounds[name];
			if( snd )
				snd.PlayIfNotPlaying();
			
			return null;
		}
		// ============================================================
		public static function PlayMusic( name:String ):void
		{
			if ( name == mCurMusicTrack )
				return;
			
			mCurMusicObj.volume = 1;
			
			if ( mMusicSoundChannel )
			{
				mMusicSoundChannel.stop();
			}
			
			mCurMusicTrack = name;
			var snd:SoundEx = SoundEx(mMusicSamples[name]);
			if ( snd != null )
			{
				//mMusic = snd.SoundObj;
				mMusicSoundChannel = snd.SoundObj.play(snd.SkipValue, int.MAX_VALUE);
				mIsMusicPlaying = true;
				mMusicTransform.volume = CurrentMusicVolume;
				if ( mMusicSoundChannel )
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
				mCurMusicObj.volume = 1;
				TweenLite.to( mCurMusicObj, 0.25, { volume:0, onUpdate:OnMusicChange, onComplete:OnPause } );
			}
		}
		// ============================================================
		static private function OnMusicChange():void
		{
			mMusicTransform.volume = CurrentMusicVolume * mCurMusicObj.volume;
			if ( mMusicSoundChannel )
			{
				mMusicSoundChannel.soundTransform = mMusicTransform;
			}
		}
		// ============================================================
		static private function OnPause():void
		{
			mPausePosition = mMusicSoundChannel.position;
			mMusicSoundChannel.stop();
			mIsMusicPlaying = false;
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
			
			if ( !mIsMusicPlaying )
			{
				mCurMusicObj.volume = 0;
				var snd:SoundEx = SoundEx(mMusicSamples[mCurMusicTrack]);
				mMusicSoundChannel = snd.SoundObj.play( mPausePosition, int.MAX_VALUE );
				mIsMusicPlaying = true;
				mMusicTransform.volume = CurrentMusicVolume * mCurMusicObj.volume;
				if ( mMusicSoundChannel )
					mMusicSoundChannel.soundTransform = mMusicTransform;
			}

			TweenLite.killTweensOf( mCurMusicObj );
			TweenLite.to( mCurMusicObj, 0.25, { volume:1, onUpdate:OnMusicChange } );
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
			
			mCurMusicTrack = "";
			//mMusic = null;
		}
		// ============================================================
		public static function StopSound( name:String ):void
		{
			var snd:NSoundContainer = mSounds[name];
			if( snd )
				snd.StopOldest();
		}
		// ============================================================
		public static function StopAllSounds():void 
		{
			for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.StopAll();
			}
		}
		// ============================================================
		static private function OnStop():void
		{
			mMusicSoundChannel.stop();
			mIsMusicPlaying = false;
			mMusicSoundChannel = null;
			//mMusic = null;
			
			mCurMusicTrack = "";
		}
		// ============================================================
		public static function PauseSounds():void 
		{
			for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.Pause();
			}
		}
		// ============================================================
		public static function ResumeSounds():void 
		{
			for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.Resume();
			}
		}
		// ============================================================
		static public function get IsPlayingMusic():Boolean
		{
			return mIsMusicPlaying;
		}
		// ============================================================
		static private function set SoundVolume( vol:Number ):void 
		{
			for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.Volume = vol;
			}
		}
		// ============================================================
		static private function set MusicVolume( vol:Number ):void 
		{
			/*for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.Volume = vol;
			}*/
			mMusicTransform.volume = vol;
			if ( mMusicSoundChannel )
				mMusicSoundChannel.soundTransform = mMusicTransform;
		}
		// ============================================================
		static public function Update( ms:int ):void
		{
			if ( mPrevMuteState != NCore.Settings.SoundMuted )
			{
				mPrevMuteState = NCore.Settings.SoundMuted;
				if ( mPrevMuteState )
				{
					SoundVolume = 0;
					MusicVolume = 0;
				}
				else
				{
					SoundVolume = mPrevSoundVolume;
					MusicVolume = mPrevMusicVolume;
				}
			}
			
			if ( NCore.Settings.mSoundVolume != mPrevSoundVolume )
			{
				mPrevSoundVolume = NCore.Settings.mSoundVolume;
				if ( !mPrevMuteState )
					SoundVolume = mPrevSoundVolume;
			}
			if ( NCore.Settings.mMusicVolume != mPrevMusicVolume )
			{
				mPrevMusicVolume = NCore.Settings.mMusicVolume;
				if ( !mPrevMuteState )
				{
					MusicVolume = mPrevMusicVolume;					
				}
			}
			
			// update all sound samples:
			for ( var name:String in mSounds )
			{
				var snd:NSoundContainer = mSounds[name];
				if( snd )
					snd.Update( ms );
			}
		}
		// ============================================================
	}
	
}