package base.pools
{
	
	/**
	 * Совсем простой пул-объектов.
	 * 
	 * Необходимо переделать на более совершенный:
	 * var pnt:Point = pool.instance;	// взяли объект из пула
	 * pool.instance = pnt;	// вернули объект в пул
	 * Избавиться от класса PoolObject
	 * 
	 * @author dmBreaker
	 */
	public class ObjectsPool 
	{
		// ============================================================
		protected var mObjectsCount:int;
		protected var mObjects:Array = null;

		protected var mObjClass:Class = null;
		// ============================================================
		public function ObjectsPool( count:int, objClass:Class )
		{
			Reinit( count, objClass );
		}
		// ============================================================
		public function Reinit( count:int, objClass:Class ):void 
		{
			if ( mObjects != null )
			{
				
			}

			var test:PoolObject = new objClass() as PoolObject;
			if ( test == null )
			//if ( objClass != PoolObject )
			{
				var txt:String = "### ERROR: Object must been inherited from PoolObject";
				trace( txt );
				throw new Error( txt );
				return;
			}
			
			mObjects = new Array( count );
			mObjectsCount = count;
			mObjClass = objClass;
			
			for (var i:int = 0; i < mObjectsCount; i++) 
			{
				var obj:PoolObject = new objClass();
				mObjects[i] = obj;
				EachPoolObjectResetState( obj );
				obj.Unuse();
			}
		}
		// ============================================================
		public function ResetObjectsState():void 
		{
			var pool_obj:PoolObject;
			for (var i:int = 0; i < mObjectsCount; i++) 
			{
				pool_obj = PoolObject(mObjects[i]);
				EachPoolObjectResetState( pool_obj );
				pool_obj.Unuse();
			}
		}
		// ============================================================
		protected function EachPoolObjectResetState( obj:PoolObject ):void 
		{
		}
		// ============================================================
		public function GetFreeObject():PoolObject
		{
			var index:int;
			var obj:PoolObject;

			for (var i:int = 0; i < mObjectsCount; i++) 
			{
				obj = PoolObject(mObjects[i]);
				if ( !obj.InUse )
				{
					obj.Use();
					return obj;
				}
			}
			
			var txt:String = "### ERROR: No more free pool-objects (try to incre pool-size)";
			trace( txt );
			throw new Error( txt );
			return null;	// сюда доходить не должны
		}
		// ============================================================
	}
	
}