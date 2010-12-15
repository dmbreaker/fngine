package base.controls
{
	import base.core.NStyle;
	import base.managers.ResourceManager;
	import base.modelview.Widget;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Control extends Widget implements IEventDispatcher
	{
		// ============================================================
		public static const evtVisibilityChanged:String = "visibilitychanged";
		public static const evtEnabledChanged:String = "enabledchanged";
		public static const evtFocusReceive:String = "focusreceive";
		public static const evtFocusLeave:String = "focusleave";
		// ============================================================
		protected var mEvents:EventDispatcher = new EventDispatcher();
		// ============================================================
		protected var mFocused:Boolean = false;
		protected var mCanHasFocus:Boolean = true;
		protected var mCanCatchClicks:Boolean = true;
		// ============================================================
		public function Control( name:String )
		{
			super( name );
		}
		// ============================================================
		public override function get IsControl():Boolean
		{
			return true;
		}
		// ============================================================
		public override function set Visible( visible:Boolean ):void
		{
			if ( Visible != visible )
			{
				super.Visible = visible;
				DispatchNotification( Control.evtVisibilityChanged );
			}
		}
		// ============================================================
		public override function set Enabled( enabled:Boolean ):void
		{
			if ( Enabled != enabled )
			{
				super.Enabled = enabled;
				DispatchNotification( Control.evtEnabledChanged );
			}
		}
		// ============================================================
		public function get Focused():Boolean
		{
			return mFocused;
		}
		// ============================================================
		public function set Focused( focused:Boolean ):void
		{
			if ( mFocused != focused )
			{
				mFocused = focused;
				if( focused )
					DispatchNotification( Control.evtFocusReceive );
				else
					DispatchNotification( Control.evtFocusLeave );
			}
		}
		// ============================================================
		public function get CanHasFocus():Boolean
		{
			return mCanHasFocus;
		}
		// ============================================================
		public function get CanCatchClicks():Boolean
		{
			return mCanCatchClicks;
		}
		// ============================================================
		protected function DispatchNotification( eventType:String, data:* = null ):void
		{
			var e:ControlEvent = new ControlEvent( eventType, this, data );
			mEvents.dispatchEvent( e );
		}
		// ============================================================
		protected function RedispatchNotification( event:ControlEvent ):void
		{
			var e:ControlEvent = new ControlEvent( event.type, this, event.data );
			mEvents.dispatchEvent( e );
		}
		// ============================================================
		/**
		 * Get Image
		 */
		protected function GM( obj:* ):BitmapData
		{
			if ( obj is String )
			{
				var objID:String = String(obj);
				var index:int = objID.indexOf(",");
				if ( index > 0 )
				{
					var animID:String = objID.substring( 0, index );
					var frame:String = objID.substring( index + 1 );
					return ResourceManager.GetAnimation( animID ).GetFrame( int(frame) );
				}
				else
					return ResourceManager.GetImage( objID );
			}
			else
				return obj;
		}
		// ============================================================
		
		
		
		
		
		
		
		
		
		
		
		// ============================================================
		/* INTERFACE flash.events.IEventDispatcher */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			mEvents.addEventListener( type, listener, useCapture, priority, true );
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return mEvents.dispatchEvent( event );
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return mEvents.hasEventListener( type );
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			mEvents.removeEventListener( type, listener, useCapture );
		}
		
		public function willTrigger(type:String):Boolean
		{
			return mEvents.willTrigger( type );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public static function ParseRect( el:XML ):*
		{
			var rect:* = {};
			var list:XMLList = el.rect;
			
			if ( list )
			{
				var attrs:XMLList = list.attributes();
				for each( var attr:XML in attrs )
				{
					rect[attr.name().toString()] = Number(attr.valueOf());
				}
				
				return rect;
			}
			
			return null;
		}
		// ============================================================
		public static function ParseImages( el:XML ):*
		{
			var images:* = {};
			var list:XMLList = el.images;
			if ( list )
			{
				var attrs:XMLList = list.attributes();
				for each( var attr:XML in attrs )
				{
					images[attr.name().toString()] = attr.valueOf().toString();
				}
				
				return images;
			}
			
			return null;
		}
		// ============================================================
		public static function ParseSettings( el:XML ):*
		{
			var settings:* = { };
			
			var attrs:XMLList = el.attributes();
			for each( var attr:XML in attrs )
			{
				var attr_name:String = attr.name().toString();
				settings[attr_name] = attr.valueOf();
			}
			
			return settings;
		}
		// ============================================================
	}
	
}