package base.core
{
	import base.BaseGlobal;
	import base.containers.RemovableArray;
	import base.graphics.BitmapGraphix;
	import base.graphics.SpriteGraphix;
	import base.managers.SoundsPlayer;
	import base.modelview.QuantgetsHolder;
	import base.modelview.Widget;
	import base.modelview.WidgetsManager;
	import base.scenes.NDebugScene;
	import base.utils.SimpleProfiler;
	import base.tweening.NTweener;
	import base.effects.NEffectTweener;
	import flash.display.MovieClip;
	
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NScene extends Sprite
	{
		//protected static var mResLoader:ResLoader = new ResLoader();
		// ============================================================
		public static var Width:Number;
		public static var Height:Number;
		// ============================================================
		protected var mCore:NCore;
		// ============================================================
		protected var mBmpGraphix:BitmapGraphix;
		
		protected var mGraphix:BitmapGraphix;
		// ============================================================
		protected var mQuantgets:QuantgetsHolder = new QuantgetsHolder();
		protected var mWidgets:WidgetsManager = new WidgetsManager();
		// ============================================================
		protected var mMousePosition:Point = new Point();
		private var mWasMouseMove:Boolean;
		// ============================================================
		private var mIsFreezed:Boolean = true;
		private var mIsPaused:Boolean = false;
		// ============================================================
		protected var mLayers:Vector.<Sprite> = new Vector.<Sprite>();
		protected var mMainLayerIndex:int = 0;
		protected var mBottommostLayerIndex:int = 0;
		protected var mTopmostLayerIndex:int = 0;
		//protected var mDefaultRenderTargetIndex:int = 0;
		// ============================================================

		public var RealFPS:Number = 0;
		private var FramesCount:Number = 0;
		//public static const MsPerQuant:int = 15;	// milliseconds per quant
		public static const MsPerQuant:int = 20;	// milliseconds per quant
		//public static const MsPerFrame:int = 30;	// milliseconds per frame
		public static const MsPerFrame:int = 30;	// milliseconds per frame
		public static const KeysRepeatTime:int = 200;	// milliseconds per KeyPress
		public var prevQuantsTime:int;
		public var prevPrecisionQuantsTime:int;
		public var prevFramesTime:int;
		public var prevKeysTime:int;
		private var startFPSTime:int;
		public var curTime:int;
		
		private var mNeedDestroy:Boolean = false;
		
		protected const KeysCount:int = 256;
		protected var mKeys:Array = new Array(KeysCount);	// под все клавиши
		
		private var mStartedQuants:Boolean = false;
		
		private var mSceneName:String;
		protected var DefaultOk:String;
		protected var DefaultYes:String;
		protected var DefaultNo:String;
		protected var DefaultNextScene:String;
		
		// ============================================================
		public function NScene( core:NCore, name:String )
		{
			mCore = core;
			mSceneName = name;
			
			curTime = 0;
			if ( stage )
				OnAdded();
			else
				addEventListener( Event.ADDED_TO_STAGE, OnAdded, false, 0, true );
				
			mWidgets.Init( this );
			
			// поддержка курсор-руки:
			useHandCursor = false;// true;
			buttonMode = true;
			mouseChildren = false;
			
			cacheAsBitmap = false;// false;
		}
		// ============================================================
		protected function OnAdded(e:Event = null):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, OnAdded );
			//trace( "NScene OnAdded" );
			
			Width = NCore.Instance.WindowWidth;
			Height = NCore.Instance.WindowHeight;
			mWidgets.Rect.Size.Init( Width, Height );	// all scenes has same size
			
			mBmpGraphix = new BitmapGraphix( Width, Height, true );
			//addChild( mSprGraphix );
			//mGraphix = mSprGraphix;
			mGraphix = mBmpGraphix;
			
			InitializeLayers();
			
			addEventListener( Event.ENTER_FRAME, OnEnterFrame, false, 0, true );
			addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true );
			addEventListener( MouseEvent.CLICK, OnMouseClick, false, 0, true );
			addEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown, false, 0, true );
			addEventListener( MouseEvent.MOUSE_UP, OnMouseUp, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp, false, 0, true );
			
			//mResLoader.addEventListener( ResLoader.RESOURCES_LOADED, OnResourcesLoaded, false, 0, true );
			//mResLoader.addEventListener( ResLoader.RESOURCES_EVENTS_DISPATCHED, OnResourcesEventsDispatched, false, 0, true );
			
			mWasMouseMove = false;

			tabEnabled = false;
			tabChildren = false;
			focusRect = false;
			OnInit();
			ParseXML();	// parsing XML, xml-controls will be on top, therefore user-widgets can be bring to front
			
			mWidgets.InformAllControlsCreated();	// informing all widgets that controls creation complete
			
			//mResLoader.Load();
			
			OnSceneCyclePreStart();
			Start();
		}
		// ============================================================
		/*
		 * Initializes NScene layers (every layer is a Sprite)
		 */
		protected function InitializeLayers():void 
		{
			mLayers.length = 0;
			
			var sprite:Sprite = new Sprite();
			sprite.mouseEnabled = false;
			sprite.cacheAsBitmap = false;// true;
			addChild( sprite );
			mLayers.push( sprite );	// bottom layer
			mBottommostLayerIndex = 0;
			
			sprite = new Sprite();
			sprite.mouseEnabled = false;
			sprite.cacheAsBitmap = false;// true;
			addChild( sprite );
			mLayers.push( sprite );	// center layer (main)
			mMainLayerIndex = 1;
			
			sprite = new Sprite();
			sprite.mouseEnabled = false;
			sprite.cacheAsBitmap = false;// true;
			addChild( sprite );
			mLayers.push( sprite );	// top layer (over)
			mTopmostLayerIndex = 2;
			
			//mDefaultRenderTargetIndex = mMainLayerIndex;
		}
		// ============================================================
		public function GetLayer( index:int ):Sprite
		{
			if ( mLayers.length == 0 )
				return null;
			
			if ( index <= 0 )
				return mLayers[0];
				
			if ( index >= mLayers.length )
				return mLayers[mLayers.length - 1]
				
			return mLayers[index];
		}
		// ============================================================
		protected function OnInit():void	// for overriding
		{
			
		}
		// ============================================================
		//private function OnResourcesLoaded(e:Event):void
		//{
			//mResLoader.removeEventListener( ResLoader.RESOURCES_LOADED, OnResourcesLoaded );
			//trace( "Resources loaded" );
		//}
		// ============================================================
		//private function OnResourcesEventsDispatched(e:Event):void
		//{
			//mResLoader.removeEventListener( ResLoader.RESOURCES_EVENTS_DISPATCHED, OnResourcesEventsDispatched );
			//OnSceneCyclePreStart();
			//Start();
		//}
		// ============================================================
		protected function OnSceneCyclePreStart():void		// for overriding
		{
			
		}
		// ============================================================
		protected function Start():void
		{
			ResetKeys();
			
			FramesCount = 0;
			prevKeysTime = startFPSTime = prevQuantsTime = prevPrecisionQuantsTime = prevFramesTime = curTime = getTimer();

			StartQuants();
			//trace( "STARTED QUANTS" );
		}
		// ============================================================
		public function Destroy():void		// здесь удалять, все, что связано со Stage
		{
			removeEventListener( Event.ENTER_FRAME, OnEnterFrame );
			removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			removeEventListener( MouseEvent.CLICK, OnMouseClick );
			removeEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
			removeEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
			removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			removeEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			mNeedDestroy = true;
			StopQuants();
		}
		// ============================================================
		protected function OnDestroy():void		// здесь удалять все, что нужно удалять вне кванта
		{
			mNeedDestroy = false;
			
			mWidgets.RemoveAll();
			mQuantgets.RemoveAll();
			
			if ( mGraphix != null )
			{
				mGraphix.Destroy();
				mGraphix = null;
			}
		}
		// ============================================================
		private function onKeyUp(e:KeyboardEvent):void
		{
			if ( !mIsFreezed )
			{
				mKeys[e.keyCode] = false;
				OnKeyUp( e.keyCode );
			}
		}
		// ============================================================
		private function onKeyDown(e:KeyboardEvent):void
		{
			if ( !mIsFreezed )
			{
				if ( !Boolean(mKeys[e.keyCode]) )
				{
					ResetKeysTime();	// чтобы не было попаданий "вблизи" конца промежутка повторения нажатия клавиши
					
					OnKeyDown( e.keyCode );
					OnKeyPress( e.keyCode );
					mKeys[e.keyCode] = true;
				}
			}
		}
		// ============================================================
		private function OnMouseClick(e:MouseEvent):void
		{
			if ( !mIsFreezed )
			{
				mWidgets.OnMouseClick( e.stageX, e.stageY );
			}
		}
		// ============================================================
		private function OnMouseDown(e:MouseEvent):void
		{
			if ( !mIsFreezed )
			{
				mWidgets.OnMouseDown( e.stageX, e.stageY );
			}
		}
		// ============================================================
		private function OnMouseUp(e:MouseEvent):void
		{
			if ( !mIsFreezed )
			{
				mWidgets.OnMouseUp( e.stageX, e.stageY );
			}
		}
		// ============================================================
		protected function OnMouseMove( x:Number, y:Number ):void
		{
			if ( !mIsFreezed )
				mWidgets.OnMouseMove( x, y );
		}
		// ============================================================
		protected function OnKeyDown( keyCode:int ):void
		{
			
		}
		// ============================================================
		protected function OnKeyUp( keyCode:int ):void
		{
			
		}
		// ============================================================
		protected function OnKeyPress( keyCode:int ):void
		{
			
		}
		// ============================================================
		public function ResetKeys():void
		{
			for (var i:int = 0; i < KeysCount; i++)
				mKeys[i] = false;
		}
		// ============================================================
		public function StopQuants():void
		{
			mStartedQuants = false;
			//trace( "quants stopped" );
		}
		// ============================================================
		public function StartQuants():void
		{
			mStartedQuants = true;
			//trace( "quants STARTED" );
		}
		// ============================================================
		private function OnEnterFrame(e:Event):void
		{
			var t:int = curTime = getTimer();
			if ( !mStartedQuants )
			{
				//trace( "OnEnterFrame: quants not started" );
				if ( mNeedDestroy )
					OnDestroy();
				prevQuantsTime = t;
				prevPrecisionQuantsTime = t;
				prevFramesTime = t;
				prevKeysTime = t;
				return;
			}

			var qdiff:int = t - prevQuantsTime;	// для квантов
			var precision_qdiff:int = t - prevPrecisionQuantsTime;	// для квантов
			var fdiff:int = t - prevFramesTime;	// для кадров (frames)
			var fps_diff:int = t - startFPSTime;	// для кадров (frames)
			var keys_diff:int = t - prevKeysTime;	// для клавиш
			
			if ( !mIsPaused && !mIsFreezed )	// не на паузе и не заморожен
			{
				var accumulator:int = qdiff;
				if ( accumulator > (5 * MsPerQuant) )
					accumulator = 5 * MsPerQuant;
					
				if ( precision_qdiff > (5 * MsPerQuant) )
					precision_qdiff = 5 * MsPerQuant;
				if ( precision_qdiff >= MsPerQuant )
				{
					mQuantgets.PrecisionQuant( precision_qdiff );
					prevPrecisionQuantsTime = t;
				}
					
				while ( accumulator >= MsPerQuant )	// если время кадра пришло
				{
				SimpleProfiler.Start( "Logic" );
					mQuantgets.Quant( MsPerQuant );
					NTweener.Quant( MsPerQuant );
					NEffectTweener.Quant( MsPerQuant );
					SoundsPlayer.Update( MsPerQuant );
					Quant( MsPerQuant );
				SimpleProfiler.Stop( "Logic" );
					if ( mNeedDestroy )
						OnDestroy();
					accumulator -= MsPerQuant;
				}
				prevQuantsTime = t - accumulator;
			}
			else
			{
				prevQuantsTime = t;	// чтобы не накапливалось время во время паузы и заморозки
				prevPrecisionQuantsTime = t;
			}
			
			if ( fdiff >= MsPerFrame && mStartedQuants && visible )
			{
			SimpleProfiler.Start( "DrawClear" );
				mGraphix.Clear();
			SimpleProfiler.Stop( "DrawClear" );
				
			SimpleProfiler.Start( "Draw" );
				mGraphix.lock();			// лочим главный битмап
				BeforeDraw( mGraphix, fdiff );
				mWidgets.Draw( mGraphix, fdiff );
				AfterDraw( mGraphix, fdiff );
				mGraphix.unlock();
			SimpleProfiler.Stop( "Draw" );
			
				//mGraphix.BlitOn( graphics, 0, 0 );
				// попытка добавить слои, чтобы отрисовка стала быстрее
				mGraphix.BlitOn( mLayers[mMainLayerIndex].graphics, 0, 0 );
				
				prevFramesTime = t;
				FramesCount++;
			}
			
			if ( !mIsFreezed )	// для заморозки сцены
			{
				if ( keys_diff >= KeysRepeatTime )
				{
					for (var i:int = 0; i < KeysCount; i++)
					{
						if ( Boolean(mKeys[i]) )
						{
							OnKeyPress( i );
						}
					}
					prevKeysTime = t;
				}
				
				if ( mWasMouseMove && !mIsFreezed )
				{
					mWasMouseMove = false;
				//SimpleProfiler.Start( "MouseMove" );
					OnMouseMove( mMousePosition.x, mMousePosition.y );
				//SimpleProfiler.Stop( "MouseMove" );
				}
			}

			//if ( NCore.Instance.DebugEnabled )
			{
				if ( visible )
				{
					if( fps_diff > 1000 )
					{
						RealFPS = 1000 * FramesCount / fps_diff;
						if ( fps_diff > 10000 )
						{
							trace( "FPS: " + RealFPS );
							trace( "PROFILING:\n" + SimpleProfiler.GetFullStatistics() );
							SimpleProfiler.ResetAll();
							FramesCount = 0;
							startFPSTime = curTime;
						}
					}
				}
			}
		}
		// ============================================================
		protected function ResetKeysTime():void
		{
			prevKeysTime = curTime;
		}
		// ============================================================
		protected function Quant( diff_ms:int ):void
		{
		}
		// ============================================================
		protected function BeforeDraw( g:BitmapGraphix, diff_ms:int ):void
		{
		}
		// ============================================================
		protected function AfterDraw( g:BitmapGraphix, diff_ms:int ):void
		{
		}
		// ============================================================
		/**
		 * Данный метод нужен для того, чтобы события о движении мыши приходили только в момент кванта
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			if ( !mIsFreezed )
			{
				mWasMouseMove = true;
				mMousePosition.x = e.stageX;
				mMousePosition.y = e.stageY;
			}
		}
		// ============================================================
		public function OnCommand( widget:Widget, command:String=null, data:*=null ):void
		{
			
		}
		// ============================================================
		public function set Pause( pause:Boolean ):void
		{
			mIsPaused = pause;
		}
		// ============================================================
		public function get Pause():Boolean
		{
			return mIsPaused;
		}
		// ============================================================
		/**
		 * Замораживает все кванты, обработку событий мыши и клавиатуры
		 * (необходимо для NCore при переходах между сценами и создании всех сцен при загрузке)
		 */
		public function set Freezed( pause:Boolean ):void
		{
			mIsFreezed = pause;
			//trace( "Freeze: " + pause + " - " + getQualifiedClassName( this ) );
		}
		// ============================================================
		public function get Freezed():Boolean
		{
			return mIsFreezed;
		}
		// ============================================================
		protected function ParseXML():void
		{
			CONFIG::debug { trace( "XML: Parsing scene '" + mSceneName + "'" ); }
			
			var xml:XML = mCore.GetScenesXML();
			var scene:XMLList = xml.scenes.scene.(@name == mSceneName);
			if ( scene.toString().length == 0 )
			{
				trace( "" );
				trace( "SCENE '" + mSceneName + "' not found in XML" );
				trace( "" );
			}
			else
			{
				//trace( scene );
				DefaultOk = scene[0].@ok.toString();
				DefaultYes = scene[0].@yes.toString();
				DefaultNo = scene[0].@no.toString();
				DefaultNextScene = scene[0].@next_scene.toString();
				
				mWidgets.ParseXMLScene( xml, mSceneName );
				OnSceneEvent( NSceneEvent.evtControlsLoaded, null );	// чтобы известить об окончании инициализации контролов
			}
		}
		// ============================================================
		public function get Name():String
		{
			return mSceneName;
		}
		// ============================================================
		/**
		 * Нужен для того, чтобы отключить "подсвеченные контролы" и нажатые клавиши
		 */
		public function SceneSwitched():void
		{
			mWidgets.SceneSwitched();
			ResetKeys();
		}
		// ============================================================
		public function OnSceneEvent( event:int, data:* ):void
		{
		}
		// ============================================================
		public function OnMenuShown():void
		{
			
		}
		// ============================================================
		public function OnMenuItemSelected():void
		{
			
		}
		// ============================================================
		public function IsKeyPressed( key:int ):Boolean
		{
			return mKeys[key];
		}
		// ============================================================
		public function get WidgetsManagerObj():WidgetsManager
		{
			return mWidgets;
		}
		// ============================================================
		public function ShowDebugScreen():void 
		{
			if ( BaseGlobal.DebugEnabled )
			{
				trace( "### DEBUG ###" );
				var debugScene:NDebugScene = NDebugScene( mCore.GetScene( "debug_screen" ) );
				if ( debugScene )
				{
					mCore.SwitchTo( "debug_screen" );
				}
			}
		}
		// ============================================================
		public function GetWidget( name:String ):Widget
		{
			return mWidgets.FindWidget( name );
		}
		// ============================================================
	}
	
}