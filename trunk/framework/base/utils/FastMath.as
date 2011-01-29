package base.utils 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class FastMath
	{
		// ============================================================
		public static const ToRad:Number = Math.PI / 180.0;
		public static const ToAngle:Number = 180.0 / Math.PI;
		public static const AlphaNormalize:Number = 1.0 / 255.0;
		// ============================================================
		public const PI:Number = Math.PI;
		public const PI2:Number = Math.PI * 2;
		public const HalfPI:Number = Math.PI * 0.5;
		
		public const InvPI:Number = 1.0 / Math.PI;
		public const InvPI2:Number = 1.0 / (Math.PI * 2.0);
		public const InvHalfPI:Number = 1.0 / (Math.PI * 0.5);
		
		public const ToRad:Number = Math.PI / 180.0;
		public const ToAngle:Number = 180.0 / Math.PI;
		public const AlphaNormalize:Number = 1.0 / 255.0;
		// ============================================================
		// ============================================================
		public function FastMath() 
		{
			
		}
		// ============================================================
		public function FSine( x:Number ):Number 
		{
			var sin:Number;
			//	//always wrap input angle to -PI..PI
			while(x < -PI)
				x += PI2;

			while(x > PI)
				x -= PI2;

			//compute sine
			if (x < 0)
			{
				sin = x * (1.27323954 + 0.405284735 * x);

				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}
			else
			{
				sin = x * (1.27323954 - 0.405284735 * x);

				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}

			return sin;
		}
		// ============================================================
		public function FCosine( x:Number ):Number 
		{
			while(x < -PI)
				x += PI2;

			while(x > PI)
				x -= PI2;
			
			var cos:Number;
			//compute cosine: sin(x + PI/2) = cos(x)
			x += 1.57079632;
			if(x > 3.14159265)
				x -= 6.28318531;

			if (x < 0)
			{
				cos = x * (1.27323954 + 0.405284735 * x);

				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			else
			{
				cos = x * (1.27323954 - 0.405284735 * x);

				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			
			return cos;
		}
		// ============================================================
		public function FSinCos( x:Number, result:TwoNumbers ):void 
		{
			var sin:Number;
			//	//always wrap input angle to -PI..PI
			while(x < -PI)
				x += PI2;

			while(x > PI)
				x -= PI2;

			//compute sine
			if (x < 0)
			{
				sin = x * (1.27323954 + 0.405284735 * x);

				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}
			else
			{
				sin = x * (1.27323954 - 0.405284735 * x);

				if (sin < 0)
					sin = .225 * (sin *-sin - sin) + sin;
				else
					sin = .225 * (sin * sin - sin) + sin;
			}
			
			var cos:Number;
			//compute cosine: sin(x + PI/2) = cos(x)
			x += 1.57079632;
			if(x > 3.14159265)
				x -= 6.28318531;

			if (x < 0)
			{
				cos = x * (1.27323954 + 0.405284735 * x);

				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			else
			{
				cos = x * (1.27323954 - 0.405284735 * x);

				if (cos < 0)
					cos = .225 * (cos *-cos - cos) + cos;
				else
					cos = .225 * (cos * cos - cos) + cos;
			}
			
			result.First = sin;
			result.Second = cos;
		}
		// ============================================================
		public function FFSine( x:Number ):Number 
		{
			//always wrap input angle to -PI..PI
			while(x < -PI)
				x += PI2;

			while(x > PI)
				x -= PI2;

			//compute sine
			if (x < 0)
				return x * (1.27323954 + .405284735 * x);
			else
				return x * (1.27323954 - 0.405284735 * x);
		}
		// ============================================================
		public function FFCosine( x:Number ):Number
		{
			while(x < -PI)
				x += PI2;

			while(x > PI)
				x -= PI2;
			
			//compute cosine: sin(x + PI/2) = cos(x)
			x += 1.57079632;
			if(x > PI)
				x -= PI2;

			if (x < 0)
				return x * (1.27323954 + 0.405284735 * x);
			else
				return x * (1.27323954 - 0.405284735 * x);
		}
		// ============================================================
		public function SinCos( x:Number, result:TwoNumbers ):void 
		{
			result.First = Math.sin(x);
			result.Second = Math.cos(x);
		}
		// ============================================================
		// ============================================================
		// ============================================================
		public static const Instance:FastMath = new FastMath();
		// ============================================================
	}

}