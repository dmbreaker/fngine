package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.graphics.NBitmapData;
	/**
	 * Incomplete
	 * @author dmbreaker
	 */
	public class NControlsList extends Control
	{
		// ============================================================
		protected var mControls:Vector.<Control> = new Vector.<Control>();
		
		private var mFullLength:Number = 0;
		private var mMaxShiftLength:Number = 0;	// (mFullLength - control_width)
		public var mCurrentShift:Number = 0;
		private var mIsHorizontal:Boolean = true;	// false - vertical
		private var mSpan:Number = 4;	// distance between controls
		
		private var mBuffer:NBitmapData;
		// ============================================================
		public function NControlsList( name:String ) 
		{
			super( name );
		}
		// ============================================================
		// ============================================================
		public function get DataSource():Vector.<Control>
		{
			return mControls;
		}
		// ============================================================
		public function set DataSource( ds:Vector.<Control> ):void
		{
			mControls = ds;
			
			if ( ds == null )
			{
				mFullLength = 0;
				mMaxShiftLength = 0;
				mCurrentShift = 0;
				//Invalidate();
				return;
			}
			
			/*if ( mIsHorizontal )
				mTemplateLength = mMiniatureTemplate.Size.Width;
			else
				mTemplateLength = mMiniatureTemplate.Size.Height;*/
				
			mFullLength = 0;
			
			for each (var control:Control in mControls) 
			{
				if ( control )
				{
					if( mIsHorizontal )
						mFullLength += control.Width + mSpan;
					else
						mFullLength += control.Height + mSpan;
				}
			}
			
			if( mIsHorizontal )
				mMaxShiftLength = mFullLength - Rect.Width;
			else 
				mMaxShiftLength = mFullLength - Rect.Height;
			if ( mMaxShiftLength < 0 )
				mMaxShiftLength = 0;
			
			mCurrentShift = -mFullLength;
			//Invalidate();
		}
		// ============================================================
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void 
		{
			super.Draw(g, diff_ms);

			EnsureBuffer();
			
			if ( mBuffer )
			{
				g.DrawBitmapDataFast( mBuffer, 0, 0 );
			}
		}
		// ============================================================
		private function EnsureBuffer():void
		{
			if ( mBuffer )
				return;
			else
			{
				if ( !Rect.Size.IsEmpty )
				{
					mBuffer = new NBitmapData( Rect.Width, Rect.Height );
					Invalidate();
				}
				else
					mBuffer = null;
			}
		}
		// ============================================================
		private function Invalidate():void
		{
			if ( mBuffer )	// буфер уже должен быть
			{
				mBuffer.Clear();
				
				if ( mControls )
				{
					var spos:Number = mCurrentShift;
					//var template_length:Number;
					//var control_length:Number;
					/*if ( mIsHorizontal )
					{
						template_length = mMiniatureTemplate.Size.Width;
						control_length = Width;
					}
					else
					{
						template_length = mMiniatureTemplate.Size.Height;
						control_length = Height;
					}*/
					
					/*for each( var control:Control in mControls )
					{
						if ( control )
						{
							if ( (spos + template_length) < 0 )		// если картинка за левой/верхней границей
								continue;
							else if ( spos >= control_length )		// картинка за пределами правой/нижней границы
								break;
							else	// картинка попадает в область контрола
							{
								if( mIsHorizontal )
									mMiniatureTemplate.Draw( mBuffer, spos, 0, data );
								else
									mMiniatureTemplate.Draw( mBuffer, 0, spos, data );
							}
							
							spos += template_length + mSpan;
						}
					}*/
				}
			}
		}
		// ============================================================
	}

}