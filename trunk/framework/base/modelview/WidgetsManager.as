package base.modelview
{
	import base.controls.*;
	import base.core.NStyle;
	import base.graphics.BitmapGraphix;
	import base.types.*;
	import base.core.NScene;
	//import SndPlayer;
	
	import base.BaseGlobal;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class WidgetsManager extends WidgetContainer
	{
		// ============================================================
		private static const CURSOR_WIDTH:int = 32;
		private static const CURSOR_HEIGHT:int = 32;
		// ============================================================
		private var mFocusedWidget:Control = null;
		private var mMousePressedWidget:Control = null;
		private var mMouseOverWidget:Widget = null;
		private var mCurrentTooltip:NBaseTooltip = null;
		
		private var mGlobalMousePos:NPoint = new NPoint();
		private var mLocalMousePos:NPoint = new NPoint();
		private var mTooltipPos:NPoint = new NPoint();
		
		private var mIsLeftMousePressed:Boolean = false;
		
		private var mStyles:Array = null;
		// ============================================================
		public function WidgetsManager()
		{
		}
		// ============================================================
		public function Init( parent:NScene ):void
		{
			ParentScene = parent;
		}
		// ============================================================
		public function OnMouseClick(x:Number, y:Number):void
		{
			var widget:Widget = FindWidgetFromPosition(x, y);
			if ( widget && widget.Visible && widget.Enabled )
			{
				if ( ParentScene.Pause && !widget.IsControl )	// если на паузе и виджет игровой
					return;
				
				var pos:NPoint = widget.Rect.Position;
				widget.OnMouseClick( x - pos.x, y - pos.y );
			}
		}
		// ============================================================
		public function OnMouseDown(x:Number, y:Number):void
		{
			var widget:Widget = FindWidgetFromPosition(x, y);
			var control:Control;
			if ( widget && widget.Visible && widget.Enabled )
			{
				if ( ParentScene.Pause && !widget.IsControl )	// если на паузе и виджет игровой
					return;
					
				if ( widget.IsControl )
				{
					control = Control(widget);
					if( control.CanCatchClicks )
						MousePressedWidget = control;
					if( control.CanHasFocus )
						Focused = control;
				}
				var pos:NPoint = widget.Rect.Position;
				var sx:Number = x - pos.x;
				var sy:Number = y - pos.y;
				widget.OnMouseDown( sx, sy );
				mIsLeftMousePressed = true;
				widget.CurrentDragCatchPosition.Init( sx, sy );
			}
		}
		// ============================================================
		public function OnMouseUp(x:Number, y:Number):void
		{
			if ( MousePressedWidget )
			{
				var widget:Control = MousePressedWidget;
				MousePressedWidget = null;
				
				if ( ParentScene.Pause && !widget.IsControl )	// если на паузе и виджет игровой
					return;
				
				if ( !widget.Visible || !widget.Enabled )// если виджет невидим или неактивен
					return;
				
				var pos:NPoint = widget.Rect.Position;
				widget.OnMouseUp( x - pos.x, y - pos.y ); // отправляем контролу, на котором сейчас фокус
				mIsLeftMousePressed = false;
			}
		}
		// ============================================================
		public function OnMouseMove( x:Number, y:Number ):void
		{
			mGlobalMousePos.Init( x, y );
			
			var pos:NPoint;
			
			if ( MousePressedWidget && mIsLeftMousePressed )	// если мы тащим виджет
			{
				pos = MousePressedWidget.Rect.Position;
				MousePressedWidget.OnMouseDrag( x - pos.x, y - pos.y );			// если "тягание" виджета обработано, то
				return;															// дальше не выполняем
			}
			
			var widget:Widget = FindWidgetFromPosition(x, y);
			
			MouseOverWidget = widget;	// выставим текущий контрол, над которым курсор мыши
			
			if ( widget && widget.Visible && widget.Enabled )
			{
				if ( ParentScene.Pause && !widget.IsControl )	// если на паузе и виджет игровой
					return;
				
				pos = widget.Rect.Position;
				widget.OnMouseMove( x - pos.x, y - pos.y );// координаты относительно виджета (все виджеты имеют координаты относительно экрана, а не родителя)
				
				if ( widget.HandCursor )	// поддержка курсора-руки в виджетах
					ParentScene.useHandCursor = true;
				else if( ParentScene.useHandCursor )
					ParentScene.useHandCursor = false;
			}
			else
				if( ParentScene.useHandCursor ) ParentScene.useHandCursor = false;
		}
		// ============================================================
		public function get Focused():Control
		{
			return mFocusedWidget;
		}
		// ============================================================
		public function set Focused( control:Control ):void
		{
			if ( mFocusedWidget )
				mFocusedWidget.Focused = false;	// remove old control focus
				
			mFocusedWidget = control;
			
			if( mFocusedWidget )	// if not null
				mFocusedWidget.Focused = true;	// set new control focus
		}
		// ============================================================
		public function get MousePressedWidget():Control
		{
			return mMousePressedWidget;
		}
		// ============================================================
		public function set MousePressedWidget( control:Control ):void
		{
			mMousePressedWidget = control;
		}
		// ============================================================
		public function get MouseOverWidget():Widget
		{
			return mMouseOverWidget;
		}
		// ============================================================
		public function set MouseOverWidget( widget:Widget ):void
		{
			if ( mMouseOverWidget != widget )	// если мышь над новым виджетом
			{
				if ( mMouseOverWidget )			// если предыдущий виджет существует
				{
					mMouseOverWidget.OnMouseOut();	// сообщим ему, что мышь "ушла"
					mMouseOverWidget.IsMouseOver = false;	// и мышь больше не над ним
					ParentScene.useHandCursor = false;		// и отключим курсор руку, если была
				}
				
				mMouseOverWidget = widget;		// запомним новое значение
				
				// if widget exist, visible, enabled and interact with mouse:
				if ( mMouseOverWidget && mMouseOverWidget.Visible &&
						mMouseOverWidget.Enabled && mMouseOverWidget.IsActiveWidget )
				{
					mMouseOverWidget.OnMouseIn();			// сообщим виджету, что мышь над ним
					mMouseOverWidget.IsMouseOver = true;
					
					if ( mMouseOverWidget.NeedTooltip )
					{
						mLocalMousePos.CopySubtraction( mGlobalMousePos, mMouseOverWidget.Rect.Position );
						CurrentTooltip = mMouseOverWidget.GetTooltip( mLocalMousePos );
					}
					else
						CurrentTooltip = null;
				}
				else
					CurrentTooltip = null;
			}
			else
			{
				// некоторым "хитрым" контролам требуется самостоятельно управлять тултипами:
				if ( mMouseOverWidget && mMouseOverWidget.Visible &&
						mMouseOverWidget.Enabled && mMouseOverWidget.IsActiveWidget )
				{
					mLocalMousePos.CopySubtraction( mGlobalMousePos, mMouseOverWidget.Rect.Position );
					if ( mMouseOverWidget.NeedChangeTooltip( mLocalMousePos, CurrentTooltip ) )
					{
						CurrentTooltip = mMouseOverWidget.GetTooltip( mLocalMousePos );
					}
				}
			}
		}
		// ============================================================
		public function get CurrentTooltip():NBaseTooltip
		{
			return mCurrentTooltip;
		}
		// ============================================================
		public function set CurrentTooltip( tooltip:NBaseTooltip ):void
		{
			/*if ( mCurrentTooltip != tooltip )
			{
				if ( mCurrentTooltip )
				{
					mCurrentTooltip.Hide();
				}
			}*/
			
			if( mCurrentTooltip )
				mCurrentTooltip.Hide();	// всегда нужно прятать старый тултип
			
			mCurrentTooltip = tooltip;
			
			if ( mCurrentTooltip )
			{
				// рассчитаем координаты тултипа, НЕ учитывая mMouseOverWidget!
				// лучше переделать так, чтобы тултип не перекрывал виджета, к которому принадлежит
				var widgetRect:NRect = mMouseOverWidget.Rect;
				mTooltipPos.Init( mGlobalMousePos.x, widgetRect.Top - mCurrentTooltip.Height - 5 );
				if ( (mTooltipPos.x + mCurrentTooltip.Width) > BaseGlobal.Width )
					mTooltipPos.x = BaseGlobal.Width - mCurrentTooltip.Width;
				if ( mTooltipPos.y < 0 )
				{
					mTooltipPos.y = widgetRect.Bottom + 5;
				}
				
				mCurrentTooltip.Show( mTooltipPos, mGlobalMousePos );
			}
		}
		// ============================================================
		public function SceneSwitched():void
		{
			if ( mMouseOverWidget )
			{
				mMouseOverWidget.IsMouseOver = false;
				mMouseOverWidget = null;
			}
			
			if ( mMousePressedWidget )
			{
				mMousePressedWidget = null;
			}
			
			mIsLeftMousePressed = false;
		}
		// ============================================================
		public override function OnCommand( widget:Widget, command:String=null, data:*=null ):void
		{
			trace( widget.Name, command, data );
			ParentScene.OnCommand( widget, command, data );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public function Draw( g:BitmapGraphix, diff_ms:int ):void
		{
			InternalDraw( g, diff_ms );
			
			if ( CurrentTooltip )
			{
				if( CurrentTooltip.Visible )
					CurrentTooltip.InternalDraw( g, diff_ms );
			}
		}
		// ============================================================
		/*public function DrawPrecise( g:BitmapGraphix, diff_ms:int ):void
		{
			InternalDrawPrecise( g, diff_ms );
		}*/
		// ============================================================
		
		
		
		
		
		// ============================================================
		//protected var mDefaultButtonImages:* = { normal:"btn_norm", over:"btn_over", pressed:"btn_press" };
		// ============================================================
		public function ParseXMLScene( xml:XML, sceneName:String ):void
		{
			var controls:XMLList = xml.scenes.scene.(@name == sceneName)..control;
			var actions:XMLList = xml.scenes.scene.(@name == sceneName)..action;
			
			var el:XML;

			var count:int = 0;
			for each( el in controls )
			{
				//trace( "Element:", el.toXMLString(), ++count );
				if ( el.@type == "button" )
					CreateButton( el );
				else if ( el.@type == "text" )
					CreateText( el );
				else if ( el.@type == "checkbox" )
					CreateCBox( el );
				else if ( el.@type == "image" )
					CreateImage( el );
				else if ( el.@type == "progress" )
					CreateProgress( el );
				else if ( el.@type == "slider" )
					CreateSlider( el );
				else if ( el.@type == "list" )
					CreateList( el );
			}
			
			for each( el in actions )
			{
				if ( el.@type == "move" )
				{
					MoveControl( el );
				}
			}
			
			
			//trace( sceneXML[0] );
		}
		// ============================================================
		protected function CreateButton( el:XML ):void
		{
			var btn:NButton = NButton.Create( el, this );
			
			if ( btn )
			{
				AddWidget( btn );
			}
			else
				trace( "### CreateButton: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateText( el:XML ):void
		{
			var txt:NText = NText.Create( el, this );
			
			if ( txt )
				AddWidget( txt );
			else
				trace( "### CreateText: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateCBox( el:XML ):void
		{
			var cbox:NCheckbox = NCheckbox.Create( el, this );
			
			if ( cbox )
			{
				AddWidget( cbox );
			}
			else
				trace( "### CreateCBox: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateImage( el:XML ):void
		{
			var img:NImage = NImage.Create( el, this );
			
			if ( img )
			{
				AddWidget( img );
			}
			else
				trace( "### CreateImage: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateProgress( el:XML ):void
		{
			var progress:NProgress = NProgress.Create( el, this );
			
			if ( progress )
			{
				AddWidget( progress );
			}
			else
				trace( "### CreateProgress: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateSlider( el:XML ):void
		{
			var slider:NSlider = NSlider.Create( el, this );
			
			if ( slider )
			{
				AddWidget( slider );
			}
			else
				trace( "### CreateProgress: Parse error:", el.toXMLString() );
		}
		// ============================================================
		protected function CreateList( el:XML ):void
		{
			var list:NList = NList.Create( el, this );
			
			if ( list )
			{
				AddWidget( list );
			}
			else
				trace( "### CreateProgress: Parse error:", el.toXMLString() );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		protected function MoveControl( el:XML ):void
		{
			var id:String = el.@id.toString();
			var widget:Widget = FindWidget( id );
			if ( widget )
			{
				var _x:* = el.@x.toString();		// set
				var _y:* = el.@y.toString();
				var _sx:* = el.@sx.toString();		// shift
				var _sy:* = el.@sy.toString();

				if ( _x && _y )
					widget.MoveTo( Number(_x), Number(_y) );
				else
				{
					if( _x ) widget.MoveTo( Number(_x), widget.Rect.Position.y );
					if ( _y ) widget.MoveTo( widget.Rect.Position.x, Number(_y) );
				}
				
				if ( _sx ) widget.ShiftMove( Number(_sx), 0 )
				if ( _sy ) widget.ShiftMove( 0, Number(_sy) )
			}
			else
			{
				trace( "### widget \"" + id + "\" not found" );
			}
		}
		// ============================================================
		// ============================================================
		/*public function ShowHandCursor( caller:Widget ):void 
		{
			if ( caller )
			{
				if ( caller.Contains( mGlobalMousePos.x, mGlobalMousePos.y ) )
				{
					trace( "show" );
					ParentScene.useHandCursor = true;
				}
			}
		}
		// ============================================================
		public function HideHandCursor( caller:Widget ):void 
		{
			if ( caller )
			{
				if ( caller.Contains( mGlobalMousePos.x, mGlobalMousePos.y ) )
				{
					trace( "hide" );
					ParentScene.useHandCursor = false;
				}
			}
		}*/
		// ============================================================
		private var clonePoint:NPoint = new NPoint();
		public function get GlobalMousePos():NPoint
		{
			clonePoint.CopyFrom( mGlobalMousePos );
			return clonePoint;
		}
		// ============================================================
	}
	
}