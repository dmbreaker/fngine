package base.effects
{
	import base.graphics.BitmapGraphix;
	import base.particles.NAnimatedParticle;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class SimpleEffect extends NEffect
	{
		private var mParticle:NAnimatedParticle;
		// ============================================================
		public function SimpleEffect(posX:Number, posY:Number)
		{
			super( posX, posY );
			mParticle = new NAnimatedParticle();
			mParticle.Image = RM.GetAnimation( "test_anim" );
		}
		// ============================================================
		protected override function InternalQuant( diff_ms:int ):void
		{
			mParticle.Quant( diff_ms );
		}
		// ============================================================
		protected override function InternalDraw( g:BitmapGraphix ):void
		{
			mParticle.Draw( g, Pos.x, Pos.y );
		}
		// ============================================================
		// ============================================================
	}
	
}