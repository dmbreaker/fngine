package base.particles
{
	import base.graphics.BitmapGraphix;
	import base.types.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NGravityParticle3D extends NAnimatedAngleParticle
	{
		// ============================================================
		public var GravityF:Number = 10;
		//public var DecrementForce:NVec = new NVec();	// подгоночное значение
		// ============================================================
		public function NGravityParticle3D()
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
			DecrementSpeedQuant( step );
			
			Pos.OffsetMul( Speed, step );
		}
		// ============================================================
		public function GravityQuant( step:Number ):void
		{
			Speed.y += GravityF * step;
		}
		// ============================================================
		public function DecrementSpeedQuant( step:Number ):void
		{
			Speed.AddLengthLowNormalized( -200 * step, 10 );
		}
		// ============================================================
		public override function Draw( g:BitmapGraphix, sx:Number, sy:Number ):void
		{
			//Scale = 0.5 + ((50 - Pos.z) / 50);//!!!temp
			if ( Scale < 0 ) Scale = 0;
			
			Pos.CopyTo2D( ScreenPos );	// сконвертируем в экранные координаты
			super.Draw( g, sx, sy );
		}
		// ============================================================
	}
	
}