package base.managers 
{
	import base.externals.bulkloader.BulkLoader;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import XML;

	/**
	 * ...
	 * @author ...
	 */
	public class XmlManager
	{
		// ============================================================
		public static const XMLS_LOADED:String = "xmls_loaded";
		// ============================================================
		private static var mInstance:XmlManager = null;
		// ============================================================
		protected var mLoader:URLLoader;
		protected var mXmlsCache:Dictionary = new Dictionary();
		protected var mXmlsToLoad:Array = new Array();
		protected var mBulkLoader:BulkLoader;
		
		protected var mReleaseNames:Array = new Array();
		protected var mReleaseSource:*;
		// ============================================================
		public var CompleteDispatcher:EventDispatcher = new EventDispatcher();
		// ============================================================
		public function XmlManager() 
		{
			mBulkLoader = new BulkLoader("xmls_loader");
			mBulkLoader.addEventListener(BulkLoader.COMPLETE, onXmlsLoadComplete);
		}
		// ============================================================
		private function onXmlsLoadComplete(e:Event):void 
		{
			CONFIG::debug
			{
				for each (var name:String in mXmlsToLoad)
				{
					mXmlsCache[name] = mBulkLoader.getXML("../xml/" + name + ".xml");
				}
			}
			
			// отправить сообщение об окончании загрузки XML
			CompleteDispatcher.dispatchEvent( new Event(XMLS_LOADED) );
		}
		// ============================================================
		public static function get Instance():XmlManager
		{
			if ( !mInstance )
				mInstance = new XmlManager();
			
			return mInstance;
		}
		// ============================================================
		public function SetXMLSourceObject( source:* ):void
		{
			mReleaseSource = source;
			mReleaseNames.length = 0;
			
			// let's parse it by reflection:
			var xml:XML = describeType(source);
			var list:XMLList = xml..variable.@name;
			for each (var v:* in list )
			{
				var str:String = v.toString();
				str = str.substr( "Embed_".length );
				CONFIG::debug
				{
					AddXML( str );
				}
				CONFIG::release
				{
					mReleaseNames.push( str );
				}
			}
		}
		// ============================================================
		public function AddXML( name:String ):void
		{
			mXmlsToLoad.push(name);
		}
		// ============================================================
		public function LoadXmls():void
		{
			CONFIG::debug
			{
				for each (var name:String in mXmlsToLoad)
					mBulkLoader.add("../xml/" + name + ".xml");
				mBulkLoader.start();
			}
			CONFIG::release
			{
				for each (var name:String in mReleaseNames)
				{
					var fullname:String = "Embed_" + name;
					var file:ByteArray = new mReleaseSource[fullname];
					var str:String = file.readUTFBytes( file.length );
					var xml:XML = new XML( str );
					
					mXmlsCache[name] = xml;
				}
			
				// send event-message that XML was loaded
				CompleteDispatcher.dispatchEvent( new Event(XMLS_LOADED) );
			}
		}
		// ============================================================
		public function GetXML( name:String ):XML
		{
			if ( mXmlsCache[name] != undefined && mXmlsCache[name] )
				return XML(mXmlsCache[name]);
			
			return null;
		}
		// ============================================================
		public function GetXMLRaw( name:String ):*
		{
			if ( mXmlsCache[name] != undefined && mXmlsCache[name] )
				return mXmlsCache[name];
			
			return null;
		}
		// ============================================================
		// ============================================================
	}

}