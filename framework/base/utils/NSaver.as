package base.utils
{
	import flash.net.SharedObject;
	
	/**
	 * Данный класс отвечает за сохранение/загрузку данных локально
	 * @author dmBreaker
	 */
	public class NSaver 
	{
		// ============================================================
		private var mSO:SharedObject;
		private var mIsInited:Boolean = false;
		// ============================================================
		public function NSaver()
		{
		}
		// ============================================================
		public function Init( soName:String ):void 
		{
			mSO = SharedObject.getLocal( soName );
			mIsInited = true;
		}
		// ============================================================
		public function Get( dataName:String ):*
		{
			CheckInited();
			
			if ( mSO && mSO.size > 0 )
			{
				return mSO.data[dataName];
			}
			
			return null;
		}
		// ============================================================
		public function Save( dataName:String, value:* ):void 
		{
			CheckInited();
			
			if ( mSO )
			{
				mSO.data[dataName] = value;
				mSO.flush();
			}
		}
		// ============================================================
		public function Remove( soName:String ):void
		{
			//mSO = SharedObject.getLocal( soName );
			mSO.clear();
			mSO = null;
		}
		// ============================================================
		public function RemoveData( dataName:String ):void
		{
			CheckInited();
			
			if ( mSO )
			{
				mSO.data[dataName] = undefined;
				mSO.flush();
			}
		}
		// ============================================================
		private function CheckInited():void
		{
			if ( !mIsInited )
			{
				throw Error("NSaver was not initialized (need to call 'Init(path)' before use)");
			}
		}
		// ============================================================
	}
	
}