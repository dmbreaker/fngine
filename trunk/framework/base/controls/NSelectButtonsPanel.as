package base.controls 
{
	import base.managers.FontsManager;
	import base.modelview.WidgetContainer;
	import flash.display.BitmapData;
	import flash.events.Event;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSelectButtonsPanel extends Control
	{
		// ============================================================
		public static const evtTabChanged:String = "tabchanged";
		// ============================================================
		private var tabImages:* = { };
		private var tabSettings:* = { };
		private var tabWidth:int;
		private var tabHeight:int;
		// ============================================================
		public var mIsHorizontal:Boolean = true;
		
		private var mSelectedIndex:int = -1;
		private var mTabs:Array = [];
		// ============================================================
		public function NSelectButtonsPanel(name:String) 
		{
			super(name);
		}
		// ============================================================
		// tabs: [{id:"idTab1", text:"Today"}, {id:"idTab2", text:"All"}]
		public function Init( font:*, tab_images:*, tabs:Array ):void 
		{
			tabImages = { };
			for each( var btn:NSelectButton in mTabs )
			{
				RemoveWidget( btn );
			}
			mTabs.length = 0;
			
			for ( var img:* in tab_images )
				tabImages[img] = tab_images[img];
				
			var image:BitmapData = RM.GetImage( tabImages.normal );
			tabWidth = image.width;
			tabHeight = image.height;
			
			for each( var t:* in tabs )
			{
				AddTabButton( t.id, t.text, font );
			}
			
			InternalResize();
			//Resize( panel_w, panel_h );
			
			if ( mTabs )
			{
				mTabs[0].Selected = true;
				mSelectedIndex = 0;
			}
		}
		// ============================================================
		private function AddTabButton( id:String, text:String, font:* ):void
		{
			var tab:NSelectButton = new NSelectButton( id, text, tabImages, null, {font:font} );
			tab.Selected = false;
			mTabs.push( tab );
			AddWidget( tab );
			tab.addEventListener( NSelectButton.evtButtonSelect, OnTabClick, false, 0, true );
		}
		// ============================================================
		public function get SelectedTab():NSelectButton
		{
			if ( mSelectedIndex >= 0 )
			{
				return mTabs[mSelectedIndex];
			}
			return null;
		}
		// ============================================================
		private function OnTabClick(e:ControlEvent):void 
		{
			var tab:NSelectButton = NSelectButton(e.sender);
			
			DoTabClick( tab );
		}
		// ============================================================
		private function DoTabClick( tab:NSelectButton ):void 
		{
			var index:int = 0;
			for each (var t:NSelectButton in mTabs)
			{
				if ( tab == t )
				{
					mSelectedIndex = index;
					
					// если нужно - можно добавить событие TabChanged
					DispatchNotification( NSelectButtonsPanel.evtTabChanged, tab );
					//Parent.OnCommand( this, NSelectButtonsPanel.evtTabChanged );
				}
				else
				{
					t.Selected = false;
				}
				
				++index;
			}
		}
		// ============================================================
		override public function Resize(w:int, h:int):void 
		{
			super.Resize(w, h);
		}
		// ============================================================
		override public function InitPosition(x:Number, y:Number):void 
		{
			//super.InitPosition(x, y);
			Rect.Position.Init( x, y );
			
			InternalResize();
		}
		// ============================================================
		private function InternalResize():void 
		{
			var panel_w:int = 0;
			var panel_h:int = 0;
			var t:NSelectButton;
			if ( mIsHorizontal )
			{
				var curX:int = Rect.Position.x;
				for each( t in mTabs )
				{
					t.Rect.Position.x = curX;
					t.Rect.Position.y = Rect.Top;
					t.Rect.Size.Width = tabWidth;
					t.Rect.Size.Height = tabHeight;

					curX += tabWidth;
					panel_w += tabWidth;
				}
			}
			else
			{
				var curY:int = Rect.Position.y;
				for each( t in mTabs )
				{
					t.Rect.Position.x = Rect.Left;
					t.Rect.Position.y = curY;
					t.Rect.Size.Width = tabWidth;
					t.Rect.Size.Height = tabHeight;
					
					curY += tabHeight;
					panel_h += tabHeight;
				}
			}
		}
		// ============================================================
		public function get Tabs():Array
		{
			return mTabs;
		}
		// ============================================================
		override public function OnRemoving():void 
		{
			super.OnRemoving();
			
			RemoveAll();
		}
		// ============================================================
		public function get TabWidth():Number
		{
			return tabWidth;
		}
		// ============================================================
		public function get TabHeight():Number
		{
			return tabHeight;
		}
		// ============================================================
		public function SelectFirstTab():void 
		{
			if ( mTabs.length > 0 )
			{
				if( !NSelectButton(mTabs[0]).Selected )
					DoTabClick( mTabs[0] );
				else
					mSelectedIndex = 0;
			}
		}
		// ============================================================
	}

}