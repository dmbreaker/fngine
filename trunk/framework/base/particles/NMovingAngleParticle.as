package base.particles
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NMovingAngleParticle extends NAnimatedAngleParticle
	{
		// ============================================================
		public function NMovingAngleParticle()
		{
			
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public override function Quant(diff_ms:int):void
		{
			// сдвигаем партикл:
			var step:Number = Number(diff_ms) * RThousand;
			
			AlphaQuant( step );
			AnimationQuant( diff_ms, step );
			
			ScreenPos.x += Speed.x * step;
			ScreenPos.y += Speed.y * step;
		}
		// ============================================================
	}
	
}