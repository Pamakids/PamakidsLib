package com.pamakids.utils
{

	final public class MathUtil
	{

		public static function min(A:Number, B:Number):Number
		{
			return (A <= B) ? A : B
		}

		public static function max(A:Number, B:Number):Number
		{
			return (A >= B) ? A : B
		}

		public static function bound(v:Number, Min:Number, Max:Number):Number
		{
			return (v > Max) ? Max : (v < Min ? Min : v)
		}

		public static function isInt(N:Number):Boolean
		{
			return int(N) == N
		}

		public static function getDistance(x:Number, y:Number):Number
		{
			return Math.sqrt(x * x + y * y);
		}

		public static function getRandomBetween(min:Number, max:Number):Number
		{
			return (max - min) * Math.random() + min
		}

		public static function getRadian(dx:Number, dy:Number):Number
		{
			return Math.atan2(dy, dx);
		}

		public static function getDegree(dx:Number, dy:Number):Number
		{
			var N:Number;

			N=Math.atan2(dy, dx) * 180 / Math.PI + 90;
			N=unwrapDegrees(N);
			return N;
		}

		/**
		 * 换算角度到 [0~360] 之间
		 */
		public static function unwrapDegrees(degree:Number):Number
		{
			degree=degree % 360;
			return (degree < 0) ? degree + 360 : degree
		}

		/**
		 * 换算弧度在 [-PI~PI] 之间
		 */
		public static function unwrapRadian(radian:Number):Number
		{
			const twoPI:Number=2.0 * Math.PI

			radian=radian % twoPI
			if (radian > Math.PI)
				radian-=twoPI
			if (radian < -Math.PI)
				radian+=twoPI
			return radian
		}
	}
}
