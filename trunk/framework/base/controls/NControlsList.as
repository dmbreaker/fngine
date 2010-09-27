package base.controls 
{
	import base.graphics.BitmapGraphix;
	import base.types.NRect;
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
		public var mCurrentShift:Number = 0;	// current shift of controls inside NControlsList container
		private var mIsHorizontal:Boolean = true;	// false - vertical
		private var mSpan:Number = 4;	// distance between controls
		
		//private var mBuffer:NBitmapData;
		private var mBuffer:BitmapGraphix;
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
						
					// инициализим так, будто бы добавляем, но по факту не добавляем
					control.InitParent( Parent, ParentScene );
					control.OnAdded( Parent );
				}
			}
			
			if( mIsHorizontal )
				mMaxShiftLength = mFullLength - Rect.Width;
			else 
				mMaxShiftLength = mFullLength - Rect.Height;
			if ( mMaxShiftLength < 0 )
				mMaxShiftLength = 0;
			
			mCurrentShift = 0;// -mFullLength;
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
					mBuffer = new BitmapGraphix( Rect.Width, Rect.Height );
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
					var spos:Number = mCurrentShift;	// position of next control
					//var template_length:Number;
					var control_length:Number;	// length of NControlsList
					if ( mIsHorizontal )
					{
						control_length = Width;
					}
					else
					{
						control_length = Height;
					}
					
					for each( var control:Control in mControls )
					{
						if ( control )
						{
							if ( (spos + GetControlLength(control)) < 0 )		// если картинка за левой/верхней границей
								continue;
							else if ( spos >= control_length )		// картинка за пределами правой/нижней границы
								break;
							else	// картинка попадает в область контрола
							{
								if ( mIsHorizontal )
								{
									mBuffer.AddOffset( spos, 0 );
									control.Draw(mBuffer, 0);
									mBuffer.AddOffset( -spos, 0 );
								}
								else
								{
									mBuffer.AddOffset( 0, spos );
									control.Draw(mBuffer, 0);
									mBuffer.AddOffset( 0, -spos );
								}
							}
							
							spos += GetControlLength(control) + mSpan;
						}
					}
				}
			}
		}
		// ============================================================
		private function GetControlLength( control:Control ):int
		{
			if ( mIsHorizontal )
				return control.Width;
			else
				return control.Height;
		}
		// ============================================================
		public function GetControl(x:Number, y:Number, relativePos:*):Control
		{
			var pos:int = mCurrentShift;

			for each( var control:Control in mControls )
			{
				var r:NRect = control.Rect;
				if ( mIsHorizontal )
				{
					r.Position.x = pos;
					if ( r.Contains( x, y ) )
					{
						relativePos.x = x - pos;
						relativePos.y = y;
						return control;
					}
				}
				else
				{
					r.Position.y = pos;
					if ( r.Contains( x, y ) )
					{
						relativePos.x = x;
						relativePos.y = y - pos;
						return control;
					}
				}

				pos += GetControlLength(control) + mSpan;
			}
			
			return null;
		}
		// ============================================================
		override public function OnMouseDown(x:Number, y:Number):void 
		{
			var resultPos:* = {};
			var control:Control = GetControl( x, y, resultPos );
			if( control )
				control.OnMouseDown( resultPos.x, resultPos.y );
				
			Invalidate();
		}
		// ============================================================
		override public function OnMouseUp(x:Number, y:Number):void 
		{
			var resultPos:* = {};
			var control:Control = GetControl( x, y, resultPos );
			if( control )
				control.OnMouseUp( resultPos.x, resultPos.y );
				
			Invalidate();
		}
		// ============================================================
		override public function OnMouseMove(x:Number, y:Number):void 
		{
			/*var resultPos:* = {};
			var control:Control = GetControl( x, y, resultPos );
			if( control )
				control.OnMouseMove( resultPos.x, resultPos.y );*/
		}
		// ============================================================
	}

}