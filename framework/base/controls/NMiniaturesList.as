package base.controls 
{
	import base.controls.NBaseTooltip;
	import base.externals.bulkloader.BulkLoader;
	import base.externals.bulkloader.loadingtypes.LoadingItem;
	import base.graphics.BitmapGraphix;
	import base.graphics.NBitmapData;
	import base.tweening.NTweener;
	import base.types.NPoint;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NMiniaturesList extends Control
	{
		// ============================================================
		private var mLoader:BulkLoader = new BulkLoader( "miniatures_loader" );
		// ============================================================
		private var mDataSourceArray:Array;
		
		private var mFullLength:Number = 0;
		private var mMaxShiftLength:Number = 0;	// mFullLength - щирина контрола
		private var mMiniatureTemplate:NMiniature = new NMiniature();
		private var mTemplateLength:Number;
		public var mCurrentShift:Number = 0;
		private var mIsHorizontal:Boolean = true;	// false - vertical
		private var mSpan:Number = 4;	// расстояние между миниатюрами
		
		private var mBuffer:NBitmapData;
		
		private var mAllImagesLoaded:Boolean = false;
		// ============================================================
		public function NMiniaturesList( name:String ) 
		{
			super( name );
		}
		// ============================================================
		public function get DataSource():Array
		{
			return mDataSourceArray;
		}
		// ============================================================
		public function set DataSource( ds:Array ):void
		{
			mDataSourceArray = ds;
			StartImagesLoading();
			
			if ( mIsHorizontal )
				mTemplateLength = mMiniatureTemplate.Size.Width;
			else
				mTemplateLength = mMiniatureTemplate.Size.Height;
				
			mFullLength = 0;
			
			for each (var data:* in ds) 
			{
				if ( data )
					mFullLength += mTemplateLength + mSpan;
			}
			
			mMaxShiftLength = mFullLength - Rect.Width;
			if ( mMaxShiftLength < 0 )
				mMaxShiftLength = 0;
			
			mCurrentShift = -mFullLength;
			mAllImagesLoaded = false;
			Invalidate();
		}
		// ============================================================
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void 
		{
			super.Draw(g, diff_ms);

			EnsureBuffer();
			
			if ( mBuffer )
			{
				if ( Need_InvalidateNotLoaded( diff_ms ) )
				{
					Invalidate();
				}
				
				g.DrawBitmapDataFast( mBuffer, 0, 0 );
			}
		}
		// ============================================================
		private const CHECK_PERIOD_MS:int = 100;
		private var checkTicks:int = 0;
		private function Need_InvalidateNotLoaded( diff_ms:int ):Boolean
		{
			if ( mAllImagesLoaded )
				return false;

			checkTicks += diff_ms;
				
			if ( checkTicks >= CHECK_PERIOD_MS )
			{
				checkTicks = 0;
				
				// recheck
				var notLoadedCount:int = 0;
				for each( var data:* in mDataSourceArray )
				{
					if ( data )
					{
						if ( data.image is LoadingItem )
							++notLoadedCount;
					}
				}
				
				if ( notLoadedCount == 0 )
					mAllImagesLoaded = true;
					
				return true;	// всегда TRUE, чтобы перерисовало последние обновившиеся
			}
			else
			{
				return false;
			}
		}
		// ============================================================
		private function Invalidate():void
		{
			if ( mBuffer )	// буфер уже должен быть
			{
				mBuffer.Clear();
				
				if ( mDataSourceArray )
				{
					var spos:Number = mCurrentShift;
					var template_length:Number;
					var control_length:Number;
					if ( mIsHorizontal )
					{
						template_length = mMiniatureTemplate.Size.Width;
						control_length = Width;
					}
					else
					{
						template_length = mMiniatureTemplate.Size.Height;
						control_length = Height;
					}
					
					for each( var data:* in mDataSourceArray )
					{
						if ( data )
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
					}
				}
			}
		}
		// ============================================================
		override public function Resize(w:int, h:int):void 
		{
			super.Resize(w, h);
			
			if ( mBuffer )
			{
				mBuffer.dispose();
				mBuffer = null;
			}
			
			EnsureBuffer();
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
		public function SlideToStart():void 
		{
			NTweener.killTweensOf( this );
			NTweener.to( this, 0.5, {mCurrentShift:0, ease:NTweener.easeOut, onUpdate:OnShiftUpdate} );
		}
		// ============================================================
		public function HideToStart():void 
		{
			NTweener.killTweensOf( this );
			NTweener.to( this, 0.5, {mCurrentShift:-mFullLength, ease:NTweener.easeOut, onUpdate:OnShiftUpdate} );
		}
		// ============================================================
		public function SlideOneNext():void 
		{
			NTweener.killTweensOf( this );
			var slideValue:int = mCurrentShift + mTemplateLength;
			if ( slideValue > mMaxShiftLength )
				slideValue = mMaxShiftLength;
			if ( slideValue < 0 )
				slideValue = 0;
			NTweener.to( this, 0.25, { mCurrentShift:slideValue,
										ease:NTweener.easeOut, onUpdate:OnShiftUpdate} );
		}
		// ============================================================
		public function SlideOnePrev():void 
		{
			NTweener.killTweensOf( this );
			var slideValue:int = mCurrentShift - mTemplateLength;
			if ( slideValue < 0 )
				slideValue = 0;
			NTweener.to( this, 0.25, { mCurrentShift:slideValue,
										ease:NTweener.easeOut, onUpdate:OnShiftUpdate} );
		}
		// ============================================================
		private function OnShiftUpdate():void 
		{
			Invalidate();
		}
		// ============================================================
		public function get CurrentShift():Number
		{
			return mCurrentShift;
		}
		// ============================================================
		public function set CurrentShift( value:Number ):void 
		{
			if ( mCurrentShift != value )
			{
				mCurrentShift = value;
				Invalidate();
			}
		}
		// ============================================================
		public function get MiniatureTemplate():NMiniature
		{
			return mMiniatureTemplate;
		}
		// ============================================================
		public function set MiniatureTemplate( template:NMiniature ):void 
		{
			mMiniatureTemplate = template;
		}
		// ============================================================
		private function StartImagesLoading():void
		{
			if ( mDataSourceArray && mDataSourceArray.length > 0 )
			{
				mLoader.removeAll();
				var myContext:LoaderContext = new LoaderContext(); 
				myContext.checkPolicyFile = true;
				
				for each( var item:* in mDataSourceArray )
				{
					// ставим изображение на загрузку:
					var litem:LoadingItem = mLoader.add( item.image_url, { id:item.uid, type:"image", context:myContext } );
					trace( "photo url:", item.image_url );
					
					// создаем data_item для миниатюр:
					item.image = litem;
				}
					
				//mBulkLoader.addEventListener(BulkLoader.COMPLETE, OnAllPhotosLoaded, false, 0, true);
				mLoader.addEventListener(BulkLoader.ERROR, OnBulkLoadError, false, 0, true);
				mLoader.start();
			}
			
			//RefillData( NScoresPanel.DAY_TAB );
		}
		// ============================================================
		private function OnBulkLoadError(e:ErrorEvent):void 
		{
			BlastCore.Trace( "MiniaturesList.BulkLoader error: " + e.text );
		}
		// ============================================================
		// ============================================================
		// ============================================================
		override public function get NeedTooltip():Boolean
		{
			if( mDataSourceArray )
				return true;
			else
				return false;
		}
		// ============================================================
		override public function GetTooltip(mouse_pos:NPoint):NBaseTooltip 
		{
			if ( !mDataSourceArray )
				return null;
			
			var data:* = PointToDataItem( mouse_pos );
			if ( data == null )	// если не указывает ни на один из элементов
				return null;
			else
			{
				var tt:NMultilineTooltip = NMultilineTooltip.Instance;
				tt.Tag = data.uid;	// ОБЯЗАТЕЛЬНО! Чтобы различать элементы позже
				tt.InitData( [	data.name + " " + data.surname,
								"Лучший результат сегодня: " + data.today_score,
								"Место в таблице рекордов: " + data.place + " из " + data.places_count,
								"Уровней открыто: " + data.levels+"/25"] );
				return tt;
			}
		}
		// ============================================================
		override public function NeedChangeTooltip(mouse_pos:NPoint, currentTooltip:NBaseTooltip):Boolean 
		{
			if ( !mDataSourceArray )
			{
				if( currentTooltip )
					return true;
				else
					return false;
			}
			
			var data:* = PointToDataItem( mouse_pos );
			if ( data == null )
			{
				if( currentTooltip )
					return true;	// нужно заменить на "нулевой"
			}
			else
			{
				if ( !currentTooltip )	// тултипа нет
					return true;	// заменить на "ненулевой"
				else
				{
					if ( currentTooltip.Tag != data.uid )
						return true;
				}
			}
			
			return false;
		}
		// ============================================================
		public function PointToDataItem( pos:NPoint ):*
		{
			if ( mDataSourceArray )
			{
				var spos:Number;
				var template_length:Number;
				
				if ( mIsHorizontal )
				{
					spos = pos.x;
					template_length = mMiniatureTemplate.Size.Width;
				}
				else
				{
					spos = pos.y;
					template_length = mMiniatureTemplate.Size.Height;
				}
					
				spos -= mCurrentShift;	// вычтем смещение, чтобы получить координаты относительно первого элемента
				
				var item_index:int = int( spos / (template_length + mSpan) );
				var relPos:Number = spos - item_index * (template_length + mSpan);
				if ( relPos > template_length )	// если попадаем на промежуток
					return null;
				if ( item_index > mDataSourceArray.length )
					return null;
				else
					return mDataSourceArray[item_index];
			}
			else
				return null;
		}
		// ============================================================
	}

}