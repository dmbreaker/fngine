package base.modelview
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	internal class QuantgetContainer extends ItemsContainer
	{
		// ============================================================
		// ============================================================
		public function QuantgetContainer()
		{
			
		}
		// ============================================================
		public final function AddQuantget( quantget:IQuantget ):void
		{
			AddItem( quantget );
			quantget.OnAdded();
		}
		// ============================================================
		public final function RemoveQuantget( quantget:IQuantget ):void
		{
			quantget.OnRemoving();
			Quantget(quantget).RemoveAll();
			RemoveItem( quantget );
		}
		// ============================================================
		internal function InternalQuant( diff_ms:int ):void
		{
			if ( HasItems )
			{
				ForEach( function ( obj:* ):void
				{
					Quantget(obj).InternalQuant( diff_ms );
				} );
			}
		}
		// ============================================================
		internal function InternalPrecisionQuant( diff_ms:int ):void
		{
			if ( HasItems )
			{
				ForEach( function ( obj:* ):void
				{
					Quantget(obj).InternalPrecisionQuant( diff_ms );
				} );
			}
		}
		// ============================================================
		public function RemoveAll():void
		{
			ForEach( function ( obj:* ):void
			{
				var quantget:Quantget = Quantget(obj);
				RemoveQuantget( quantget );
			} );
		}
		// ============================================================
	}
	
}