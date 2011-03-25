package base.types 
{
	import flash.geom.Point;
	import game.collisions.BallCollision;
	/**
	 * При коллизиях ВСЕГДА предполагается, что первая точка и привязанная к ней сфера заведомо не сталкиваются с объектом
	 * @author dmbreaker
	 */
	public class NRotatingCapsule extends NRotatingRect
	{
		// ============================================================
		private static var mPI:Number = Math.PI;
		// ============================================================
		protected var mRadius:Number;
		// ============================================================
		public function NRotatingCapsule() 
		{
			
		}
		// ============================================================
		public override function Init( first:NPoint, last:NPoint, r:Number, speedDirection:NVec, dist:Number = -1 ):void 
		{
			super.Init( first, last, r, speedDirection, dist );
			mRadius = r;
		}
		// ============================================================
		/**
		 * Суд по трэйсам - метод не используется, к тому же он старый и с ошибками
		 * @param	sphere
		 * @return
		 */
		public override function HasCollision( sphere:NSphere ):Boolean
		{
			//trace( "TEST!!!!!!!!!!!!!!!!!!!!!!!" );
			// TODO: позже попробовать избавиться от Precalculate():
			// переделать на: проекцию вектора до центра сферы на вектор движения шара
			// только не совсем ясно как высоту вычислять
			Precalculate();
			
			// в нашем случае единичный вектор - это SpeedDirection
			
			var totalR:Number;
			var squareDistToSphere:Number;
			
			var otherR:Number = sphere.Radius;
			diff.CopySubtraction( sphere.Pos, FirstPoint );

			RotatePoint( diff, newPos, mCos, mSin );
			var x:Number = newPos.x;
			
			if ( x >= 0 )	// правее первой точки
			{
				if ( x < Distance )	// если центр сферы на отрезке между центрами движущегося шара
				{
					totalR = otherR + mRadius;
					if ( newPos.y < totalR )
					{
						return true;
					}
				}
				else
				{
					squareDistToSphere = newPos.CalcSquareDistanceTo( LastPoint );
					totalR = otherR + mRadius;
					if ( squareDistToSphere < totalR*totalR )	// если сфера касается правого края
					{
						return true;
					}
				}
			}
			/*else
			{
				squareDistToSphere = newPos.CalcSquareLength();
				totalR = otherR + mRadius;
				if ( squareDistToSphere < totalR )	// если сфера касается правого края
				{
					return true;
				}
			}*/	// закомментарено, причина - в самом верху в комментарии к классу
			
			return false;
		}
		// ============================================================
		private var newBallNextPos:NPoint = new NPoint();
		private var newBallSpeed:NVec = new NVec();
		private var rNormal:NPoint = new NPoint();
		private var speed:NPoint = new NPoint();
		private var speedProj:NPoint = new NPoint();
		private var newPos:NPoint = new NPoint();
		private var diff:NPoint = new NPoint();
		
		public override function CalcCollision( sphere:NSphere ):BallCollision
		{
			var posX:Number;
			var colPos:NPoint;
			var newDist:Number;
			
			var totalR:Number;
			var squareDistToSphere:Number;
			
			var otherR:Number = sphere.Radius;
			diff.CopySubtraction( sphere.Pos, FirstPoint );

			RotatePoint( diff, newPos, mCos, mSin );
			var x:Number = newPos.x;
			var y:Number = newPos.y;
			
			if ( x >= 0 )	// правее первой точки
			{
				totalR = otherR + mRadius;

				if ( x < Distance )	// если центр сферы на отрезке между центрами движущегося шара
				{
					var abs_y:Number = (y >= 0)?y: -y;
					if ( abs_y < totalR )
					{
						return CalcBallCollision( sphere, x, y, totalR );
					}
				}
				else
				{
					squareDistToSphere = LastPoint.CalcSquareDistanceTo( sphere.Pos );
					if ( squareDistToSphere < totalR * totalR )	// если сфера касается правого края
					{
						return CalcBallCollision( sphere, x, y, totalR );
					}
				}
			}
			/*else
			{
				squareDistToSphere = FirstPoint.CalcSquareDistanceTo( sphere.Pos );;
				totalR = otherR + mRadius;
				if ( squareDistToSphere < totalR * totalR )	// если сфера касается правого края
				{
					return CalcBallCollision( sphere, x, y, totalR );
				}
			}*/	// закомментарено, причина - в самом верху в комментарии к классу
			
			return null;
		}
		// ============================================================
		private var colPos2:NPoint = new NPoint();
		private var newBallPos:NPoint = new NPoint();
		
		protected function CalcBallCollision( sphere:NSphere, x:Number, y:Number, totalR:Number ):BallCollision
		{
			var posX:Number;		// точка, в которой произошло взаимодействие
			var newDist:Number;
			
			posX = x - Math.sqrt( (totalR - y)*(totalR + y) );
			colPos2.Init( posX, 0 );

			newDist = Distance - posX;	// расстояние, которое осталось пройти...
			RotatePointBack(colPos2, newBallPos, mCos, mSin);
			newBallPos.Add( FirstPoint );
			
			rNormal.CopySubtraction( sphere.Pos, newBallPos );
			// делаем вектор единичным и "переворачиваем" его:
			rNormal.Multiply( -1 / totalR );
			
			speed.CopyVector( SpeedDirection );
			speedProj.CopyProjection( speed, rNormal );
			speed.Sub( speedProj );
			speedProj.Multiply( -1 );	// отразим проекцию
			speed.Add( speedProj );
			
			
			newBallSpeed.CopyPoint( speed );
			
			newBallNextPos.CopyMovedByVector( newBallPos, newBallSpeed, newDist );
			
			return new BallCollision( newBallPos, newBallNextPos, newBallSpeed, posX, newDist);
		}
		// ============================================================
		private var v:NPoint = new NPoint();
		private var w:NPoint = new NPoint();
		private var bsphere:NSphere = new NSphere();
		private var spolyFirst:NPoint = new NPoint();
		private var sp0:NPoint = new NPoint();
		private var sp1:NPoint = new NPoint();
		
		public function CalcPolygonCollision( poly:NRotatingPolygon ):BallCollision 
		{
			bsphere.Pos.CopyAddition( FirstPoint, LastPoint );
			bsphere.Pos.Multiply( 0.5 );
			bsphere.Radius = Distance * 0.5 + mRadius;
			
			if ( !bsphere.HasContact( poly.BoundingSphere ) )		// если описывающие окружности не пересекаются
				return null;
			
			var count:int = poly.Points.length;
			var p:NPoint = FirstPoint;
			spolyFirst.CopyAddition( poly.Points[0], poly.Position );
			sp0.CopyFrom(spolyFirst);
			var n0:NPoint = poly.PointNormals[0];
			var n1:NPoint;
			
			var lastCollision:BallCollision = null;
			var curCollision:BallCollision = null;
			
			for ( var i:int = 1; i < count; i++ )
			{
				sp1.CopyAddition( poly.Points[i], poly.Position );
				n1 = poly.PointNormals[i];
				var segN:NPoint = poly.SideNormals[i - 1];
				
				curCollision = CalcSegmentCollision( sp1, sp0, n1, n0, segN );
				if( curCollision )
					if ( !lastCollision || lastCollision.CollisionDistance > curCollision.CollisionDistance )
						lastCollision = curCollision;
				
				sp0.CopyFrom( sp1 );
				n0 = n1;
			}
			
			sp1.CopyFrom( spolyFirst );
			n1 = poly.PointNormals[0];
			curCollision = CalcSegmentCollision( sp1, sp0, n1, n0, poly.SideNormals[count - 1] );
			if( curCollision )
				if ( !lastCollision || lastCollision.CollisionDistance > curCollision.CollisionDistance )
					lastCollision = curCollision;
			
			/*if( lastCollision )
				trace( SpeedDirection, lastCollision );*/
			return lastCollision;
		}
		// ============================================================
		private var bv:NPoint = new NPoint();
		private var cvec:NPoint = new NPoint();
		private var shiftedFirst:NPoint = new NPoint();
		private var shiftedLast:NPoint = new NPoint();
		private var moveSeg:NSegment = new NSegment();
		private var testSeg:NSegment = new NSegment();
		private var pb:NPoint = new NPoint();
		private var crossResult:NPoint = new NPoint();
		// ============================================================
		private function CalcSegmentCollision( p1:NPoint, p0:NPoint, n1:NPoint, n0:NPoint, segNorm:NPoint ):BallCollision
		{
			var dot:Number = segNorm.DotProductVec2d( SpeedDirection );
			if ( dot >= 0 )	// избавляемся от проверок с поверхностями, от которых отлетаем
				return null;
			
			var collision:BallCollision = null;
			
			v.CopySubtraction( p1, p0 );
			w.CopySubtraction( FirstPoint, p0 );
			
			var c1:Number = w.DotProduct( v );
			if ( c1 <= 0 )							// если ближайшая точка - "левая"
			{
				// просто повернуть p0 в с.к. капсулы и если p0 лежит вне капсулы, то коллизии нет, иначе расчитать координаты столкновения
				collision = CalcPolyPointCollision( p0, n0 );
			}
			
			if( !collision )
			{
				var c2:Number = v.CalcSquareLength();	// эквивалентно "v.DotProduct( v )"
				if ( c2 <= c1 )						// если ближайшая точка - "правая"
				{
					// просто повернуть p1 в с.к. капсулы и если p1 лежит вне капсулы, то коллизии нет, иначе расчитать координаты столкновения
					collision = CalcPolyPointCollision( p1, n1 );
				}
				
				if( !collision )					// если перпендикуляр
				{
					/*
					double b = c1 / c2;
					Point Pb = P0 + b * v;
					return d(P, Pb);
					*/
					var b:Number = c1 / c2;
					bv.CopyMulFrom( v, b );
					pb.CopyAddition( p0, bv );		// << искомая точка на прямой
					
					// получить вектор от центра окружности (p) до p0,
					cvec.CopySubtraction( pb, FirstPoint );
					// нормализовать его, умножить на радиус, получить смещение относительно "p"
					cvec.normalize( mRadius );
					shiftedFirst.CopyAddition( FirstPoint, cvec );
					shiftedLast.CopyAddition( LastPoint, cvec );
					// построить отрезок до этой же точки в новом положении
					moveSeg.Init( shiftedFirst, shiftedLast );
					testSeg.Init( p0, p1 );
					
					
					// проверить - пересекает ли этот отрезок отрезок (p0,p1)
					var crossPoint:NPoint = moveSeg.CalcCrossingPoint( testSeg, crossResult );
					if ( crossPoint )// если да - коллизия, причем точка пересечения = (искомая позиция шара + смещение до точки удара)
					{
						crossPoint.Sub( cvec );		// вычтем смещение до точки удара (найдем положение центра в момент удара
						collision = CalcBallCollisionWithNormal( crossPoint, segNorm );
					}
				}
			}
			
			return collision;
		}
		// ============================================================
		private function CalcPolyPointCollision( p:NPoint, n:NPoint ):BallCollision
		{
			var dot:Number = n.DotProductVec2d( SpeedDirection );
			if ( dot >= 0 )	// избавляемся от проверок с точками, от которых отлетаем
				return null;
			
			var x:Number;
			var y:Number;
			var curCollision:BallCollision = null;
			
			diff.CopySubtraction( p, FirstPoint );
			RotatePoint( diff, newPos, mCos, mSin );
			x = newPos.x;
			y = newPos.y;
			
			if ( x >= 0 )	// правее первой точки
			{
				if ( x < Distance )	// если центр сферы на отрезке между центрами движущегося шара
				{
					var abs_y:Number = (y >= 0) ? y : -y;
					if ( abs_y < mRadius )	// если внутри капсулы
					{
						curCollision = CalcBallDotCollision( n, x, y );
					}
				}
				else	// нужно проверить - не в конечной ли сфере точка
				{
					var squareDistToPoint:Number = LastPoint.CalcSquareDistanceTo( p );
					if ( squareDistToPoint < mRadius * mRadius )	// если точка в финальной сфере
					{
						curCollision = CalcBallDotCollision( n, x, y );
					}
				}
			}

			return curCollision;
		}
		// ============================================================
		protected function CalcBallCollisionWithNormal( colPnt:NPoint, norm:NPoint ):BallCollision
		{
			var posX:Number;		// точка, в которой произошло взаимодействие
			var newDist:Number;

			speed.CopyVector( SpeedDirection );
			speedProj.CopyProjection( speed, norm );
			//
			speed.Sub( speedProj );
			speedProj.Multiply( -1 );	// отразим проекцию
			speed.Add( speedProj );
			newBallSpeed.CopyPoint( speed );
			
			var colDist:Number = NPoint.CalcDistance( colPnt, FirstPoint );
			newDist = Distance-colDist;
			newBallNextPos.CopyMovedByVector( colPnt, newBallSpeed, newDist );
			
			return new BallCollision( colPnt, newBallNextPos, newBallSpeed, colDist, newDist);
		}
		// ============================================================
		/**
		 * 
		 * @param	norm
		 * @param	x
		 * @param	y
		 * @return
		 */
		protected function CalcBallDotCollision( norm:NPoint, x:Number, y:Number ):BallCollision
		{
			var posX:Number;		// точка, в которой произошло взаимодействие
			var newDist:Number;
			
			posX = x - Math.sqrt( (mRadius - y)*(mRadius + y) );	// x - sqrt( a*a - b*b )
			colPos2.Init( posX, 0 );

			newDist = Distance - posX;	// расстояние, которое осталось пройти...
			RotatePointBack(colPos2, newBallPos, mCos, mSin);
			newBallPos.Add( FirstPoint );

			speed.CopyVector( SpeedDirection );
			speedProj.CopyProjection( speed, norm );
			//
			speed.Sub( speedProj );
			speedProj.Multiply( -1 );
			speed.Add( speedProj );
			
			newBallSpeed.CopyPoint( speed );
			
			newBallNextPos.CopyMovedByVector( newBallPos, newBallSpeed, newDist );
			
			return new BallCollision( newBallPos, newBallNextPos, newBallSpeed, posX, newDist);
		}
		// ============================================================
		
		/*			{ _Точка пересечения перпендикуляра опущенного из точки, и прямой_
				  _к которой он опущен(прямая задана точками через которые проходит)._
				  Голая математика, с использованием свойств в.п. и с.п.}

				procedure crsort(q: tpoint; p: tsegment; var w: tpoint);
				var a,b,c,d,e,f,g: float;
				begin
				  a:= p.x2-p.x1; b:= p.y2-p.y1; c:= a*q.x+b*q.y;
				  d:= b;         e:= -a;        f:= d*p.x1+e*p.y1;
				  g:= a*e-b*d;
				  w.x:= (c*e-b*f)/g;
				  w.y:= (a*f-c*d)/g;
				end;
				
				
*/		
		
			/*{ Тоже самое только с использованием _параметрического_ задания прямой (может
				  понадобиться для определения попала точка на отрезок, или нет). }

				procedure crsortp(q: tpoint; p: tsegment; var t: float; var w: tpoint);
				begin
				  t:= -((p.x1-q.x)*(p.x2-p.x1)+(p.y1-q.y)*(p.y2-p.y1))/
						(sqr(p.x2-p.x1)+sqr(p.y2-p.y1));
				  w.x:= p.x1*(1.0-t)+p.x2*t;
				  w.y:= p.y1*(1.0-t)+p.y2*t;
				end;
*/
/*				{ _Расстояние от точки до отрезка._
					Задача особенна тем, что  рассояние до отрезка не всегда равно расстоянию
				 до прямой, содержашей отрезок. Надо просто немного переделать уже написанный
				 belong2piece}

				function distance2piece(q: tpoint; p: tsegment): float;
				var t,w: float;
				begin
				  if((q.x-p.x1)*(p.x2-p.x1)+(q.y-p.y1)*(p.y2-p.y1))*
					((q.x-p.x2)*(p.x2-p.x1)+(q.y-p.y2)*(p.y2-p.y1))>-eps then
				  begin
					t:= sqr(q.x-p.x1)+sqr(q.y-p.y1);
					w:= sqr(q.x-p.x2)+sqr(q.y-p.y2);
					if w<t then t:= w;
				  end else
					t:= sqr((q.x-p.x1)*(p.y2-p.y1)-(q.y-p.y1)*(p.x2-p.x1))/
							 (sqr(p.x2-p.x1)+sqr(p.y2-p.y1));
				  distance2piece:= sqrt(t);
				end;
*/
				/*{ _Принадлежность точки отрезку._
					  Считаем расстояние от данной точки до отрезка, и сравниваем с eps.
					  1) Квадрат расстояния меньше sqr(eps)
					  2) Находится между перпендикулярными прямыми, проведенными через концы
						 отрезка.
					  Проверяется через с.п.}

					function belong2piece(q: tpoint; tsegment): boolean;
					var t: float;
					begin
					  t:= sqr((q.x-p.x1)*(p.y2-p.y1)-(q.y-p.y1)*(p.x2-p.x1))/
							   (sqr(p.x2-p.x1)+sqr(p.y2-p.y1));
					  belong2piece:= false;
					  if t>sqr(eps) then exit;
					  if((q.x-p.x1)*(p.x2-p.x1)+(q.y-p.y1)*(p.y2-p.y1))*
						((q.x-p.x2)*(p.x2-p.x1)+(q.y-p.y2)*(p.y2-p.y1))<eps then
						  belong2piece:= true;
					end;
*/
					
				//		#define dot(u,v)   ((u).x * (v).x + (u).y * (v).y + (u).z * (v).z)
				//		#define norm(v)    sqrt(dot(v,v))  // norm = length of vector
				//		#define d(u,v)     norm(u-v)
	}

}