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
			return GetFont( mDefaultFontName );
		}
		// ============================================================
		public function GetFont( name:String ):ImageFont
		{
			var item:* = mFonts[name];
			if ( item )
			{
				return new ImageFont( name, ResourceManager.GetImage( item.image ), item.xml );
			}
			return null;
		}
		// ============================================================
		public function AppendFont( name:String, xml_name:String, image_name:String ):void 
		{
			mFonts[name] = {xml:xml_name, image:image_name};
		}
		// ============================================================
		public function SetDefault( name:String ):void 
		{
			mDefaultFontName = name;
		}
		// ============================================================
	}
	
}