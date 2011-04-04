package base.utils.xmltweener 
{
	import base.containers.AvDictionary;
	import base.graphics.BitmapGraphix;
	import base.managers.XmlManager;
	import base.tweening.NTweener;
	import base.types.NPoint;
	import base.utils.FastMath;
	import flash.display.BitmapData;
	
	import mx.effects.easing.*;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class XmlEffect
	{
		// ============================================================
		// ============================================================
		protected var mXml:XML = null;
		protected var mListener:IXmlEffectListener = null;
		protected var mName:String = "";
		protected var mIsInited:Boolean = false;
		protected var mIsStarted:Boolean = false;
		protected var mIsVisible:Boolean = false;
		protected var mIsCompleted:Boolean = false;
		
		protected var mImage:BitmapData = null;
		//protected var mPos:NPoint = new NPoint();
		//protected var mImageShiftPos:NPoint = new NPoint();
		
		public var X:Number, Y:Number, Alpha:Number, ScaleX:Number, ScaleY:Number, Angle:Number,
					Param1:Number, Param2:Number, Param3:Number, Param4:Number;	// параметры

		public var mXmlActionMap:AvDictionary = new AvDictionary();
		public var mCommandsMap:AvDictionary = new AvDictionary();
		public var mBlocksMap:AvDictionary = new AvDictionary();
		// ============================================================
		// ============================================================
		public function XmlEffect() 
		{
			mIsInited = false;

			ScaleX = 1;
			ScaleY = 1;
			Alpha = 255;
			X = 0;
			Y = 0;
			Angle = 0;
			Param1 = 0;
			Param2 = 0;
			Param3 = 0;
			Param4 = 0;

			mListener = null;
		}
		// ============================================================
		// ============================================================
		protected function Parse():void
		{
			var id:XMLList;
			
			mXmlActionMap.Clear();
			mCommandsMap.Clear();
			mBlocksMap.Clear();

			var animation:XMLList = XMLList(mXml);	// root
			var commands:XMLList = animation.commands..action;	// команды

			if( commands )
			{
				for each( var action:XML in commands )
				{
					id = action.@id;
					if( id )
					{
						var action_xml:XmlEffectAction = new XmlEffectAction();
						action_xml.Parse( XML(action) );
						mXmlActionMap.Add(action_xml.ID, action_xml);
					}
				}
			}

			var program:XMLList = animation.program..block;	// сама программа (вызывает команды)
			if( program )
			{
				for each( var block:XML in program )
				{
					id = block.@id;
					if( id )
					{
						var block_obj:EffectBlock = new EffectBlock();
						block_obj.Parse( XML(block) );
						mBlocksMap.Add(block_obj.ID, block_obj);
					}
				}
			}
		}
		// ============================================================
		protected function Init():void
		{
			mIsInited = true;
			
			for each( var block:EffectBlock in mBlocksMap.GetData() )
			{
				block.Init(this);
			}
		}
		// ============================================================
		public function Update( ms:int ):void
		{
		}
		// ============================================================
		public function Draw( g:BitmapGraphix, x:Number, y:Number ):void
		{
			if( mIsVisible && mImage )
			{
				g.DrawBitmapDataScaled( mImage, x + X, y + Y, Alpha * FastMath.AlphaNormalize, ScaleX, ScaleY );
			}
		}
		// ============================================================
		//public function onStart(/*tween::TweenerParam& param*/):void
		//{
		//	
		//}
		// ============================================================
        public function onStep(/*tween::TweenerParam& param*/):void
		{
			
		}
		// ============================================================
        public function onComplete(obj:*):void
		{
			// код переехал в EffectCommand (OnTweenComplete)
			
			/*var cmd:EffectCommand = mCommandsMap[param.ID];
			if( cmd.OnCompleteStop == "stop" )
			{
				Stop();
				if( mListener ) mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );	// передавать бы еще название текущего Block...
				return;
			}
			else if( cmd.OnCompleteStop == "stop_no_hide" )
			{
				if( mListener ) mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );	// передавать бы еще название текущего Block...
				return;
			}
			else
				if( mListener ) mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );

			cmd.OnComplete();*/
			// how about STOP?
		}
		// ============================================================
		public function Start():void
		{
			Init();	// чтобы значения "перечитывались"
			//  @ BaseEffect::Start();
			mIsStarted = true;
			mIsVisible = true;
			mIsCompleted = false;
			//  @ mTweener.removeAllTweens();	// на всякий случай
			NTweener.killTweensOf(this); // на всякий случай

			StartBlock( "start" );
		}
		// ============================================================
		public function Stop():void
		{
			//  @ BaseEffect::Stop();
			mIsVisible = false;
			mIsStarted = false;
			mIsCompleted = true;
		}
		// ============================================================
		public function get IsStarted():Boolean
		{
			return mIsStarted;
		}
		// ============================================================
		public function Reinit():void
		{
			Init();	// чтобы значения "перечитывались"
			//  @ BaseEffect::Start();
			mIsStarted = true;
			mIsVisible = true;
			//  @ mTweener.removeAllTweens();	// на всякий случай
			NTweener.killTweensOf(this); // на всякий случай
		}
		// ============================================================
		public function SetImageByName( name:String ):void
		{
			if( name.length > 0 )
			{
				SetImage( RM.GetImage( name ) );
			}
		}
		// ============================================================
		public function SetImage( img:BitmapData ):void
		{
			mImage = img;
		}
		// ============================================================
		public function Load( name:String ):void
		{
			mName = name;
			mIsInited = false;

			mXmlActionMap.Clear();
			mCommandsMap.Clear();
			mBlocksMap.Clear();

			mXml = XmlManager.Instance.GetXML(name);
			Parse();
		}
		// ============================================================
		public function StartBlock( name:String ):void
		{
			var block:EffectBlock = mBlocksMap.GetValue(name);
			if( block )
			{
				block.Execute();
			}
			else
			{
				trace("XmlEffect: Block '" + name + "' was not found" );
			}
		}
		// ============================================================
		public function GetEffectAction( name:String ):XmlEffectAction
		{
			var result:XmlEffectAction = mXmlActionMap.GetValue( name );
			if( result )
				return result;
			else
			{
				trace("XmlEffect: EffectAction '" + name + "' was not found");
				return null;
			}
		}
		// ============================================================
		public function AddListener( listener:IXmlEffectListener ):void
		{
			mListener = listener;
		}
		// ============================================================
		public function StartTweener( time:int, tweenObj:*, xmlAction:XmlEffectAction, command:EffectCommand ):void
		{
			tweenObj.onComplete = command.OnTweenComplete;
			tweenObj.onUpdate = onStep;
			
			var easeFunc:Function = NTweener.defaultEase;
			switch (xmlAction.EasingFunc) 
			{
				case XmlEffectAction.ET_LINEAR:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Linear.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Linear.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Linear.easeInOut;
					break;
				case XmlEffectAction.ET_BOUNCE:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Bounce.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Bounce.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Bounce.easeInOut;
					break;
					
				case XmlEffectAction.ET_CUBIC:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Cubic.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Cubic.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Cubic.easeInOut;
					break;
					
				case XmlEffectAction.ET_SINE:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Sine.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Sine.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Sine.easeInOut;
					break;
					
				case XmlEffectAction.ET_QUAD:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Quadratic.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Quadratic.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Quadratic.easeInOut;
					break;
					
				case XmlEffectAction.ET_QUART:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Quartic.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Quartic.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Quartic.easeInOut;
					break;
					
				case XmlEffectAction.ET_EXPO:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Exponential.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Exponential.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Exponential.easeInOut;
					break;
					
				case XmlEffectAction.ET_ELASTIC:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Elastic.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Elastic.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Elastic.easeInOut;
					break;
					
				case XmlEffectAction.ET_CIRC:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Circular.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Circular.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Circular.easeInOut;
					break;
					
				case XmlEffectAction.ET_QUINT:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Quintic.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Quintic.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Quintic.easeInOut;
					break;
					
				case XmlEffectAction.ET_BACK:
					if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_OUT )
						easeFunc = Back.easeOut;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN )
						easeFunc = Back.easeIn;
					else if( xmlAction.EasingSubType == XmlEffectAction.EST_EASE_IN_OUT )
						easeFunc = Back.easeInOut;
					break;
			}
			
			tweenObj.ease = easeFunc;
			
			NTweener.to( this, time*0.001, tweenObj );	// делим на тысячу, чтобы перевести в секунды
			//Start(); - мы уже запущены!
		}
		// ============================================================
		public function get IsCompleted():Boolean
		{
			return mIsCompleted;
		}
		// ============================================================
		public function get Name():String
		{
			return mName;
		}
		// ============================================================
		public function OnStopCommand(cmd:EffectCommand):void
		{
			mIsCompleted = true;
			Stop();
			if ( mListener )
				mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );	// передавать бы еще название текущего Block...
		}
		// ============================================================
		public function OnStopNoHideCommand(cmd:EffectCommand):void
		{
			mIsCompleted = true;
			if ( mListener )
				mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );	// передавать бы еще название текущего Block...
		}
		// ============================================================
		// ============================================================
		public function OnDefaultCommand(cmd:EffectCommand):void
		{
			if( mListener ) mListener.OnEffectComplete( mName, cmd.OnCompleteStop, cmd.Action );
			cmd.OnComplete();
		}
		// ============================================================
	}

}