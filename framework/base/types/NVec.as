package base.types
{
	
	/**
	 * ...
	 * @author dmBreaker
	 */
	public class NVec
	{
		// ============================================================
		//public static const KX:Number = 5.5 / 100;
		public static const KX:Number = 5;
		//public static const KY:Number = 1 / 100;
		public static const KY:Number = 5;
		//public static const KZ:Number = 0.3;
		public static const KZ:Number = 0.0125;
		
		
		private static const RotateXZ:Number = Math.PI*0.5;
		private static const RotateXY:Number = -Math.PI;
		// ============================================================
		public var x:Number;
		public var y:Number;
		public var z:Number;
		// ============================================================
		public function NVec( cx:Number=0, cy:Number=0, cz:Number=0 )
		{
			Set( cx, cy, cz );
		}
		// ============================================================
		public function Set( cx:Number=0, cy:Number=0, cz:Number=0 ):void
		{
			x = cx;
			y = cy;
			z = cz;
		}
		// ============================================================
		public function Reset():void
		{
			x = y = z = 0;
		}
		// ============================================================
		public function Copy( src:NVec ):void
		{
			x = src.x;
			y = src.y;
			z = src.z;
		}
		// ============================================================
		public function Clone():NVec
		{
			return new NVec( x, y, z );
		}
		// ============================================================
		public function SetVec2D( value:Number, angle:Number ):void
		{
			x = value * Math.cos( angle );	// TODO: заменить быстрыми аппроксимациями
			y = value * Math.sin( angle );
		}
		// ============================================================
		public function SetVec3D( value:Number, angleXY:Number, angleXZ:Number ):void
		{
			angleXY += RotateXY;	// чтобы "повернуть" угол в самый верх
			angleXZ += RotateXZ;	// чтобы "повернуть" угол в плоскость экрана
			
			x = value * Math.sin(angleXY) * Math.sin(angleXZ)	// TODO: заменить быстрыми аппроксимациями
			y = value * Math.cos(angleXY);
			z = value * Math.sin(angleXY) * Math.cos(angleXZ)
		}
		// ============================================================
		public function RotateZ( angle:Number ):void
		{
			var nx:Number = x * Math.cos( angle ) - y * Math.sin( angle );	// TODO: заменить быстрыми аппроксимациями
			var ny:Number = x * Math.sin( angle ) + y * Math.cos( angle );
			
			x = nx;
			y = ny;
		}
		// ============================================================
		public function OffsetMul( vec:NVec, multiplier:Number = 1 ):void
		{
			x += vec.x * multiplier;
			y += vec.y * multiplier;
			z += vec.z * multiplier;
		}
		// ============================================================
		public function CopyTo2D( dest:NPoint ):void
		{
			var dist:Number = 1 + KZ * z;
			var w:Number = 1 / dist;
			if ( dist <= 0 )	// если вдруг объект "за затылком игрока"
			{
				/* сюда попадать не должны! */
				dest.x = KX * x * w;
				dest.y = KY * y * w;
				//trace( "BUG" );
			}
			else
			{
				dest.x = KX * x * w;
				dest.y = KY * y * w;
			}
		}
		// ============================================================
		public function Multiply( multiplier:Number ):void
		{
			x *= multiplier;
			y *= multiplier;
			z *= multiplier;
		}
		// ============================================================
		public function MultiplyXY( mulX:Number, mulY:Number ):void
		{
			x *= mulX;
			y *= mulY;
		}
		// ============================================================
		public function AddLength( length:Number ):void
		{
			var curLength:Number = GetLength();
			NormilizeByLength( curLength );
			Multiply( curLength + length );
		}
		// ============================================================
		public function AddLengthLowNormalized( length:Number, minLength:Number = 0 ):void
		{
			var curLength:Number = GetLength();
			var newLength:Number = curLength + length;
			if ( newLength < minLength )
				return;
				
			NormilizeByLength( curLength );
			Multiply( newLength );
		}
		// ============================================================
		public function NormilizeByLength( length:Number ):void
		{
			var rlength:Number = 1 / length;
			x *= rlength;
			y *= rlength;
			z *= rlength;
		}
		// ============================================================
		public function GetLength():Number
		{
			return Math.sqrt( x * x + y * y + z * z );
		}
		// ============================================================
		public function CopyFromMultiplied( src:NVec, multiplier:Number ):void 
		{
			x = src.x * multiplier;
			y = src.y * multiplier;
			z = src.z * multiplier;
		}
		// ============================================================
		public function toString():String
		{
			return "[NVec: x=" + x + ",y=" + y + ",z=" + z + "]";
		}
		// ============================================================
		public function CopyPoint( pnt:NPoint ):void 
		{
			x = pnt.x;
			y = pnt.y;
		}
		// ============================================================
	}
	
}