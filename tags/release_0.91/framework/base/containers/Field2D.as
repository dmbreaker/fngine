package base.containers
{
	import base.types.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class Field2D
	{
		// ============================================================
		private var mElements:Array;
		private var mColumnsCount:int;
		private var mRowsCount:int;
		private var mElementsCount:int;
		// ============================================================
		public function Field2D( rows:int, columns:int )
		{
			SetDimensions( rows, columns );
		}
		// ============================================================
		public function SetDimensions( rows:int, columns:int ):void
		{
			mRowsCount = rows;
			mColumnsCount = columns;
			mElementsCount = mRowsCount * mColumnsCount;
			
			mElements = new Array( mElementsCount );
		}
		// ============================================================
		public function get Count():int
		{
			return mElementsCount;
		}
		// ============================================================
		public function get RowsCount():int
		{
			return mRowsCount;
		}
		// ============================================================
		public function get ColumnsCount():int
		{
			return mColumnsCount;
		}
		// ============================================================
		public function GetCellIndex( cell:NCell ):int
		{
			return cell.Row * mColumnsCount + cell.Column;
		}
		// ============================================================
		public function GetIndex( row:int, column:int ):int
		{
			return row * mColumnsCount + column;
		}
		// ============================================================
		public function Clear():void
		{
			for( var i:int=0; i<mElementsCount; i++ )
			{
				mElements[i] = null;
			}
		}
		// ============================================================
		public function ForEach( func:Function ):void
		{
			mElements.forEach( function (obj:*, index:int, array:Array):void
			{
				func( obj );
			} );
		}
		// ============================================================
		public function RemoveAll( remove_func:Function ):void
		{
			for (var i:int = 0; i < mElementsCount; i++)
			{
				RemoveInternal( i, remove_func );
			}
		}
		// ============================================================
		public function RemoveByIndex( index:int, remove_func:Function ):void
		{
			RemoveInternal( index, remove_func );
		}
		// ============================================================
		public function RemoveAt( cell:NCell, remove_func:Function ):void
		{
			RemoveByIndex( GetCellIndex( cell ), remove_func );
		}
		// ============================================================
		private function RemoveInternal( index:int, remove_func:Function ):void
		{
			if ( mElements[index] != null )
				if( remove_func != null )
					remove_func( mElements[index] );
			mElements[index] = null;
		}
		// ============================================================
		public function SetEach( value:* ):void
		{
			for (var i:int = 0; i < mElementsCount; i++)
			{
				mElements[i] = value;
			}
		}
		// ============================================================
		public function HasElementAtIndex( index:int ):Boolean
		{
			return (mElements[index] != null);
		}
		// ============================================================
		public function HasElementAt( cell:NCell ):Boolean
		{
			return HasElementAtIndex( GetCellIndex(cell) );
		}
		// ============================================================
		public function GetElementAt( cell:NCell ):*
		{
			return GetElementAtIndex( GetCellIndex(cell) );
		}
		// ============================================================
		public function GetElementAtIndex( index:int ):*
		{
			return mElements[index];
		}
		// ============================================================
		public function At( index:int ):*
		{
			return mElements[index];
		}
		// ============================================================
		/**
		 *  Специальная функция для быстрой работы с int-array
		 * @param	index
		 * @return
		 */
		public function intAt( index:int ):int
		{
			return int(mElements[index]);
		}
		// ============================================================
		public function intAtCell( cell:NCell ):int
		{
			return int(mElements[ GetCellIndex(cell) ]);
		}
		// ============================================================
		/**
		 *  Специальная функция для быстрой работы с Boolean-array
		 * @param	index
		 * @return
		 */
		public function BooleanAt( index:int ):Boolean
		{
			return Boolean(mElements[index]);
		}
		// ============================================================
		public function BooleanAtCell( cell:NCell ):Boolean
		{
			return Boolean(mElements[ GetCellIndex(cell) ]);
		}
		// ============================================================
		public function SetElementAt( cell:NCell, element:* ):void
		{
			SetElementAtIndex( GetCellIndex(cell), element );
		}
		// ============================================================
		public function SetElementAtIndex( index:int, element:* ):void
		{
			mElements[index] = element;
		}
		// ============================================================
		// ============================================================
		public function MoveElement( cell:NCell, move:NCell ):*
		{
		//#ifdef _DEBUG
			//if( NULL != mElements[x+x_shift][y+y_shift] )
				//_ASSERT_EXPR(0);	// нельзя перемещать элемент в непустую позицию
//
			//if( x+x_shift < 0 || x+x_shift >= COLUMNS )
				//_ASSERT_EXPR(0);
//
			//if( y+y_shift < 0 || y+y_shift >= (ROWS-1) )
				//_ASSERT_EXPR(0);
		//#endif
			var shifted_cell:NCell = cell.GetShifted( move );
			if ( IsCellExist( cell ) && IsCellExist( shifted_cell ) )
			{
				var element:* = GetElementAt( cell );
				SetElementAt( cell.GetShifted(move), element );
				SetElementAt( cell, null );					// старую позицию освобождаем
				//element.CellPosition.AddShift( shift );
				return element;
			}
			else
			{
				var err:String = "### ERROR: cell is out of range -> cell:" + cell.toString() + " scell:" + shifted_cell.toString();
				trace( err );
				throw new Error( err );
				return null;
			}
		}
		// ============================================================
		public function IsCellExist( cell:NCell ):Boolean
		{
			return (cell.Row >= 0 && cell.Row < mRowsCount) && (cell.Column >= 0 && cell.Column < mColumnsCount);
		}
		// ============================================================
		/**
		 * Сдвигает элементы вверх на одну строку (верхняя строка в dev/null)
		 * @param	elementReinit function( obj:*, new_cell:NCell, old_cell:NCell ):void
		 */
		public function SlideLinesUp( elementReinit:Function = null ):void
		{
			var shifted_el:*;
			var cell:NCell = new NCell();
			var scell:NCell;
			
			for( var j:int=1; j<mRowsCount; j++ )
			{
				for( var i:int=0; i<mColumnsCount; i++ )
				{
					cell.Init( j, i );
					scell = cell.GetShiftedByRow( -1);
					shifted_el = GetElementAt( cell );
					SetElementAt( scell, shifted_el );
					if( shifted_el != null && elementReinit != null )
					{
						elementReinit( shifted_el, scell, cell );	// ( object, new_cell, old_cell )
					}

					SetElementAt( cell, null );
				}
			}
		}
		// ============================================================
		public function DecreaseInt( subtract:int ):void
		{
			for (var i:int = 0; i < mElementsCount; i++)
			{
				var value:int = int(mElements[i]);
				if ( value > 0 )
				{
					value -= subtract;
					if ( value < 0 ) value = 0;
					mElements[i] = value;
				}
			}
		}
		// ============================================================
		/*
		 * Грязно, но быстро - эта функция заточена специально под удаляемые объекты
		 */
		public function DecreaseRemoving( subtract:int ):void
		{
			for (var i:int = 0; i < mElementsCount; i++)
			{
				var imgEl:* = mElements[i];
				if( imgEl )
				{
					imgEl.value -= subtract;
					if ( imgEl.value < 0 ) mElements[i] = null;
				}
			}
		}
		// ============================================================
		// ============================================================
	}
	
}