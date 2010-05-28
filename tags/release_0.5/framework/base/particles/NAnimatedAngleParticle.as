package base.particles
{
	import base.graphics.IGraphix;
	import base.graphics.NAnimatedBitmap;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NAnimatedAngleParticle extends NAngleParticle
	{
		// ============================================================
		public var Image:NAnimatedBitmap;
		// ============================================================
		public function NAnimatedAngleParticle()
		{
			
		}
		// ============================================================
		public function Draw( g:IGraphix, sx:Number, sy:Number ):void
		{
			g.DrawBitmapDataRot( Image.GetNBD(), sx + ScreenPos.x, sy + ScreenPos.y, Alpha, Angle, Scale );
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public override function Quant(diff_ms:int):void
		{
			var step:Number = Number(diff_ms) * RThousand;	// TODO: подумать над тем, как проводить данное вычисление только в одном месте
			//Image.Quant( diff_ms );
			//Angle += AngleSpeed * step;
			AlphaQuant( step );
			AnimationQuant( diff_ms, step );
			SpeedQuant( diff_ms, step );
		}
		// ============================================================
		public function AnimationQuant( diff_ms:Number, step:Number ):void
		{
			Image.Quant( diff_ms );
			Angle += AngleSpeed * step;
		}
		// ============================================================
		public function SpeedQuant( diff_ms:Number, step:Number ):void
		{
			ScreenPos.x += Speed.x * step;
			ScreenPos.y += Speed.y * step;
		}
		// ============================================================
	}
	
}