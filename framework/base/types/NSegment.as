package base.types 
{
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NSegment
	{
		// ============================================================
		public var Start:NPoint = new NPoint();
		public var End:NPoint = new NPoint();
		// ============================================================
		public function NSegment( start:NPoint = null, end:NPoint = null ) 
		{
			if( start )
				Start.CopyFrom( start );
			if( end )
				End.CopyFrom( end );
		}
		// ============================================================
		public function Init( start:NPoint, end:NPoint ):void 
		{
			Start.CopyFrom( start );
			End.CopyFrom( end );
		}
		// ============================================================
		/**
		 * 
		 * @param	o
		 * @param	result
		 * @return result if crossing, null if NOT crossing
		 */
		public function CalcCrossingPoint( o:NSegment, result:NPoint ):NPoint
		{
			var esx:Number = (End.x - Start.x);
			var esy:Number = (End.y - Start.y);
			var ossx:Number = (o.Start.x - Start.x);
			var ossy:Number = (o.Start.y - Start.y);
			var osoex:Number = (o.Start.x - o.End.x);
			var osoey:Number = (o.Start.y - o.End.y);

			// знаменатель
			var Z:Number = esy * osoex - osoey * esx;
			// числитель 1
			var Ca:Number = esy * ossx - ossy * esx;
			// числитель 2
			var Cb:Number = ossy * osoex - osoey * ossx;

			// если числители и знаменатель = 0, прямые совпадают
			/*if( (Z == 0) && (Ca == 0) && (Cb == 0) )
			{
				//trace( "c1 - sameLine" );
				return null;	// в нашем случае - это не пересечение, а какая-то фигня :)
			}*/

			// если знаменатель = 0, прямые параллельны
			if( Z == 0 )
			{
				//trace( "c2 - parallel" );
				return null;
			}

			var sign:Number = (Z > 0) ? 1 : -1;
			var Ua:Number = Ca * sign;
			var SZ:Number = Z * sign;

			// если 0<=Ua<=SZ и 0<=Ub<=SZ, точка пересечения в пределах отрезков
			if( (0 <= Ua) && (Ua <= SZ) )
			{
				var Ub:Number = Cb * sign;
				
				if ( (0 <= Ub) && (Ub <= SZ) )
				{
					//Ua = Ca / Z;
					Ub = Cb / Z;
					
					result.x = Start.x + esx * Ub;
					result.y = Start.y + esy * Ub;
					
					return result;
				}
			}

			return null;
		}
		// ============================================================
	}

}