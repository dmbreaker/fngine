package base.managers
{
	import base.graphics.ImageFont;
	import flash.utils.Dictionary;
	
	/**
	 * Позже переделать на Singleton
	 * @author dmBreaker
	 */
	public class FontsManager 
	{
		// ============================================================
		private static var mInstance:FontsManager = null;
		// ============================================================
		private var mFonts:Dictionary = new Dictionary();
		private var mDefaultFontName:String;
		// ============================================================
		public function FontsManager() 
		{
		}
		// ============================================================
		public static function get Instance():FontsManager
		{
			if ( !mInstance )
				mInstance = new FontsManager();
			
			return mInstance;
		}
		// ============================================================
		public function get DefaultFontName():String
		{
			return mDefaultFontName;
		}
		// ============================================================
		public function GetDefaultFont():ImageFont
		{
			trace( mDefaultFontName );
			return new mFonts[mDefaultFontName]( mDefaultFontName );
		}
		// ============================================================
		public function GetFont( name:String ):ImageFont
		{
			if ( mFonts[name] )
				return new mFonts[name]( name );
			return null;
		}
		// ============================================================
		public function AppendFont( name:String, font:Class ):void 
		{
			mFonts[name] = font;
		}
		// ============================================================
		public function SetDefault( name:String ):void 
		{
			mDefaultFontName = name;
		}
		// ============================================================
	}
	
}