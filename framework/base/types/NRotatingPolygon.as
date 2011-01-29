package base.types 
{
	import base.graphics.BitmapGraphix;
	import base.utils.FastMath;
	import base.utils.TwoNumbers;
	/**
	 * ...
	 * @author dmbreaker
	 */
	public class NRotatingPolygon
	{
		// ============================================================
		private static const PI:Number = Math.PI;
		private static const PI2:Number = Math.PI * 2;
		// ============================================================
		private var InitialPoints:Vector.<NPoint> = new Vector.<NPoint>();
		public var Points:Vector.<NPoint> = new Vector.<NPoint>();
		public var SideNormals:Vector.<NPoint> = new Vector.<NPoint>();
		public var PointNormals:Vector.<NPoint> = new Vector.<NPoint>();
		
		public var CurrentRotationAngle:Number = 0;
		public var Position:NPoint = new NPoint();
		public var BoundingSphere:NSphere = new NSphere();
		
		private var mFastMath:FastMath = new FastMath();
		// ============================================================
		public function NRotatingPolygon() 
		{
			
		}
		// ============================================================
		public function get Length():int
		{
			return Points.length;
		}
		// ============================================================
		public function AddPoint( x:Number, y:Number ):void 
		{
			InitialPoints.push( new NPoint( x, y ) );
			Points.push( new NPoint( x, y ) );
		}
		// ============================================================
		public function ResetPoints():void 
		{
			InitialPoints.length = 0;
			Points.length = 0;
		}
		// ============================================================
		public function CompleteInit():void 
		{
			// расчитать описывающую окружность...
			// суммируем все точки:
			var p:NPoint
			var center:NPoint = new NPoint();
			for each( p in InitialPoints )
			{
				center.Add( p );
			}
			
			center.Multiply( 1 / InitialPoints.length );	// найдем центр описывающей окружности
			
			// найдем радиус:
			var sr:Number = 0;	// square radius
			for each( p in Points )
			{
				var currentSq:Number = center.CalcSquareDistanceTo( p );
				if ( currentSq > sr )
					sr = currentSq;
			}
			
			var r:Number = Math.sqrt( sr );
			
			// сместим всю фигуру в ноль координат:
			for each( p in InitialPoints )
				p.Sub( center );
			for each( p in Points )
				p.Sub( center );
				
			CalculateNormals();
			
			//BoundingSphere.Pos.CopyFrom( center );
			BoundingSphere.Pos = Position
			BoundingSphere.Radius = r;
		}
		// ============================================================
		public function GenerateBoundingBox():NRelativeRect
		{
			var left:Number = 0;
			var top:Number = 0;
			var right:Number = 0;
			var bottom:Number = 0;
			var x:Number;
			var y:Number;
			
			for each( var p:NPoint in Points )
			{
				x = p.x;
				y = p.y;
				if ( x < left ) left = x;
				else if ( x > right ) right = x;
				
				if ( y < top ) top = y;
				else if ( y > bottom ) bottom = y;
			}
			
			return new NRelativeRect( Position, left, top, (right - left), (bottom - top) );
		}
		// ============================================================
		private var SinCos:TwoNumbers = new TwoNumbers();
		// ============================================================
		public function Rotate( angle:Number ):void
		{
			CurrentRotationAngle += angle;

			while( CurrentRotationAngle > PI2 )
				CurrentRotationAngle -= PI2;
			while( CurrentRotationAngle < -PI2 )
				CurrentRotationAngle += PI2;
			
			//var cos:Number = Math.cos( CurrentRotationAngle );
			//var sin:Number = Math.sin( CurrentRotationAngle );
			mFastMath.FSinCos( CurrentRotationAngle, SinCos );
			var sin:Number = SinCos.First;
			var cos:Number = SinCos.Second;
			
			var tmp:NPoint = new NPoint();
			var diff:NPoint = new NPoint();
			var center:NPoint = BoundingSphere.Pos;
			
			var count:int = InitialPoints.length;
			for (var i:int = 0; i < count; i++ ) 
			{
				var p:NPoint = InitialPoints[i];
				diff.CopyFrom( p );
				
				tmp.CopyRotated( diff, cos, sin );	// rotating
//				tmp.Add( center );
				Points[i].CopyFrom( tmp );	// saving result
			}
			
			CalculateNormals();
		}
		// ============================================================
		private function CalculateNormals():void 
		{
			SideNormals.length = 0;
			PointNormals.length = 0;
			
			var fp:NPoint = Points[0];
			var p0:NPoint = fp;
			var p1:NPoint;
			var line:NPoint = new NPoint();
			var norm:NPoint;
			
			// нормали для сторон:
			for ( var i:int = 1; i < Points.length; i++ )
			{
				p1 = Points[i];
				norm = new NPoint();
				
				line.CopySubtraction( p1, p0 );
				line.normalize( 1 );
				//norm.CopyLeftNormal( line );
				norm.CopyRightNormal( line );
				SideNormals.push( norm );
				
				p0 = p1;
			}
			norm = new NPoint();
			line.CopySubtraction( fp, p0 );
			line.normalize( 1 );
			//norm.CopyLeftNormal( line );
			norm.CopyRightNormal( line );
			SideNormals.push( norm );
			
			// нормали для точек/углов:
			var fn:NPoint = SideNormals[0];
			var n0:NPoint = fn;
			var n1:NPoint;
			PointNormals.push( null );
			
			for ( var k:int = 1; k < SideNormals.length; k++ )
			{
				n1 = SideNormals[k];
				norm = new NPoint();
				norm.CopyFrom( n0 );
				norm.Add( n1 );
				norm.normalize( 1 );
				PointNormals.push( norm );
				//PointNormals[k] = norm;
				n0 = n1;
			}
			norm = new NPoint();
			norm.CopyFrom( n0 );
			norm.Add( fn );
			norm.normalize( 1 );
			PointNormals[0] = norm;
		}
		// ============================================================
		// ============================================================
		// ============================================================
		// ============================================================
		public function DebugDrawNormals( g:BitmapGraphix ):void
		{
			var pnt:NPoint;
			var norm:NPoint;
			var i:int;
			
			for ( i = 0; i < SideNormals.length; i++ )
			{
				norm = SideNormals[i];
				pnt = Points[i];
				g.DrawLine( pnt.x+Position.x, pnt.y+Position.y, pnt.x+Position.x + norm.x * 10, pnt.y+Position.y + norm.y * 10, 0xff0000ff );
			}
			
			for ( i = 0; i < PointNormals.length; i++ )
			{
				norm = PointNormals[i];
				pnt = Points[i];
				g.DrawLine( pnt.x+Position.x, pnt.y+Position.y, pnt.x+Position.x + norm.x * 10, pnt.y+Position.y + norm.y * 10, 0xffff0000 );
			}
		}
		// ============================================================
	}

}