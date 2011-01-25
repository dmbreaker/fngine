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
		
		private var mFramesPerSequence:int = -1;	// одна последовательность
		
		public var Settings:* = { };
		
		private var mIsVertical:Boolean = false;
		// ============================================================
		//private var mHalfWidth:Number;
		public var mHalfWidth:Number;
		//private var mHalfHeight:Number;
		public var mHalfHeight:Number;
		// ============================================================
		private var mFrames:Vector.<NBitmapData> = new Vector.<NBitmapData>();//<NBitmapData>
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
			Settings = settings;
			
			var is_ver:Boolean = false;
			var columns:int = 1;
			var rows:int = 1;
			
			mAnimationSource = animation;
			if( framesCount > 0 )
				mDifferentFramesCount = framesCount;
			mAnimationTime = animTime;
			
			if( frameSize != null )
				mFrameSize = frameSize;
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			var i:int;
			var framesSequence:Array = null;
			
			if ( settings )				// если есть доп. настройки
			{
				if ( settings.mode )
				{
					var mode:String = settings.mode;
					is_ver = ( mode == "ver" || mode == "v" || mode == "vertical" );
				}
				if ( settings.cols )
					columns = settings.cols;
				if ( settings.rows )
					rows = settings.rows;
				if ( framesCount <= 0 )
				{
					framesCount = columns * rows;
					mDifferentFramesCount = framesCount;
				}
				
				
				if ( animTime == 1 )	// 2010.12.27
				{
					if ( settings.framedelay )
					{
						mTimePerFrame = settings.framedelay;
						if ( settings.frames_per_sequence )
							mAnimationTime = int(settings.framedelay) * int(settings.frames_per_sequence);
						else
							mAnimationTime = int(settings.framedelay) * framesCount;
					}
				}
				
				if ( settings.frames_per_sequence )
					mFramesPerSequence = settings.frames_per_sequence;
				
				
				
				mIsVertical = is_ver;
				
				if( frameSize == null )
				{
					mFrameSize = new NSize( animation.width/columns, animation.height/rows );
				}
				
				if ( settings.sequence )	// если в настройках указана последовательность кадров
					framesSequence = settings.sequence;	// запомним ее
				else						// иначе
				{
					{
						framesSequence = new Array(framesCount);	// зададим последовательность в том порядке, в котором следуют кадры (горизонтально)
						for ( i = 0; i < framesCount; i++ )
						{
							framesSequence[i] = i;
						}
					}
				}
				
				if ( settings.pingpong )		// кадры идут "туда и обратно"
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
			
			mHalfWidth = mFrameSize.Width * 0.5;
			mHalfHeight = mFrameSize.Height * 0.5;
			
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
			mIsVertical = animation.mIsVertical;
			mRTimePerFrame = 1 / mTimePerFrame;
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			mFramesPerSequence = animation.mFramesPerSequence;
			Settings = animation.Settings;
			
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
			mIsVertical = animation.mIsVertical;
			mRTimePerFrame = 1 / mTimePerFrame;
			mCurrentFrame = 0;
			
			mFrames.length = 0;
			mCurrentTime = 0;
			
			mFramesPerSequence = animation.mFramesPerSequence;
			Settings = animation.Settings;
			
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
			
			var frames_count:int = mDifferentFramesCount;
			
			if ( !framesSequence )	// если последовательность кадров не задана
			{
				if ( !mIsVertical )
				{
					for (j = 0; j < rows; j++)
					{
						for (i = 0; i < columns; i++)
						{
							if ( frames_count == 0 )
								break;

							frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
							rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
							
							frame.copyPixels( mAnimationSource, rect, pos );
							mFrames.push( frame );
							
							--frames_count;
						}
					}
				}
				else
				{
					for (i = 0; i < columns; i++)
					{
						for (j = 0; j < rows; j++)
						{
							if ( frames_count == 0 )
								break;
							
							frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
							rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
							
							frame.copyPixels( mAnimationSource, rect, pos );
							mFrames.push( frame );
							
							--frames_count;
						}
					}
				}
			}
			else
			{
				//var frames_count:int = framesSequence.length;
				
				var framesTemp:Vector.<NBitmapData> = new Vector.<NBitmapData>();
				if ( !mIsVertical )
				{
					for (j = 0; j < rows; j++)
					{
						for (i = 0; i < columns; i++)
						{
							//if ( frames_count == 0 )
							//	break;
							
							frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
							rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
							
							frame.copyPixels( mAnimationSource, rect, pos );
							framesTemp.push( frame );
							
							//--frames_count;
						}
					}
				}
				else
				{
					for (i = 0; i < columns; i++)
					{
						for (j = 0; j < rows; j++)
						{
							//if ( frames_count == 0 )
							//	break;
								
							frame = new NBitmapData( mFrameSize.Width, mFrameSize.Height );
							rect = new Rectangle( i * mFrameSize.Width, j * mFrameSize.Height, mFrameSize.Width, mFrameSize.Height );
							
							frame.copyPixels( mAnimationSource, rect, pos );
							framesTemp.push( frame );
							
							//--frames_count;
						}
					}
				}
				
				for each (var index:int in framesSequence)
					mFrames.push( framesTemp[index] );
				
				framesTemp.length = 0;
				framesTemp = null;
			}
			mFullFramesCount = mFrames.length;
			
			if ( mFramesPerSequence > 0 )
				mTimePerFrame = mAnimationTime / mFramesPerSequence;
			else
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
				mCurrentTime = mCurrentTime % mAnimationTime;
				//while( mCurrentTime >= mAnimationTime )
				//	mCurrentTime -= mAnimationTime;
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
		public function GetNBD( time:int = -1 ):NBitmapData
		{
			var currentFrame:int;
			
			// переделать, исходя из реального кол-ва кадров
			if ( mFullFramesCount == 1 )	// для однокадровых анимаций ничего считать не нужно
			{
				if ( mPrevFrame == null )
				{
					mPrevFrame = mFrames[0];
				}
				return mPrevFrame;	// mAnimationSource
			}
			else
			{
				if ( time == -1 )
				{
					currentFrame = int(mCurrentTime * mRTimePerFrame);
					if ( mPrevFrame != null && currentFrame == mPrevFrameIndex )
						return mPrevFrame;
					else
					{
						mPrevFrame = mFrames[currentFrame];
						mPrevFrameIndex = currentFrame;
					}
					//trace( "currentFrame", currentFrame );
					//trace( "mFrames[currentFrame]", mFrames[currentFrame] );
					
					return mPrevFrame;// NBitmapData(mFrames[currentFrame]);
				}
				else
				{
					time = time % mAnimationTime;
					
					currentFrame = int(time * mRTimePerFrame);
					if ( mPrevFrame != null && currentFrame == mPrevFrameIndex )
						return mPrevFrame;
					else
					{
						mPrevFrame = mFrames[currentFrame];
						mPrevFrameIndex = currentFrame;
					}
					return mPrevFrame;
				}
			}
		}
		// ============================================================
		public function GetFrame( index:int ):NBitmapData
		{
			if ( index >= mFrames.length )
				return mFrames[0];			// чтобы видеть, что кадры не меняются
			return mFrames[index];
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
		public function get FrameWidth():int
		{
			return int(mFrameSize.Width);
		}
		// ============================================================
		public function get FrameHeight():int
		{
			return int(mFrameSize.Height);
		}
		// ============================================================
		public function get TotalAnimTime():int
		{
			return mAnimationTime;
		}
		// ============================================================
		public function get FrameDelay():int
		{
			return mTimePerFrame;
		}
		// ============================================================
		public function get FramesPerSequence():int
		{
			return mFramesPerSequence;
		}
		// ============================================================
		/*public function SetSequenceIndex(index:int):void
		{
			
		}*/
		// ============================================================
	}
	
}