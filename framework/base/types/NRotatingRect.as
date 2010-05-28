package base.types 
{
	import flash.geom.Point;
	import game.collisions.BallCollision;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NRotatingRect
	{
		// ============================================================
		public var FirstPoint:NPoint;
		public var LastPoint:NPoint;
		public var HalfHeight:Number = 1;
		public var Distance:Number;
		public var SpeedDirection:NVec;
		
		protected var mInvDistance:Number;
		protected var mCos:Number;
		protected var mSin:Number;
		
		// ============================================================
		public function NRotatingRect()
		{
			
		}
		// ============================================================
		public function Init( first:NPoint, last:NPoint, halfHeight:Number, speedDirection:NVec, dist:Number = -1 ):void 
		{
			FirstPoint = first;
			LastPoint = last;
			HalfHeight = halfHeight;
			
			SpeedDirection = speedDirection;
			
			if ( dist >=  0 )
				Distance = dist;
			else
				Distance = LastPoint.CalcDistanceTo( FirstPoint );
				
			// r not used here
		}
		// ============================================================
		public static function RotatePoint( pnt:Point, result:NPoint, cos:Number, sin:Number ):void
		{
			result.x = pnt.x * cos - pnt.y * sin;
			result.y = pnt.x * sin + pnt.y * cos;
		}
		// ============================================================
		protected static function Abs( number:Number ):Number
		{
			return (number >= 0) ? number : -number;
		}
		// ============================================================
		/*public static function RotateXOnly( pnt:NPoint, cos:Number, sin:Number ):Number
		{
			return pnt.x*сos - pnt.y*sin;
		}*/
		// ============================================================
		public static function RotatePointBack( pnt:Point, result:NPoint, cos:Number, sin:Number ):void
		{
			result.x = pnt.x * cos + pnt.y * sin;
			result.y = -pnt.x * sin + pnt.y * cos;
		}
		// ============================================================
		public function Precalculate():void
		{
			//var diff:Point = FirstPoint.subtract( LastPoint );
			var diff:Point = LastPoint.subtract( FirstPoint );
			mInvDistance = 1 / Distance;	// TODO: либо проверку на НЕ НОЛЬ добавить, либо исключить эту ситуацию
			mCos = diff.x * mInvDistance;
			mSin = -diff.y * mInvDistance;
			
			//trace( "(sin, cos)= ", mCos, mSin, diff, mInvDistance );
		}
		// ============================================================
		public function HasCollision( sphere:NSphere ):Boolean
		{
			return false;
			
			/*var otherR = sphere.Radius;
			var diff:NPoint = sphere.Pos.subtract - FirstPoint;

			var newPos:NPoint = RotatePoint( diff, mCos, mSin );
			var abs_dx:Number = Abs( newPos.x );
			var abs_dy:Number = Abs( newPos.y );
			var d:Number = 0;
			var a:Number;

			if( abs_dx > mfHalfLength )
			{
				a = abs_dx - mfHalfLength;
				d = a*a;
			}

			if( abs_dy > mfHalfHeight )
			{
				a = abs_dy - mfHalfHeight;
				d += a*a;
			}

			if( d <= (radius*radius) )
			{
				fPoint move_vector;

				if( mIsCollisionSide[SIDE_LEFT] && mIsCollisionSide[SIDE_RIGHT] && !mIsCollisionSide[SIDE_FORE] && !mIsCollisionSide[SIDE_BACK] )
				{
					move_vector.x = 0.f;
					move_vector.y = mfHalfHeight - (abs_dy - radius);
				}
				else if( mIsCollisionSide[SIDE_LEFT] && mIsCollisionSide[SIDE_RIGHT] && mIsCollisionSide[SIDE_FORE] && !mIsCollisionSide[SIDE_BACK] )
				{
					// есть проблема с переходом от параллельного столкновения к перпендикулярному

					float nx = abs_dx * mfInvHalfLength;
					float ny = abs_dy / mfHalfHeight;

					if( nx > 1.f && ny > 1.f )	// угловое взаимодействие
					{
						// рассчитаем вектор от угла к центру окружности
						move_vector.x = abs_dx - mfHalfLength;
						move_vector.y = abs_dy - mfHalfHeight;

						move_vector.AddLength( -radius );
						move_vector.invert();	// потому что radius больше длины нашего вектора (ведь уже есть проникновение в окружность)
					}
					else
						if( ny > nx )
					{
						move_vector.x = 0.f;
						move_vector.y = mfHalfHeight - (abs_dy - radius);
					}
					else if(nx > ny)
					{
						move_vector.y = 0.f;
						move_vector.x = mfHalfLength - (abs_dx - radius);
					}
					else
					{
						// заглушка:
						move_vector.y = mfHalfHeight - (abs_dy - radius);
						move_vector.x = mfHalfLength - (abs_dx - radius);
						move_vector.multiply(.5f);
					}
				}

				move_vector.y *= FMath.GetSign( &newPos.y );
				move_vector.x *= FMath.GetSign( &newPos.x );
				move_vector = RotateBack( move_vector );

				if( !mFigure->mIsVirtual && !another->mFigure->mIsVirtual )
				{
					if( !AreKnotsFixed() )
						move_vector.multiply(0.5f);
					else
					{
						if( !another->AreKnotsFixed() )
								move_vector.multiply(0.5f);
					}
				}

				move_vector.MinFaster( COLLISION_NORMA_MAX_MOVE_FORCE, QUAD_VALUE( COLLISION_NORMA_MAX_MOVE_FORCE ) );

				if( !another->mFigure->mIsVirtual )
					another->MoveBack( move_vector );
				move_vector.invert();
				if( !mFigure->mIsVirtual )
					MoveBack( move_vector, 1.f, 1.f );

				return true;
			}
			return false;*/

		}
		// ============================================================
		public function CalcCollision( sphere:NSphere ):BallCollision
		{
			return null;
		}
		// ============================================================
	}

}