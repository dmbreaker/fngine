﻿package base.modelview
{
	import base.core.NScene;
	import base.graphics.BitmapGraphix;
	import base.types.NRect;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class WidgetContainer extends ItemsContainer
	{
		// ============================================================
		protected var Parent:WidgetContainer = null;
		//protected var ParentScene:NScene = null;
		public var ParentScene:NScene = null;
		
		public var Rect:NRect = new NRect();	// must be here, because Widget and WindgetsManager both use it
		// ============================================================
		public function WidgetContainer()
		{
			
		}
		// ============================================================
		public function AddWidget( widget:IWidget ):void
		{
			AddItem( widget );
			widget.InitParent( this, ParentScene );	// нужно, чтобы в OnAdded можно было не вызывать super.OnAdded
			widget.OnAdded( this );
		}
		// ============================================================
		public function RemoveWidget( widget:IWidget ):void
		{
			widget.OnRemoving();
			Widget(widget).RemoveAll();
			RemoveItem( widget );
		}
		// ============================================================
		public function BringToFront( widget:IWidget ):void
		{
			RemoveItem( widget );
			AddItem( widget );
		}
		// ============================================================
		internal function InternalQuant( diff_ms:int ):void
		{
			if ( HasItems )
			{
				ForEach( function ( obj:* ):void
				{
					Widget(obj).InternalQuant( diff_ms );
				} );
			}
		}
		// ============================================================
		internal function InternalPrecisionQuant( diff_ms:int ):void
		{
			if ( HasItems )
			{
				ForEach( function ( obj:* ):void
				{
					Widget(obj).InternalPrecisionQuant( diff_ms );
				} );
			}
		}
		// ============================================================
		internal function InternalDraw( g:BitmapGraphix, diff_ms:int ):void
		{
			var w:Widget;
			
			if ( HasItems )
			{
				ForEach( function ( obj:* ):void
				{
					w = Widget(obj);
					
					if( w.Visible )
						w.InternalDraw( g, diff_ms );
				} );
			}
		}
		// ============================================================
		public function RemoveAll():void
		{
			ForEach( function ( obj:* ):void
			{
				var widget:Widget = Widget(obj);
				RemoveWidget( widget );
			} );
		}
		// ============================================================
		// функцию сравнения вынести в место вызова, чтобы можно было использовать функцию для различных целей
		public function FindWidgetFromPosition( x:Number, y:Number ):Widget
		{
			var result:Widget = FindItemCompareReverse( function ( item:* ):Boolean
			{
				var w:Widget = Widget(item);
				if ( w.IsClickable && w.Visible && w.IsActiveWidget )
				{
					if ( w.Contains( x, y ) )
						return true;
					else
						return false;
				}
				else
					return false;
			} ) as Widget;
			
			
			if ( result )
			{
				return result.GetWidgetFromPosition( x, y ) || result;
			}
			else
				return null;
		}
		// ============================================================
		public function FindWidget( id:String ):Widget
		{
			var result:Widget = FindItemCompare( function ( item:* ):Boolean
			{
				var w:Widget = Widget(item);
				if ( w.Name == id )
					return true;
				else
					return false;
			} ) as Widget;
			
			
			return result;
		}
		// ============================================================
		// ============================================================
		public function OnCommand( widget:Widget, command:String=null, data:*=null ):void
		{
			// only for overriding
		}
		// ============================================================
		public function InformAllControlsCreated():void
		{
			ForEach( function ( obj:* ):void
			{
				var widget:Widget = Widget(obj);
				widget.InformAllControlsCreated();
				widget.OnAllControlsCreated();
			} );
		}
		// ============================================================
	}
	
}