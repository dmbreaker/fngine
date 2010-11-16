package base.utils 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class FastMath
	{
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
			if(x < -3.14159265)
				x += 6.28318531;
			else if(x > 3.14159265)
				x -= 6.28318531;

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
			if(x < -3.14159265)
				x += 6.28318531;
			else if(x > 3.14159265)
				x -= 6.28318531;

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
			if(x < -3.14159265)
				x += 6.28318531;
			else if(x > 3.14159265)
				x -= 6.28318531;

			//compute sine
			if (x < 0)
				return x * (1.27323954 + .405284735 * x);
			else
				return x * (1.27323954 - 0.405284735 * x);
		}
		// ============================================================
		public function FFCosine( x:Number ):Number
		{
			//compute cosine: sin(x + PI/2) = cos(x)
			x += 1.57079632;
			if(x > 3.14159265)
				x -= 6.28318531;

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
	}

}