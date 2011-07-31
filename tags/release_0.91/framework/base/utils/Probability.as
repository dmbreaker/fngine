package base.utils
{
	/**
	 * ...
	 * @author dmBreaker
	 */
	public dynamic class Probability
	{
		// ============================================================
		private var mProbabilities:Vector.<Number>;
		private var mItems:Array;
		private var mMaxProbability:Number;
		
		// ============================================================
		public function Probability( probabilities:Vector.<Number>, items:Array )
		{
			mProbabilities = probabilities;
			mItems = items;
			mMaxProbability = 0;
			
			for each(var num:Number in mProbabilities)
			{
				mMaxProbability += num;
			}
		}
		// ============================================================
		public function GetProbability():*
		{
			var value:Number = Random.getNumber(0, mMaxProbability);
			var cur_prob:Number = 0;
			
			for (var i:int = 0; i < mProbabilities.length; i++)
			{
				cur_prob += Number(mProbabilities[i]);
				if ( value <= cur_prob )
				{
					return mItems[i];
				}
			}
			
			//return mItems[mItems.length-1];	// сюда вроде не должны приходить...
			return null;	// если нет вероятностей
		}
		// ============================================================
		public function HasProbabilities():Boolean
		{
			return (mProbabilities.length > 0);
		}
		// ============================================================
		public function toString():String
		{
			var str:String = "(";
			var count:int = mItems.length;
			
			if ( count > 0 )
				str += "[" + mItems[0] + "," + mProbabilities[0] +"]";
			
			for (var i:int = 1; i < count; i++)
			{
				str += ", [" + mItems[i] + "," + mProbabilities[i] +"]";
			}
			str += ")";
			
			return str;
		}
		// ============================================================
	}
	
}