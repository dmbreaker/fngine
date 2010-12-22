package base.tweening
{
	import base.pools.NObjectsPool;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.*;
	
	/**
	 * NTweener - tween-engine based on game quants
	 * @author dmBreaker
	 */
	public class NTweener
	{
		// ============================================================
		private static const MAX_TWEEN_OBJECTS:int = 512;	// 100
		// ============================================================
		public static var defaultEase:Function = NTweener.easeOut;
		// ============================================================
		public var Duration:Number; //Duration (in seconds)
		public var Vars:Object; //Variables (holds things like alpha or y or whatever we're tweening)
		public var Delay:Number; //Delay (in seconds)
		public var StartTime:int; //Start time
		public var InitTime:int; //Time of initialization. Remember, we can build in delays so this property tells us when the frame action was born, not when it actually started doing anything.
		public var ExtraVars:Array; //Contains parsed data for each property that's being tweened (each has to have a target, property, start, and a change).
		public var Target:Object; //Target object
		public var IsActive:Boolean;
		public var Tweens:Array; //Contains parsed data for each property that's being tweened (each has to have a target, property, start, and a change).
		public var ExtraTweens:Array;
		
		// ============================================================
		private static var Pool:NObjectsPool = new NObjectsPool( MAX_TWEEN_OBJECTS, NTweener );
		//private static var AllTweens:Array = new Array( MAX_TWEEN_OBJECTS );
		protected static var AllTweens:Dictionary = new Dictionary(); //Holds references to all our tween targets.
		protected static var mCurTime:uint;
		protected static var mIsClassInitted:Boolean;
		
		
		protected var IsInited:Boolean;
		// ============================================================
		public function NTweener()	// объекты для NObjectsPool должны иметь "пустой" конструктор
		{
		}
		// ============================================================
		public function Init( target:*, duration:Number, vars:*, extra_vars:Array = null ):NTweener
		{
			if (target == null) return null;
			this.Target = target;
			this.Duration = duration || 0.001; //Easing equations don't work when the duration is zero.
			this.Vars = vars;
			this.Delay = vars.delay || 0;
			this.ExtraVars = extra_vars;
			this.Tweens = [];
			if ( extra_vars != null );
				this.ExtraTweens = [];
			
			IsActive = !(duration == 0 && Delay == 0);
			// добавить данный ТВИН в список, только в такой, из которого можно быстро удалять...
			
			//AllTweens[Target] = this;
			AllTweens[this] = this;
			
			if (!(this.Vars.ease is Function))
				this.Vars.ease = defaultEase;
			
			if ( !mIsClassInitted )
			{
				mIsClassInitted = true;
				mCurTime = 0;// getTimer();	- у нас время через кванты считается, поэтому начальное значение не важно
			}
			this.InitTime = mCurTime;
			if ( IsActive )
			{
				InitTweenVals();
				this.StartTime = mCurTime;
				if (IsActive) //Means duration is zero and delay is zero, so render it now, but add one to the startTime because this.duration is always forced to be at least 0.001 since easing equations can't handle zero.
					render(this.StartTime + 1);
				else
					render(this.StartTime);
			}
			
			return this;
		}
		// ============================================================
		public static function to( target:*, duration:Number, vars:*, extra_vars:Array = null ):NTweener
		{
			return NTweener(Pool.Obj).Init( target, duration, vars, extra_vars );
		}
		// ============================================================
		//public static function tweenableTo( target:ITweenable, duration:Number, vars:*, extra_vars:Array = null ):void
		//{
			//
		//}
		// ============================================================
		public static function Quant( diff_ms:int ):void
		{
			mCurTime += diff_ms;
			//var t:uint = mCurTime = getTimer();
			var a:Dictionary = AllTweens, p:NTweener, tw:Object;
			for each (p in a)
			{
				//trace( "NTweener:", p );
				if ( p.IsActive && p.Target != null )
				{
					p.render( mCurTime );
				}
				
				//for (tw in p)
				//{
					//if (p[tw] != undefined && p[tw].IsActive)
					//{
						//p[tw].render(t);
						//trace( "NTweener: ", p[tw] );
					//}
				//}
			}
		}
		// ============================================================
		public function InitTweenVals():void
		{
			var p:String, i:int;
			//trace( "===============================");
			for (p in this.Vars)
			{
				if (p == "ease" || p == "delay" || p == "onComplete" || p == "onUpdate" || p == "onStart" ) //"type" is for TweenFilterLite, and it's an issue when trying to tween filters on TextFields which do actually have a "type" property.
				{
					
				}
				else
				{
					//if (this.target.hasOwnProperty(p)) { //REMOVED because there's a bug in Flash Player 10 (Beta) that incorrectly reports that DisplayObjects don't have a "z" property. This check wasn't entirely necessary anyway - it just prevented runtime errors if/when developers tried tweening properties that didn't exist.
						//if (typeof(this.Vars[p]) == "number")
						if ( (this.Vars[p]) is Number )
							this.Tweens.push({o:this.Target, p:p, s:this.Target[p], c:this.Vars[p] - this.Target[p]}); //o:object, p:property, s:starting value, c:change in value
						else
							this.Tweens.push({o:this.Target, p:p, s:this.Target[p], c:Number(this.Vars[p])}); //o:object, p:property, s:starting value, c:change in value
					//}
				}
			}
			
			if ( this.ExtraVars != null )
			{
				for each( var tween:* in this.ExtraVars )
				{
					for (p in tween)
					{
						if (p == "ease" )
						{
							//
						}
						else
						{
							//if (this.target.hasOwnProperty(p)) { //REMOVED because there's a bug in Flash Player 10 (Beta) that incorrectly reports that DisplayObjects don't have a "z" property. This check wasn't entirely necessary anyway - it just prevented runtime errors if/when developers tried tweening properties that didn't exist.
								//if (typeof(this.ExtraVars[p]) == "number")
								if ( (tween[p]) is Number )
									this.ExtraTweens.push({p:p, s:this.Target[p], c:tween[p] - this.Target[p]}); //p:property, s:starting value, c:change in value
								else
									this.ExtraTweens.push({p:p, s:this.Target[p], c:Number(tween[p])}); //p:property, s:starting value, c:change in value
							//}
						}
					}
				}
			}

			IsInited = true;
		}
		// ============================================================
		public function render(t:uint):void
		{
			//var time:Number = (t - this.StartTime) / 1000, factor:Number, tp:Object, i:int;
			var time:Number = (t - this.StartTime) / 1000, factor:Number, tp:Object, i:int;
			var duration:Number = this.Duration;
			
			if (time >= duration)
			{
				time = duration;
				factor = 1;
			}
			else
				factor = this.Vars.ease(time, 0, 1, duration);
			
			for (i = this.Tweens.length - 1; i > -1; i--)
			{
				tp = this.Tweens[i];
				Target[tp.p] = tp.s + (factor * tp.c);
				//tp.o[tp.p] = tp.s + (factor * tp.c);
			}
			
			var exVars:*;
			if ( this.ExtraTweens )
			{
				for (i = this.ExtraTweens.length - 1; i > -1; i--)
				{
					exVars = this.ExtraVars[i];
					tp = this.ExtraTweens[i];
					
					if (time >= duration)
					{
						time = duration;
						factor = 1;
					}
					else if( exVars.ease != null )
						factor = exVars.ease(time, 0, 1, duration);
					// else factor = factor;
					
					Target[tp.p] = tp.s + (factor * tp.c);
					//tp.o[tp.p] = tp.s + (factor * tp.c);
				}
			}
			if (this.Vars.onUpdate != null)
			{
				this.Vars.onUpdate.apply();
			}

			if (time == duration)
			{
				complete(true);
			}
		}
		// ============================================================
		public function complete(skipRender:Boolean = false):void
		{
			if (!skipRender)
			{
				if (!IsInited)
					InitTweenVals();
				this.StartTime = mCurTime - (this.Duration * 1000);
				render(mCurTime); //Just to force the final render
				return;
			}
			if (this.Vars.visible != undefined)
			{
				this.Target.visible = Boolean(this.Vars.visible);
			}

			var on_complete:* = this.Vars.onComplete;
			var target:* = this.Target;
			removeTween(this); //moved above the onComplete callback in case there's an error in the user's onComplete - this prevents constant errors
			if (on_complete != null)
			{
				this.Vars.onComplete.apply(null, [target]);
			}
		}
		// ============================================================
		public static function removeTween(t:NTweener = null):void
		{
			//if (t != null && AllTweens[t.Target] != undefined)
			if (t != null && AllTweens[t] != undefined)
			{
				//delete (AllTweens[t.Target]);// [$t];
				delete (AllTweens[t]);// [$t];
				Pool.Obj = t;
				
				//trace( "TWEEN REMOVED" );
			}
		}
		// ============================================================
		public static function killTweensOf(tg:Object = null):void
		{
			if (tg != null)
			{
				for( var tween:* in AllTweens )	// здесь нифига не строка в tween
				{
					var tweenObj:NTweener = NTweener(tween);
					if ( AllTweens[tween] != undefined && AllTweens[tween].Target == tg )
					{
						delete (AllTweens[tween]);
						Pool.Obj = tweenObj;
						
						//trace( "ALL TWEENS REMOVED" );
					}
				}
			}
		}
		
		// ============================================================
		//public static function killTweensOf(tg:Object = null, complete:Boolean = false):void
		//{
			//if (tg != null && AllTweens[tg] != undefined)
			//{
				//if (complete)
				//{
					//var o:Object = AllTweens[tg];
					//for (var tw:* in o)
					//{
						//o[tw].complete(false);
					//}
				//}
				//delete (AllTweens[tg]);
			//}
		//}
		// ============================================================
		//public static function killGarbage(e:TimerEvent):void
		//{
			//var tg_cnt:uint = 0, found:Boolean, p:Object, twp:Object, tw:Object;
			//for (p in AllTweens)
			//{
				//found = false;
				//for (twp in AllTweens[p])
				//{
					//found = true;
					//break;
				//}
				//if (!found)
				//{
					//delete (AllTweens[p]);
				//} else {
					//tg_cnt++;
				//}
			//}
		//}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		// t - current time
		// b - beginning value
		// c - change in value
		// d - duration (full time)
		public static function easeOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return -c * (t /= d) * (t - 2) + b;
		}
		// ============================================================
		public static function get CurTweenerTime():uint
		{
			return mCurTime;
		}
		// ============================================================
	}
	
}