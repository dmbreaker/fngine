package base.modelview
{
	import base.controls.NBaseTooltip;
	import base.controls.NSimpleTooltip;
	import base.core.NScene;
	import base.graphics.BitmapGraphix;
	import base.types.*;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Widget extends WidgetContainer implements IWidget
	{
		// ============================================================
		protected var mName:String;
		protected var mTooltipText:String;
		// ============================================================
		public var Rect:NRect = new NRect();
		//public var Position:NPoint = new NPoint();
		//public var Size:NSize = new NSize();
		protected var mHandCursor:Boolean = false;
		
		public var IsClickable:Boolean = true;	// can handle clicks?
		public var IsMouseOver:Boolean = false;
		public var IsActiveWidget:Boolean = true;	// interactive widget or not (non-interactive doesn't interact with mouse: non-clickable, has no tolltip, etc)
		// ============================================================
		protected var mVisible:Boolean = true;
		protected var mEnabled:Boolean = true;
		// ============================================================
		private var mDragCatchPos:NPoint = new NPoint();
		// ============================================================
		public function Widget( name:String )
		{
			mName = name;
		}
		// ============================================================
		public function get Name():String
		{
			return mName;
		}
		// ============================================================
		/*
		 * Is this widget UI-Control (interactive) or it's just a widget
		 */
		public function get IsControl():Boolean
		{
			return false;
		}
		// ============================================================
		/* INTERFACE base.view.IWidget */
		// ============================================================
		public function InitParent( parent:WidgetContainer, scene:NScene ):void 
		{
			Parent = parent;
			ParentScene = scene;
		}
		// ============================================================
		public function OnAdded( parent:WidgetContainer ):void
		{
			Parent = parent;
		}
		// ============================================================
		public function OnRemoving():void
		{
			
		}
		// ============================================================
		public function OnAllControlsCreated():void
		{
			// for overriding
		}
		// ============================================================
		internal final override function InternalDraw( g:BitmapGraphix, diff_ms:int):void
		{
			g.SetOffset( Rect.Position.x, Rect.Position.y );
			Draw( g, diff_ms );
			g.ResetOffset();
			
			super.InternalDraw( g, diff_ms );	// drawing childs here
			
			//g.DrawRect( Rect.RectangleLinked, 0xffff0000 );	// TODO: для отладки только!
		}
		// ============================================================
		public function Draw(g:BitmapGraphix, diff_ms:int):void
		{
			
		}
		// ============================================================
		public function get Visible():Boolean
		{
			return mVisible;
		}
		// ============================================================
		public function set Visible( visible:Boolean ):void
		{
			if ( mVisible != visible )
			{
				mVisible = visible;
			}
		}
		// ============================================================
		public function get Enabled():Boolean
		{
			return mEnabled;
		}
		// ============================================================
		public function set Enabled( enabled:Boolean ):void
		{
			if ( mEnabled != enabled )
				mEnabled = enabled;
		}
		// ============================================================
		/**
		 * If you'll override this method - you can catch widget Resize
		 * @param	w
		 * @param	h
		 */
		public function Resize( w:int, h:int ):void
		{
			var size:NSize = Rect.Size;
			size.Width = w;
			size.Height = h;
		}
		// ============================================================
		public function get Width():Number
		{
			return Rect.Width;
		}
		// ============================================================
		public function get Height():Number
		{
			return Rect.Height;
		}
		// ============================================================
		/*
		 * Initializes position of widget and all of its childs.
		 */
		public function InitPosition( x:Number, y:Number ):void
		{
			var sx:Number = x - Rect.Position.x;
			var sy:Number = y - Rect.Position.y;
			
			Rect.Position.Init( x, y );

			ForEach(function(obj:*):void
			{
				var w:Widget = Widget(obj);
				w.ShiftMove( sx, sy );
			});
		}
		// ============================================================
		// ============================================================

		// ============================================================
		/*
		 * Does widget contains point?
		 */
		public function Contains( x:Number, y:Number ):Boolean
		{
			var wx:Number = Rect.Position.x;
			var wy:Number = Rect.Position.y;
			
			if ( x >= wx && x < (wx + Rect.Width) )
			{
				if ( y >= wy && y < (wy + Rect.Height) )
				{
					return true;
				}
			}
			return false;
		}
		// ============================================================
		/*
		 * Does widget contains point relative to widgets left-top corner
		 */
		public function ContainsRelative( x:Number, y:Number ):Boolean
		{
			if ( x >= 0 && x < Rect.Width )
			{
				if ( y >= 0 && y < Rect.Height )
				{
					return true;
				}
			}
			return false;
		}
		// ============================================================
		public function GetWidgetFromPosition( x:Number, y:Number ):Widget
		{
			//x -= Position.x;	// координаты всех виджетов будут только экранные
			//y -= Position.y;
		
			//var widget:Widget = FindWidgetFromPosition( x, y );
			//return ( widget ) ? widget : this;
			
			if( IsActiveWidget )
				return FindWidgetFromPosition( x, y ) || this;
			else
				return null;
		}
		// ============================================================
		/* INTERFACE base.modelview.IWidget */
		public function OnMouseClick(x:Number, y:Number):void
		{
			
		}
		// ============================================================
		public function OnMouseMove(x:Number, y:Number):void
		{
			
		}
		// ============================================================
		public function OnMouseDown(x:Number, y:Number):void
		{
			
		}
		// ============================================================
		public function OnMouseUp(x:Number, y:Number):void
		{
			
		}
		// ============================================================
		public function OnMouseIn():void
		{
			
		}
		// ============================================================
		public function OnMouseOut():void
		{
			
		}
		// ============================================================
		public function OnMouseDrag(x:Number, y:Number):Boolean
		{
			return false;
		}
		// ============================================================
		public function MoveTo( x:Number, y:Number ):void
		{
			InitPosition( x, y );
		}
		// ============================================================
		public function ShiftMove( sx:Number, sy:Number ):void
		{
			InitPosition( Rect.Position.x+sx, Rect.Position.y+sy );
		}
		// ============================================================
		public function get CurrentDragCatchPosition():NPoint
		{
			return mDragCatchPos;
		}
		// ============================================================
		/*
		 * If widget has tooltip text - it needs tooltip
		 */
		public function get NeedTooltip():Boolean
		{
			if ( mTooltipText )	// если есть текст
			{
				return true;
			}
			else
				return false;
		}
		// ============================================================
		public function NeedChangeTooltip( mouse_pos:NPoint, currentTooltip:NBaseTooltip ):Boolean
		{
			return false;
		}
		// ============================================================
		public function get TooltipText():String
		{
			return mTooltipText;
		}
		// ============================================================
		public function set TooltipText( text:String ):void
		{
			mTooltipText = text;
		}
		// ============================================================
		public function GetTooltip( mouse_pos:NPoint ):NBaseTooltip
		{
			if ( NeedTooltip )
			{
				var t:NSimpleTooltip = NSimpleTooltip.Instance;
				t.InitData( TooltipText );
				return t;
			}
			return null;
		}
		// ============================================================
		public function get HandCursor():Boolean
		{
			return mHandCursor;
		}
		// ============================================================
		public function set HandCursor( value:Boolean ):void
		{
			mHandCursor = value;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		
		
		
		
		
		
		
		// ============================================================
	}
	
}