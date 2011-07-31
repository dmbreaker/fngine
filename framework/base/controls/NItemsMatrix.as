package base.controls 
{
	import base.core.NCore;
	import base.externals.bulkloader.BulkLoader;
	import base.externals.bulkloader.loadingtypes.LoadingItem;
	import base.graphics.BitmapGraphix;
	import base.graphics.NBitmapData;
	import base.types.NGridSize;
	import base.types.NPoint;
	import base.types.NRect;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NItemsMatrix extends Control
	{
		// ============================================================
		public static const evtItemClicked:String = "itemclicked";
		// ============================================================
		private var mPagesCount:int = 0;
		private var mCurrentPage:int = 0;
		private var mHorSpan:Number = 4;	// расстояние между миниатюрами
		private var mVerSpan:Number = 4;	// расстояние между миниатюрами
		
		private var mBuff:NBitmapData;
		private var mNeedRedraw:Boolean = true;
		
		private var mCellsSize:NGridSize = new NGridSize();
		private var mItems:Array;
		
		private var mTemplate:NMiniature = new NMiniature();
		
		private var mAllImagesLoaded:Boolean = false;
		// ============================================================
		private var mLoader:BulkLoader;
		// ============================================================
		public function NItemsMatrix( name:String ) 
		{
			super(name);
			mLoader = new BulkLoader( name + "images_matrix", BulkLoader.DEFAULT_NUM_CONNECTIONS );
		}
		// ============================================================
		public function Init( columns:int, rows:int, items:Array, template:NMiniature = null ):void
		{
			mCellsSize.Init( rows, columns );
			mItems = items;
			StartImagesLoading();	// загрузка изображений, если необходимо
			mPagesCount = mItems.length / mCellsSize.CellsCount;
			if ( (mItems.length % mCellsSize.CellsCount) > 0 )
				++mPagesCount;
				
			if ( mCurrentPage >= mPagesCount )
				mCurrentPage = mPagesCount - 1;
			if ( mCurrentPage < 0 )
				mCurrentPage = 0;
				
			if ( template )
				mTemplate = template;
				
			// нужно пересчитать SPAN'ы для контрола:
			RecalculateSpans()

			mAllImagesLoaded = false;
			Invalidate();
		}
		// ============================================================
		private function RecalculateSpans():void
		{
			mHorSpan = (Rect.Width - (mTemplate.Size.Width * mCellsSize.Columns)) / (mCellsSize.Columns + 1);
			mVerSpan = (Rect.Height - (mTemplate.Size.Height * mCellsSize.Rows)) / (mCellsSize.Rows + 1);
		}
		// ============================================================
		public function get Template():NMiniature
		{
			return mTemplate;
		}
		// ============================================================
		public function set Template( t:NMiniature ):void 
		{
			mTemplate = t;
			RecalculateSpans();
			Invalidate();
		}
		// ============================================================
		public function get HorSpan():int
		{
			return mHorSpan;
		}
		// ============================================================
		public function set HorSpan( value:int ):void
		{
			mHorSpan = value;
			Invalidate();
		}
		// ============================================================
		public function get VerSpan():int
		{
			return mVerSpan;
		}
		// ============================================================
		public function set VerSpan( value:int ):void
		{
			mVerSpan = value;
			Invalidate();
		}
		// ============================================================
		public function get PagesCount():int
		{
			return mPagesCount;
		}
		// ============================================================
		public function SetPage( index:int ):void 
		{
			if ( index >= 0 && index < mPagesCount )
			{
				mCurrentPage = index;
				Invalidate();
			}
		}
		// ============================================================
		public function PrevPage():void 
		{
			--mCurrentPage;
			if ( mCurrentPage < 0 )
				mCurrentPage = 0;
			Invalidate();
		}
		// ============================================================
		public function NextPage():void
		{
			++mCurrentPage;
			if ( mCurrentPage >= mPagesCount && mPagesCount >= 1 )
				mCurrentPage = mPagesCount - 1;
			
			if( mPagesCount == 0 )
				mCurrentPage = 0;
			Invalidate();
		}
		// ============================================================
		public function FirstPage():void
		{
			mCurrentPage = 0;
			Invalidate();
		}
		// ============================================================
		public function LastPage():void 
		{
			if ( mPagesCount > 1 )
			{
				mCurrentPage = mPagesCount - 1;
				Invalidate();
			}
		}
		// ============================================================
		public function Invalidate():void 
		{
			mNeedRedraw = true;
		}
		// ============================================================
		override public function Resize(w:int, h:int):void 
		{
			super.Resize(w, h);
			if ( !Rect.Size.IsEmpty )
			{
				if ( mBuff )
					mBuff.dispose();
				mBuff = new NBitmapData( w, h );
			}
			
			RecalculateSpans();
			Invalidate();
		}
		// ============================================================
		protected function TryRedraw():void 
		{
			if ( mNeedRedraw )
			{
				mNeedRedraw = false;
				
				var r:NRect = new NRect(0, 0, Rect.Width, Rect.Height);
				mBuff.FillNRect( r, 0xff323232 );	// рисуем бэк
				if ( mPagesCount > 0 )
				{
					var j:int = 0;
					var i:int = 0;
					var k:int = mCurrentPage * mCellsSize.CellsCount;
					var count:int = (mCurrentPage + 1) * mCellsSize.CellsCount;
					if ( count > mItems.length )
						count = mItems.length;
						
					for ( ; k < count; k++ )
					{
						var data:* = mItems[k];
						
						//if ( j < mCellsSize.Rows )
						{
							if ( i >= mCellsSize.Columns )
							{
								++j;
								i = 0;
							}
							//trace( "---" );
							var cx:Number = mHorSpan + i * (mTemplate.Size.Width + mHorSpan);
							var cy:Number = mVerSpan + j * (mTemplate.Size.Height + mVerSpan);
							mTemplate.Draw( mBuff, cx, cy, data );
							
							//trace( cx, cy );
							
							++i;
						}
					}
				}
			}
		}
		// ============================================================
		override public function OnMouseUp(x:Number, y:Number):void 
		{
			var data:* = PointToDataItem( new NPoint(x, y) );
			if ( data )
			{
				DispatchNotification( evtItemClicked, data );
			}
		}
		// ============================================================
		override public function get HandCursor():Boolean
		{
			//return super.HandCursor;
			var pnt:NPoint = new NPoint();
			pnt.CopySubtraction( ParentScene.WidgetsManagerObj.GlobalMousePos, Rect.Position );
			var data:* = PointToDataItem( pnt );
			if( data )
				return true;
			else
				return false;
		}
		// ============================================================
		override public function Draw(g:BitmapGraphix, diff_ms:int):void 
		{
			if ( Need_InvalidateNotLoaded( diff_ms ) )
				Invalidate();	// чтобы выставить флаг о перерисовке
			
			TryRedraw();		// фактическая перерисовка контрола в буфер
			g.DrawImageFast( mBuff, 0, 0 );
		}
		// ============================================================
		// ============================================================
		private const CHECK_PERIOD_MS:int = 100;
		private var checkTicks:int = 0;
		// TODO: попробовать выделить этот и другие методы в класс LoadingImagesControl
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
				for each( var data:* in mItems )
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
		private function StartImagesLoading():void
		{
			if ( mItems && mItems.length > 0 )
			{
				mLoader.removeAll();
				var myContext:LoaderContext = new LoaderContext(); 
				myContext.checkPolicyFile = true;
				
				for each( var item:* in mItems )
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
			NCore.Trace( "ImagetMatrix.BulkLoader error: " + e.text );
		}
		// ============================================================
		
		// ============================================================
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// ============================================================
		/*override public function get NeedTooltip():Boolean
		{
			if( mItems )
				return true;
			else
				return false;
				
			//return false;
		}
		// ============================================================
		override public function GetTooltip(mouse_pos_local:NPoint):NBaseTooltip 
		{
			if ( !mItems )
				return null;
			
			var data:* = PointToDataItem( mouse_pos_local );
			if ( data == null )	// если не указывает ни на один из элементов
				return null;
			else
			{
				var tt:NMultilineTooltip = NMultilineTooltip.Instance;
				tt.Tag = data.uid;	// ОБЯЗАТЕЛЬНО! Чтобы различать элементы позже
				tt.InitData( [data.name, data.score] );
				return tt;
			}
		}
		// ============================================================
		override public function NeedChangeTooltip(mouse_pos_local:NPoint, currentTooltip:NBaseTooltip):Boolean 
		{
			if ( !mItems )
			{
				if( currentTooltip )
					return true;
				else
					return false;
			}
			
			var data:* = PointToDataItem( mouse_pos_local );
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
		}*/
		// ============================================================
		public function PointToDataItem( pos:NPoint ):*
		{
			if ( mItems )
			{
				if ( mPagesCount > 0 )
				{
					var j:int = 0;
					var i:int = 0;
					var k:int = mCurrentPage * mCellsSize.CellsCount;
					var count:int = (mCurrentPage + 1) * mCellsSize.CellsCount;
					if ( count > mItems.length )
						count = mItems.length;
						
					for ( ; k < count; k++ )
					{
						var data:* = mItems[k];
						
						//if ( j < mCellsSize.Rows )
						{
							if ( i >= mCellsSize.Columns )
							{
								++j;
								i = 0;
							}
							
							var cx:Number = mHorSpan + i * (mTemplate.Size.Width + mHorSpan);
							var cy:Number = mVerSpan + j * (mTemplate.Size.Height + mVerSpan);
							
							if ( pos.x >= cx && pos.x < (cx+mTemplate.Size.Width) )
								if ( pos.y >= cy && pos.y < (cy + mTemplate.Size.Height) )
									return data;

							++i;
						}
					}
				}
				
			}
			
			return null;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
	}

}