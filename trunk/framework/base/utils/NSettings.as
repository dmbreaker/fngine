package base.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NSettings
	{
		public static const MUSIC_ENABLED_CHANGED:String = "musicenablechanged";
		
		public var mMusicVolumeEnabled:Boolean;	// public для того, чтобы можно было сохранить/загрузить
		public var SoundVolumeEnabled:Boolean;
		
		private static var mDispatcher:EventDispatcher = new EventDispatcher();
		
		public function NSettings()
		{
			
		}
		// ============================================================
		public function CopyObject( o:* ):void
		{
			for ( var name:String in o )
			{
				this[name] = o[name];
			}
		}
		// ============================================================
		public function InitDefault():void
		{
			MusicVolumeEnabled = true;
			SoundVolumeEnabled = true;
		}
		// ============================================================
		public function get MusicVolumeEnabled():Boolean
		{
			return mMusicVolumeEnabled;
		}
		// ============================================================
		public function set MusicVolumeEnabled( enabled:Boolean ):void
		{
			mMusicVolumeEnabled = enabled;
			mDispatcher.dispatchEvent( new Event( MUSIC_ENABLED_CHANGED ) );
		}
		// ============================================================
		public static function get eventDispatcher():EventDispatcher
		{
			return mDispatcher;
		}
		// ============================================================
	}
	
}