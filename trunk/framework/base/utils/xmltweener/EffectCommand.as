package base.utils.xmltweener 
{
	import base.utils.NumberObj;
	/**
	 * 'command' in XML
	 * @author dmbreaker
	 */
	public class EffectCommand
	{
		// ============================================================
		// ============================================================
		public var ID:String = "";
		public var Action:String = "";
		public var ActionOnComplete:String = "";	// то же, что и command, только после выполнения не будет выполнения каких-либо ActionOnComplete или BlockOnComplete
		public var BlockOnComplete:String = "";
		public var OnCompleteStop:String = "";

		//std::vector<float*> EffectParams;
		public var EffectParams:Vector.<String> = new Vector.<String>();
		
		protected var mXmlAction:XmlEffectAction = null;
		protected var mEffect:XmlEffect = null;
		// ============================================================
		// ============================================================
		public function EffectCommand() 
		{
			mEffect = null;
		}
		// ============================================================
		// ============================================================
		/*protected function StringToParam( effect:XmlEffect, param:String ):Number	// float*
		{
			if( param == "x" )
				return &effect->X;
			else if( param == "y" )
				return &effect->Y;
			else if( param == "alpha" )
				return &effect->Alpha;
			else if( param == "scalex" )
				return &effect->ScaleX;
			else if( param == "scaley" )
				return &effect->ScaleY;
			else if( param == "angle" )
				return &effect->Angle;
			else if( param == "param1" )
				return &effect->Param1;
			else if( param == "param2" )
				return &effect->Param2;
			else if( param == "param3" )
				return &effect->Param3;
			else if( param == "param4" )
				return &effect->Param4;

			return NULL;
		}*/
		// ============================================================
		protected function FreeParam():void
		{
		}
		// ============================================================
		public function Parse( node:XML ):void
		{
			var xnode:XML = XML(node);
			Action = xnode.@action;
			ActionOnComplete = xnode.@action_on_complete;
			BlockOnComplete = xnode.@block_on_complete;
			OnCompleteStop = xnode.@on_complete;

			EffectParams.length = 0;
		}
		// ============================================================
		public function Init( effect:XmlEffect ):void
		{
			var i:int;
			
			EffectParams.length = 0;

			mEffect = effect;
			if( effect.mXmlActionMap.ContainsKey(Action) )
				mXmlAction = effect.mXmlActionMap.GetValue(Action);
			else
			{
				trace("EffectCommand: Action '" + Action + "' was not found");
				return;
			}

			// сохраним ссылки на параметры эффекта:
			var count:int = mXmlAction.Params.length;
			for( i=0; i<count; i++ )
			{
				//float* param = StringToParam( effect, mXmlAction->Params[i] );
				if( mXmlAction.Params[i] )		// чтобы нулевые не добавлять
					EffectParams.push( mXmlAction.Params[i] );
			}

			FreeParam();

			/*switch( mXmlAction.Type )
			{
				case XmlEffectAction.TypeSet:
					{
					}
					break;
				
				case XmlEffectAction.TypeWait:
					{
						//  @ mParam = new TweenerParam( mXmlAction->Time, tween::LINEAR );
						//  @ mParam.ID = ID;
					}
					break;
			
				default:
					{
						//  @ mParam = new TweenerParam( mXmlAction.Time, mXmlAction.EasingFunc, mXmlAction.EasingSubType );
						
						for( i=0; i<count; i++ )
						{
							if ( EffectParams[i] )	// чтобы неправильно написанные не добавлять
							{
								//  @ mParam->addProperty( EffectParams[i], mXmlAction->ToValues[i] );
							}
						}

						//  @ mParam.ID = ID;
					}
					break;
			}*/
		}
		// ============================================================
		public function Execute():void
		{
			var i:int = 0;
			var count:int = 0;
			var tweenObj:* = {};
			
			switch( mXmlAction.Type )
			{
				case XmlEffectAction.TypeSet:
					{
						count = mXmlAction.ToValues.length;
						if( count > 0 )
						{
							for( i=0; i<count; i++ )
							{
								if ( EffectParams[i] )	// чтобы в ноль не записать
								{
									mEffect[ EffectParams[i] ] = mXmlAction.ToValues[i];
									// *(EffectParams[i]) = mXmlAction->ToValues[i];
								}
							}
						}
					}
					break;
					
				case XmlEffectAction.TypeSetImage:
					{
						mEffect.SetImageByName( mXmlAction.To );
					}
					break;
					
				case XmlEffectAction.TypeWait:
					{
						//  @ mEffect->GetTweener().addTween( *mParam );
						mEffect.StartTweener( mXmlAction.Time, { }, mXmlAction, this );
					}
					break;
					
				default:
					{
						//count = mXmlAction.FromValues.length;
						count = mXmlAction.ToValues.length;
						if( count > 0 )
						{
							for( i=0; i<count; i++ )
							{
								if ( EffectParams[i] )	// чтобы в ноль не записать
								{
									if( mXmlAction.FromValues.length > i )
										mEffect[ EffectParams[i] ] = mXmlAction.FromValues[i];
									// *(EffectParams[i]) = mXmlAction->FromValues[i];
									tweenObj[EffectParams[i]] = mXmlAction.ToValues[i];
								}
							}
						}

						//  @ if( mEffect && mParam )
						//  @	mEffect->GetTweener().addTween( *mParam );
						mEffect.StartTweener( mXmlAction.Time, tweenObj, mXmlAction, this );
					}
					break;
			}
		}
		// ============================================================
		public function OnComplete():void
		{
			if( BlockOnComplete.length > 0 )
			{
				mEffect.StartBlock( BlockOnComplete );
			}
		}
		// ============================================================
		public function OnTweenComplete(xmlEffect:XmlEffect):void
		{
			if( OnCompleteStop == "stop" )
			{
				mEffect.OnStopCommand(this);
			}
			else if( OnCompleteStop == "stop_no_hide" )
			{
				mEffect.OnStopNoHideCommand(this);
			}
			else
				mEffect.OnDefaultCommand(this);
		}
		// ============================================================
	}

}