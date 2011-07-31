package base.pools
{
	import base.containers.BitArray;
	
	/**
	 * пул-объектов.
	 *
	 * @author dmBreaker
	 */
	public class NObjectsPool
	{
		// ============================================================
		protected var mObjectsCount:int;
		protected var mObjects:Array = null;
		protected var mObjectsUsed:BitArray = null;
		
		//public var mDebugCounter:int = 0;

		protected var mObjClass:Class = null;
		// ============================================================
		public function NObjectsPool( count:int, objClass:Class )
		{
			Reinit( count, objClass );
		}
		// ============================================================
		public function Reinit( count:int, objClass:Class ):void
		{
			if ( mObjects != null )
			{
				
			}
			
			mObjects = new Array( count );
			mObjectsUsed = new BitArray( count, BitArray.BITS_PER_ITEM_8 );
			mObjectsUsed.SetAll( false );
			mObjectsCount = count;
			mObjClass = objClass;
			
			for (var i:int = 0; i < mObjectsCount; i++)
			{
				var obj:* = new objClass();
				mObjects[i] = obj;
			}
		}
		// ============================================================
		public function get Obj():*
		{
			var free_index:int = mObjectsUsed.IndexOfFalse();
			if ( free_index != -1 )
			{
				mObjectsUsed.Set( free_index, true );
				//++mDebugCounter;
				//trace( "Pool:", mDebugCounter );
				return mObjects[free_index];
			}
			else
			{
				throw new Error( "No free objects was found in ObjectPool" );
				return null;
			}
		}
		// ============================================================
		public function set Obj( obj:* ):void
		{
			for (var i:int = 0; i < mObjectsCount; i++)
			{
				if ( mObjects[i] === obj )	// is it correct?
				{
					//--mDebugCounter;
					//trace( "Pool:", mDebugCounter );
					mObjectsUsed.Set( i, false );
					return;
				}
			}
			
			// throw new Error( "Object was not found in ObjectPool" );
		}
		// ============================================================
		//public function GetFirstIndex():int
		//{
			//return mObjectsUsed.IndexOfTrue();
		//}
		// ============================================================
		//public function GetNextIndex( index:int ):int
		//{
			//
		//}
		// ============================================================
	}
	
}