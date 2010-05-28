package base.graphics
{
	import base.modelview.IDraw;
	import base.modelview.IQuant;
	import base.types.*;
	import base.utils.Methods;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author dmBreaker
	 *
	 * Чтобы побороть проблему "общей анимации" - можно копировать все данные базового объекта в ресурс-менеджере
	 */
	public class NAnimatedBitmap implements IQuant//, IDraw
	{
		private var mAnimationSource:BitmapData;
		
		private var mDifferentFramesCount:int;		// кол-во кадров в картинке, но не в финальной анимации
		private var mFullFramesCount:int;
		private var mCurrentFrame:int;
		private var mAnimationTime:Number;
		private var mCurrentTime:Number;
		private var mTimePerFrame:Number;
		private var mRTimePerFrame:Number;
		private var mFrameSize:NSize;
		private var mAnimSpeedMultiplier:Number = 1;
		// ============================================================
		//private var mHalfWidth:Number;
		public var mHalfWidth:Number;
		//private var mHalfHeight:Number;
		public var mHalfHeight:Number;
		// ============================================================
		private var mFrames:Array = new Array();
		// ============================================================
		private var mPrevFrameIndex:int = 0;
		private var mPrevFrame:NBitmapData = null;
		//private var mPrevFrame:BitmapData = null;
		// ============================================================
		
		public function NAnimatedBitmap( animation:BitmapData = null, frameSize:NSize = null, framesCount:int = 1, animTime:Number = 1, settings:* = null )
		{
			if ( !animation )
				return;

			Set( animation, frameSize, framesCount, animTime, settings );
		}
		// ============================================================
		public function Set( animation:BitmapData, frameSize:NSize = null, framesCount:int = 1, animTime:Number = 1, settings:* = null ):void
		{
			mAnimationSource = animation;
			mDifferentFramesCount = framesCount;
			mAnimationTime = animTime;
			
			if( frameSize != null )
				mFrameSize = frameSize;
			else
				mFrameSize = new NSize( animation.width, animation.height );
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			mHalfWidth = mFrameSize.Width * 0.5;
			mHalfHeight = mFrameSize.Height * 0.5;
			
			var i:int;
			var framesSequence:Array = null;
			
			if ( settings )
			{
				if ( settings.sequence )
					framesSequence = settings.sequence;
				else
				{
					framesSequence = new Array(framesCount);
					for ( i = 0; i < framesCount; i++ )
					{
						framesCount[i] = i;
					}
				}
				
				if ( settings.pingpong )
				{
					var pingpong:Boolean = settings.pingpong;
					if ( pingpong )
					{
						var curCount:int = framesSequence.length;
						for ( i = curCount-1; i > 0; i-- )	// чтобы копии первого и последнего кадров не шли подряд
						{
							framesSequence.push( framesSequence[i] );
						}
					}
				}
			}
			
			GenerateFrames( framesSequence );
		}
		// ============================================================
		public function RandomizeFirstFrame():void
		{
			mCurrentTime = Methods.Rand(0, mFrames.length * mTimePerFrame - 1 );
		}
		// ============================================================
		/**
		 * Копирует данные из анимации, но кадры использует те же
		 * @param	animation
		 */
		public function CopyFrom( animation:NAnimatedBitmap ):void
		{
			mAnimationSource = animation.mAnimationSource;
			mDifferentFramesCount = animation.mDifferentFramesCount;
			mFullFramesCount = animation.mFullFramesCount;
			mAnimationTime = animation.mAnimationTime;
			mFrameSize = animation.mFrameSize;
			mTimePerFrame = animation.mTimePerFrame;
			mRTimePerFrame = 1 / mTimePerFrame;
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			mHalfWidth = animation.mHalfWidth;
			mHalfHeight = animation.mHalfHeight;
			
			mFrames = animation.mFrames;	// .slice();
		}
		// ============================================================
		/**
		 * Копирует данные из анимации, но пересоздает кадры
		 * @param	animation
		 */
		public function CloneFrom( animation:NAnimatedBitmap ):void
		{
			//var animation:NAnimatedBitmap = new NAnimatedBitmap();
			
			mAnimationSource = animation.mAnimationSource;
			mDifferentFramesCount = animation.mDifferentFramesCount;
			mFullFramesCount = animation.mFullFramesCount;
			mAnimationTime = animation.mAnimationTime;
			mFrameSize = animation.mFrameSize;
			mTimePerFrame = animation.mTimePerFrame;
			mRTimePerFrame = 1 / mTimePerFrame;
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			mHalfWidth = animation.mHalfWidth;
			mHalfHeight = animation.mHalfHeight;
			
			for each( var frame:NBitmapData in animation.mFrames )
			{
				mFrames.push( frame.Clone() );
			}
		}
		// ============================================================
		public function ShadowEveryFrame( blurX:int, blurY:int, blurCount:int ):void
		{
			for each (var frame:NBitmapData in mFrames )
			{
				frame.ShadowMe( blurX, blurY, blurCount );
			}
		}
		// ============================================================
		public function MixInEveryFrame( bmd:BitmapData, pos:NPoint ):void
		{
			for each (var frame:NBitmapData in mFrames )
			{
				frame.MixInBitmap( bmd, pos );
			}
		}
		// ============================================================
		private function GenerateFrames( framesSequence:Array ):void
		{
			var columns:int = int(mAnimationSource.width / mFrameSize.Width);
			var rows:int = int(mAnimationSource.height / mFrameSize.Height);
			
			var pos:Point = new Point( 0, 0 );
			var j:int, i:int;
			var frame:NBitmapData;
			var rect:Rectangle;
			
			// !!! mDifferentFramesCount здесь никак не учитывается!
			
			if ( !framesSequence )
			{
				for (j = 0; j < rows; j++)
				{
					for (i = 0; i < columns; i++)
					{
						frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
						rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
						
						frame.copyPixels( mAnimationSource, rect, pos );
						mFrames.push( frame );
					}
				}
			}
			else
			{
				var framesTemp:Array = new Array();
				for (j = 0; j < rows; j++)
				{
					for (i = 0; i < columns; i++)
					{
						frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
						rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
						
						frame.copyPixels( mAnimationSource, rect, pos );
						framesTemp.push( frame );
					}
				}
				
				for each (var index:int in framesSequence)
					mFrames.push( framesTemp[index] );
				
				framesTemp.length = 0;
				framesTemp = null;
			}
			mFullFramesCount = mFrames.length;
			
			mTimePerFrame = mAnimationTime / mFullFramesCount;
			mRTimePerFrame = 1/mTimePerFrame;
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public function Quant(diff_ms:int):void
		{
			if ( mFullFramesCount > 1 )	// для однокадровых анимаций ничего делать не нужно
			{
				mCurrentTime += diff_ms;
				while( mCurrentTime >= mAnimationTime )
					mCurrentTime -= mAnimationTime;
			}
		}
		// ============================================================
		//public function Draw( g:IGraphix, posX:Number, posY:Number, alpha:Number ):void
		//{
			//var currentFrame:int = int(mCurrentTime / mTimePerFrame);
			//g.DrawBitmapData( mFrames[currentFrame] as NBitmapData, posX, posY, alpha );
		//}
		// ============================================================
		/**
		 * returns current NBitmapData
		 */
		public function GetNBD():NBitmapData
		{
			// переделать, исходя из реального кол-ва кадров
			if ( mFullFramesCount == 1 )	// для однокадровых анимаций ничего считать не нужно
			{
				if ( mPrevFrame == null )
				{
					mPrevFrame = NBitmapData(mFrames[0]);
				}
				return mPrevFrame;	// mAnimationSource
			}
			else
			{
				var currentFrame:int = int(mCurrentTime * mRTimePerFrame);
				if ( mPrevFrame != null && currentFrame == mPrevFrameIndex )
					return mPrevFrame;
				else
				{
					mPrevFrame = NBitmapData(mFrames[currentFrame]);
					mPrevFrameIndex = currentFrame;
				}
				//trace( "currentFrame", currentFrame );
				//trace( "mFrames[currentFrame]", mFrames[currentFrame] );
				
				return mPrevFrame;// NBitmapData(mFrames[currentFrame]);
			}
		}
		// ============================================================
		public function get HalfWidth():Number
		{
			return mHalfWidth;
		}
		// ============================================================
		public function get HalfHeight():Number
		{
			return mHalfHeight;
		}
		// ============================================================
		public function get AnimationSpeed():Number
		{
			return mAnimSpeedMultiplier;
		}
		// ============================================================
		public function set AnimationSpeed( value:Number ):void
		{
			mAnimSpeedMultiplier = value;
		}
		// ============================================================
		public function SynchronizeCurrentFrameIndex( nbmd:NAnimatedBitmap ):void
		{
			mCurrentTime = nbmd.mCurrentTime;
		}
		// ============================================================
	}
	
}