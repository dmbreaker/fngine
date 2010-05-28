package base.core
{
	import base.BaseGlobal;
	import base.managers.XmlManager;
	import base.modelview.WidgetsManager;
	import base.utils.NSaver;
	import base.utils.NSettings;
	import base.externals.TweenLite;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.ui.ContextMenu;
	import flash.utils.Timer;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.display.BlendMode;
	import flash.utils.Dictionary;
	import mx.effects.easing.Linear;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public dynamic class NCore extends Sprite
	{
		// ============================================================
		public static var Saver:NSaver = new NSaver();
		public static var Settings:NSettings = new NSettings();
		// ============================================================
		private static const MAX_BLUR:int = 3;
		// ============================================================
		private var mCurObj:NScene = null;
		private var mHidingObj:NScene = null;
		private var mPreviousSceneName:String;
		private var mModalScenes:Array = new Array();
		private var mHidingModalScenes:Array = new Array();
		
		private var mScenes:* = new Object();
		protected var mScenesXML:XML;
		private var mBGImage:BitmapData;
		protected var mMenu:ContextMenu = new ContextMenu();
		
		//protected var mBlurFilter:BlurFilter = new BlurFilter();
		//protected var mEmptyFilters:Array = [];
		protected var mWidth:Number;
		protected var mHeight:Number;
		
		// ============================================================
		private var mIsMouseIn:Boolean = false;
		private var mMouseOutTimer:Timer = new Timer( BaseGlobal.MouseOutTime );
		private var mMouseMoveTimer:Timer = new Timer( BaseGlobal.MouseNoMoveTime );
		// ============================================================
		private static var Styles:Dictionary = new Dictionary();
		// ============================================================
		private static var mCore:NCore = null;
		public function NCore( w:Number, h:Number )
		{
			mWidth = w;
			mHeight = h;
			
			mMenu.hideBuiltInItems();
			this.contextMenu = mMenu;
			
			addEventListener( Event.ADDED_TO_STAGE, OnAdded, false, 0, true );
			
			mCore = this;
		}
		// ============================================================
		public static function get Instance():NCore
		{
			return mCore;
		}
		// ============================================================
		private function OnMouseOutTimer(e:TimerEvent):void
		{
			if ( mCurObj )
				mCurObj.OnSceneEvent( NSceneEvent.evtMouseOutLongTime, null );
		}
		// ============================================================
		private function OnMouseMoveTimer(e:TimerEvent):void
		{
			if ( mCurObj )
				mCurObj.OnSceneEvent( NSceneEvent.evtNoMouseMoveLongTime, null );
		}
		// ============================================================
		private function OnMouseOver(e:MouseEvent):void
		{
			
		}
		// ============================================================
		private function OnMouseOut(e:MouseEvent):void
		{
			IsMouseIn = false;
		}
		// ============================================================
		private function OnMouseMove(e:MouseEvent):void
		{
			if( !IsMouseIn )	// если мышь была за пределами игры
				IsMouseIn = true;
			else	// иначе перезапустим таймер:
			{
				RestartMoveTimer();
			}
		}
		// ============================================================
		/**
		 * Сделаем PUBLIC, чтобы и сама игра могла сбрасывать таймер
		 */
		public function RestartMoveTimer():void
		{
			mMouseMoveTimer.reset();
			mMouseMoveTimer.start();
		}
		// ============================================================
		/**
		 * Сделаем PUBLIC, чтобы и сама игра могла сбрасывать таймер
		 */
		public function RestartOutTimer():void
		{
			mMouseOutTimer.reset();	// в любом случае сбросим таймер
			if( !mIsMouseIn )		// если мышь снаружи, то
				mMouseOutTimer.start();	// запустим таймер
		}
		// ============================================================
		private function get IsMouseIn():Boolean
		{
			return mIsMouseIn;
		}
		// ============================================================
		private function set IsMouseIn(mouse_in:Boolean):void
		{
			mIsMouseIn = mouse_in;
			RestartOutTimer();
		}
		// ============================================================
		private function OnAdded(e:Event):void
		{
			XmlManager.Instance.CompleteDispatcher.addEventListener(XmlManager.XMLS_LOADED, onXmlsLoaded, false, 0, true);
			InitXMLs();
			XmlManager.Instance.LoadXmls();
		}
		// ============================================================
		protected function InitXMLs():void 
		{
			throw Error("XML's are not initialized (override InitXMLs(), or remove super.InitXMLs())");
		}
		// ============================================================
		protected function InitFonts():void
		{
			throw Error("Fonts are not initialized (override InitFonts(), or remove super.InitFonts())");
		}
		// ============================================================
		private function onXmlsLoaded(e:Event):void 
		{
			InitFonts();
			Init();	// continue initialize process
		}
		// ============================================================
		protected function Init():void
		{
			var obj:* = null;
			obj = Saver.Get( "settings" );
			if ( !obj )	Settings.InitDefault();
			else		Settings.CopyObject( obj );
			
			addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true);
			
			mMouseOutTimer.addEventListener( TimerEvent.TIMER, OnMouseOutTimer, false, 0, true );
			mMouseMoveTimer.addEventListener( TimerEvent.TIMER, OnMouseMoveTimer, false, 0, true );
		}
		// ============================================================
		private function OnMouseDown(e:MouseEvent):void
		{
			RestartMoveTimer();
		}
		// ============================================================
		public function AddScene( sceneName:String, sceneClass:Class ):void
		{
			var scene:NScene = new sceneClass( this, sceneName );
			mScenes[sceneName] = scene;
		}
		// ============================================================
		public function Destroy():void
		{
			for ( var param:String in mScenes )
			{
				mScenes[param].Destroy();
				delete mScenes[param];
			}
			
			mHidingObj = null;
			mCurObj = null;
		}
		// ============================================================
		private var mOnTransComplete:Function = null;
		public function SwitchTo( sceneName:String, OnTransitionCompleteDelegate:Function = null ):void
		{
			var scene:NScene = mScenes[sceneName];
			
			mOnTransComplete = OnTransitionCompleteDelegate;
			
			if ( scene )
			{
				IsMouseIn = true;	// чтобы таймер сбросился, если идет вдруг (например при автоматическом переключении)
				StartTransitionTo( scene );
				trace( "Switching to [" + sceneName + "]" );
			}
			else
			{
				trace( "### scene \"" + sceneName + "\" was not found" );
			}
		}
		// ============================================================
		public function SwitchToPrevious():void
		{
			if ( mPreviousSceneName )
				SwitchTo( mPreviousSceneName );
		}
		// ============================================================
		public function GetScene( name:String ):NScene
		{
			if( mScenes[name] )
				return mScenes[name];
			return null;
		}
		// ============================================================
		private function RemoveOldScene():void
		{
			if ( mHidingObj != null )
			{
				//mHidingObj.Destroy();
				removeChild( mHidingObj );
				mHidingObj.visible = false;
				mHidingObj.OnSceneEvent( NSceneEvent.evtTransitionComplete, false );
				mPreviousSceneName = mHidingObj.Name;
				//mHidingObj = null;
			}
			else
				mPreviousSceneName = null;
		}
		// ============================================================
		private function StartTransitionTo( scene:NScene ):void
		{
			mHidingObj = mCurObj;
			mCurObj = scene;
			mCurObj.alpha = 0;
			mCurObj.visible = true;
			//mCurObj.x = Global.WindowWidth;
			mCurObj.ResetKeys();	// на всякий случай
			
			addChild( mCurObj );
			if ( mHidingObj != null )
			{
				mHidingObj.SceneSwitched();
				mHidingObj.OnSceneEvent( NSceneEvent.evtTransitionStarted, false );
				mCurObj.OnSceneEvent( NSceneEvent.evtTransitionStarted, true );
				
				mHidingObj.Freezed = true;	// заморозим предыдущую сцену
				
				//TweenLite.to( mHidingObj, 0.5, { alpha:0, onComplete:TransitionComplete, ease:TweenLite.easeOut } );
				//TweenLite.to( mCurObj, 0.5, { alpha:1, ease:TweenLite.easeOut } );
				TweenLite.killTweensOf( mHidingObj );
				TweenLite.to( mHidingObj, 0.3, { alpha:0, onComplete:TransitionComplete, ease:Linear.easeOut } );
				TweenLite.killTweensOf( mCurObj );
				TweenLite.to( mCurObj, 0.3, { alpha:1, ease:Linear.easeOut } );
				//TweenLite.to( mHidingObj, 0.5, { x:-Global.WindowWidth, onComplete:TransitionComplete, ease:TweenLite.easeOut } );
				//TweenLite.to( mCurObj, 0.5, { x:0, ease:TweenLite.easeOut } );
			}
			else
			{
				mCurObj.OnSceneEvent( NSceneEvent.evtTransitionStarted, true );

				mCurObj.alpha = 1;
				//mCurObj.x = 0;
				TransitionComplete();
			}
		}
		// ============================================================
		private function TransitionComplete():void
		{
			RemoveOldScene();
			mCurObj.Freezed = false;	// разморозим показанную сцену
			mCurObj.OnSceneEvent( NSceneEvent.evtTransitionComplete, true );
			//stage.focus = mCurObj;
			
			var wmgr:WidgetsManager = mCurObj.WidgetsManagerObj;
			wmgr.OnMouseMove( mouseX, mouseY );
			
			if ( mOnTransComplete != null )	// вроде нигде пока не используется
				mOnTransComplete();
		}
		// ============================================================
		// ============================================================
		public function get BGImage():BitmapData
		{
			return mBGImage;
		}
		// ============================================================
		public function set BGImage( img:BitmapData ):void
		{
			mBGImage = img;
			graphics.clear();
			
			if ( mBGImage )
			{
				graphics.beginBitmapFill( mBGImage, null, false, false );
				graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
				graphics.endFill();
			}
		}
		// ============================================================
		public static function SaveSettings():void
		{
			Saver.Save( "settings", Settings );
		}
		// ============================================================
		// ============================================================
		/**
		 * Используется в основном для показа MsgBox'ов
		 */
		public function ShowModal( sceneName:String, callback:Function ):void
		{
			var scene:NModalScene = mScenes[sceneName] as NModalScene;
			
			if ( scene )
			{
				StartTransitionToModal( scene, callback );
				//trace( "Switching to [" + sceneName + "]" );
			}
			else
			{
				trace( "### modal scene \"" + sceneName + "\" was not found" );
			}
		}
		// ============================================================
		private function StartTransitionToModal( scene:NModalScene, callback:Function ):void
		{
			if ( mModalScenes.length > 0 )	// если уже есть модальные окна
			{
				var prevModalScene:NModalScene = mModalScenes[mModalScenes.length - 1];
				prevModalScene.Freezed = true;		// заморозим предыдущее окно
			}
			mModalScenes.push( scene );	// добавим в список модальных окон
			
			scene.alpha = 0;
			scene.visible = true;
			addChild( scene );
			
			if ( mCurObj != null )
			{
				mCurObj.SceneSwitched();
				mCurObj.OnSceneEvent( NSceneEvent.evtModalShowingStarted, null );	// уведомление, что начали показывать модальное окно
				mCurObj.Freezed = true;	// заморозим предыдущую сцену
				//mCurObj.StopQuants();
				//mBlurFilter = null;
				//mBlurFilter = new BlurFilter();
				//SetFilters( mCurObj, [mBlurFilter] );
				scene.OnSceneEvent( NSceneEvent.evtModalShowingStarted, callback );	// уведомление самому модальному окну
				
				TweenLite.to( scene, 0.5, { alpha:1, ease:Linear.easeOut, onComplete:ToModalTransitionComplete } );
				//mBlurFilter.blurX = 0;
				//mBlurFilter.blurY = 0;
				//TweenLite.to( mBlurFilter, 0.5, { blurX:MAX_BLUR, blurY:MAX_BLUR, ease:Linear.easeOut } );
			}
			else
			{
				scene.OnSceneEvent( NSceneEvent.evtModalShowingStarted, callback );	// уведомление самому модальному окну
				scene.alpha = 1;
				ToModalTransitionComplete();
			}
		}
		// ============================================================
		private function ToModalTransitionComplete():void
		{
			if ( mModalScenes.length > 0 )
			{
				var scene:NModalScene = mModalScenes[mModalScenes.length - 1];	// последнее модальное окно
				mCurObj.OnSceneEvent( NSceneEvent.evtModalShowingComplete, null );
				scene.OnSceneEvent( NSceneEvent.evtModalShowingComplete, null );
				scene.Freezed = false;
				//stage.focus = scene;
				
				var wmgr:WidgetsManager = scene.WidgetsManagerObj;
				wmgr.OnMouseMove( mouseX, mouseY );
				trace( "mouse:" + (mouseX), (mouseY) );
			}
		}
		// ============================================================
		private function get CurrentModalScene():NModalScene
		{
			if( mModalScenes.length > 0 )
				return mModalScenes[mModalScenes.length - 1];
			else
				return null;
		}
		// ============================================================
		public function CloseLastModal():void
		{
			if ( mModalScenes.length > 0 )	// если есть модальные окна
			{
				var scene:NModalScene = mModalScenes.pop();
				mHidingModalScenes.push( scene );
				scene.OnSceneEvent( NSceneEvent.evtModalHiding, null );
				scene.Freezed = true;
				//if ( mModalScenes.length == 0 )
					//TweenLite.to( mBlurFilter, 0.25, { blurX:0, blurY:0, ease:Linear.easeOut } );
				TweenLite.to( scene, 0.25, { alpha:0, ease:Linear.easeOut, onComplete:OneModalCloseComplete } );
			}
		}
		// ============================================================
		public function CloseAllModals():void
		{
			var wasTweenWithComplete:Boolean = false;
			if ( mModalScenes.length > 0 )	// если модальные окна вообще существуют
			{
				while ( mModalScenes.length > 0 )	// до тех пор пока есть модальные окна
				{
					var scene:NModalScene = mModalScenes.pop();	// удаляем окна с конца
					mHidingModalScenes.push( scene );
					scene.OnSceneEvent( NSceneEvent.evtModalHiding, null );
					if ( !wasTweenWithComplete )	// если не вызывали твин с функцией по окончании
					{
						wasTweenWithComplete = true;
						TweenLite.to( scene, 0.25, { alpha:0, ease:Linear.easeOut, onComplete:OneModalCloseComplete } );
					}
					else
						TweenLite.to( scene, 0.25, { alpha:0, ease:Linear.easeOut } );
				}
			}
			
			//if ( mModalScenes.length == 0 )
				//TweenLite.to( mBlurFilter, 0.25, { blurX:0, blurY:0, ease:Linear.easeOut } );
		}
		// ============================================================
		private function OneModalCloseComplete():void
		{
			if ( mModalScenes.length > 0 )	// если есть еще модальные окна
			{
				var scene:NModalScene = mModalScenes[mModalScenes.length - 1];	// не уверен насчет этой строки
				scene.OnSceneEvent( NSceneEvent.evtModalShowingComplete, null );// показываем предыдущий мессаджбокс
				scene.Freezed = false;
				//stage.focus = scene;
				
				var wmgr:WidgetsManager = scene.WidgetsManagerObj;
				wmgr.OnMouseMove( mouseX, mouseY );
			}
			else			// если модальных окон больше нет
			{
				//mCurObj.StartQuants();
				mCurObj.Freezed = false;
				//SetFilters( mCurObj, null );
				stage.focus = mCurObj;
				mCurObj.OnSceneEvent( NSceneEvent.evtModalHided, null );
				
				wmgr = mCurObj.WidgetsManagerObj;
				wmgr.OnMouseMove( mouseX, mouseY );
			}
			
			for each (var s:NModalScene in mHidingModalScenes)
			{
				s.Freezed = true;
				s.visible = false;
				removeChild( s );
				s.OnSceneEvent( NSceneEvent.evtModalHided, null );
			}
			mHidingModalScenes.length = 0;
		}
		// ============================================================
		public function get PreviousSceneName():String
		{
			return mPreviousSceneName;
		}
		// ============================================================
		public function get CurrentScene():NScene
		{
			var modalScene:NScene = CurrentModalScene;
			if ( modalScene != null )
				return modalScene;
			else
				return mCurObj;
		}
		// ============================================================
		public function GetScenesXML():XML
		{
			return mScenesXML;
		}
		// ============================================================
		protected function SetScenesXML( xml:XML ):void
		{
			mScenesXML = xml;
			ParseStyles( xml );
		}
		// ============================================================
		public static function GetStyle( name:String ):NStyle
		{
			return Styles[name];
		}
		// ============================================================
		private function ParseStyles( xml:XML ):void
		{
			Styles = null;
			Styles = new Dictionary();
			
			var styles:Dictionary = new Dictionary();
			var stylesList:XMLList = xml.styles..style;
			
			for each( var styleXML:XML in stylesList )
			{
				var style:NStyle = NStyle.Parse( styleXML );
				if ( style )
					Styles[style.Name] = style;
			}
		}
		// ============================================================
		public function get MouseOverSampleName():String
		{
			return "mouse_in";
		}
		// ============================================================
		public function get MouseClickSampleName():String
		{
			return "mouse_click";
		}
		// ============================================================
		public function get WindowWidth():int
		{
			return 640;
		}
		// ============================================================
		public function get WindowHeight():int
		{
			return 480;
		}
		// ============================================================
		public function get DebugEnabled():Boolean
		{
			return false;
		}
		// ============================================================
		public function get IsProfilerEnabled():Boolean
		{
			// TODO: в релизе сделать FALSE
			return false;
		}
		// ============================================================
		public function get IsFGLVersion():Boolean
		{
			// TODO: в релизе сделать FALSE
			return false;
		}
		// ============================================================
		/*private function SetFilters( sprite:Sprite, filters:Array ):void
		{
			if ( filters == null )
			{
				sprite.filters = mEmptyFilters;
			}
			else
			{
				sprite.filters = null;
				sprite.filters = filters;
			}
		}*/
		// ============================================================
	}
	
}