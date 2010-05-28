package base.pools
{
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class PoolObject implements IPoolObject
	{
		// ============================================================
		protected var IsUsed:Boolean = false;
		// ============================================================
		public function PoolObject() 
		{
			
		}
		
		/* INTERFACE base.statemachine.IPoolObject */

		// ============================================================
		public function get InUse():Boolean
		{
			return IsUsed;
		}
		// ============================================================
		public function Unuse():void
		{
			IsUsed = false;
		}
		// ============================================================
		public function Use():void
		{
			IsUsed = true;
		}
		// ============================================================
	}
	
}