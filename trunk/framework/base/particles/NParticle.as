package base.particles
{
	import base.graphics.IGraphix;
	import base.graphics.NAnimatedBitmap;
	import base.graphics.NBitmapData;
	import base.modelview.IQuant;
	import base.types.*;
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NParticle implements IQuant
	{
		// ============================================================
		protected static const RThousand:Number = 1 / 1000;
		// ============================================================
		public var ScreenPos:NPoint = new NPoint();	// позиция на экране
		
		public var Pos:NVec = new NVec();			// виртуальная 3D-позиция (если используется)
		public var Speed:NVec = new NVec();
		public var PrevSpeed:NVec = new NVec();
		
		public var Scale:Number = 1;
		public var ScaleDecreasingSpeed:Number = 0;
		
		//public var Angle:Number = 0;
		//public var AngleSpeed:Number = 0;
		//public var PrevAngleSpeed:Number = 0;
		
		public var Alpha:Number = 1;
		public var AlphaDecreasingSpeed:Number = 0;	/// на сколько альфа должна уменьшиться за секунду
		
		// ============================================================
		public function NParticle()
		{
		}
		// ============================================================
		/* INTERFACE base.modelview.IQuant */
		public function Quant(diff_ms:int):void
		{
			var step:Number = Number(diff_ms) * RThousand;
			
			AlphaQuant( step );
		}
		// ============================================================
		public function AlphaQuant( step:Number ):void
		{
			Alpha -= AlphaDecreasingSpeed * step;
			if ( Alpha < 0 )
				Alpha = 0;
				
			Scale -= ScaleDecreasingSpeed * step;
			if ( Scale < 0.0001 )
				Scale = 0.0001;
		}
		// ============================================================
	}
	
}