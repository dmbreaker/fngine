package base.modelview
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public final class QuantgetsHolder extends QuantgetContainer
	{
		// ============================================================
		public function QuantgetsHolder()
		{
			
		}
		// ============================================================
		public function Quant( diff_ms:int ):void
		{
			InternalQuant( diff_ms );
		}
		// ============================================================
		public function PrecisionQuant( diff_ms:int ):void
		{
			InternalPrecisionQuant( diff_ms );
		}
		// ============================================================
	}
	
}