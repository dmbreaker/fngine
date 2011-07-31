package base.core
{
	import base.controls.Control;
	import base.utils.Methods;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Defines style/settings of control
	 * @author dmBreaker
	 */
	public class NStyle
	{
		// ============================================================
		public static const NameText:String = "name";
		private static const ParentText:String = "parent";
		// ============================================================
		protected var mName:String;
		
		public var Settings:* = { };
		public var Rect:* = { };
		public var Images:* = { };
		// ============================================================
		public function NStyle()
		{
			
		}
		// ============================================================
		public function get Name():String
		{
			return mName;
		}
		// ============================================================
		protected function CopyTo( childStyle:NStyle ):void
		{
			Methods.CopyFields( Settings, childStyle.Settings );
			Methods.CopyFields( Rect, childStyle.Rect );
			Methods.CopyFields( Images, childStyle.Images );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public static function Parse( xml:XML ):NStyle
		{
			var currentStyle:NStyle = new NStyle();
			
			if ( xml )
			{
				var value:* = Methods.GetAttributeValue( xml, ParentText );

				if ( value )
				{
					var parent:String = value.toString();
					var parentStyle:NStyle = NCore.GetStyle( parent );
					if ( parentStyle )
						parentStyle.CopyTo( currentStyle );
				}

				var attrs:XMLList = xml.attributes();
				for each( var attr:XML in attrs )
				{
					var attr_name:String = attr.name().toString();
					if ( attr_name == NameText )
						currentStyle.mName = String(attr.valueOf());
				}
				
				var settings:* = ParseSettings( xml );
				var rect:* = Control.ParseRect( xml );
				var images:* = Control.ParseImages( xml );
				
				Methods.CopyFields( settings, currentStyle.Settings );
				Methods.CopyFields( rect, currentStyle.Rect );
				Methods.CopyFields( images, currentStyle.Images );
				
				return currentStyle;
			}
			
			return null;
		}
		// ============================================================
		public static function ParseSettings( el:XML ):*
		{
			var settings:* = {};
			var list:XMLList = el.settings;
			
			if ( list )
			{
				var attrs:XMLList = list.attributes();
				for each( var attr:XML in attrs )
				{
					var attr_name:String = attr.name().toString();
					if( attr_name != NameText && attr_name != ParentText )
						settings[attr_name] = attr.valueOf();
				}
				
				return settings;
			}
			
			return null;
		}
		// ============================================================
	}
	
}