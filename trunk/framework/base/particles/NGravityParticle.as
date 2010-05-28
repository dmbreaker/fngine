package base.particles
{
	import base.types.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NGravityParticle extends NAnimatedAngleParticle
	{
		// ============================================================
		public var GravityF:Number = 1;
		//public var DecrementForce:NVec = new NVec();	// подгоночное значение
		// ============================================================
		public function NGravityParticle()
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
			GravityQuant( step );
			//DecrementSpeedQuant( step );
			
			ScreenPos.x += Speed.x * step;
			ScreenPos.y += Speed.y * step;
		}
		// ============================================================
		public function GravityQuant( step:Number ):void
		{
			Speed.y += GravityF * step;
		}
		// ============================================================
	}
	
}