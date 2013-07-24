package com.pamakids.utils
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ReflectionUtil
	{
		public function ReflectionUtil()
		{
		}

		public static const N_RED:Number=0.3086;
		public static const N_GREEN:Number=0.6094;
		public static const N_BLUE:Number=0.0820;
		public static const DELAY:Number=5000;
		public static const GREY_FILTER:ColorMatrixFilter=new ColorMatrixFilter([N_RED, N_GREEN, N_BLUE, 0, 0, N_RED, N_GREEN, N_BLUE, 0, 0, N_RED, N_GREEN, N_BLUE, 0, 0, 0, 0, 0, 1, 0]);

		public static function createReflection(bmd:BitmapData, distance:Number=50):BitmapData
		{
			var distance:Number=distance;
			var flip:BitmapData=new BitmapData(bmd.width, distance, true, 0);
			var grad:BitmapData=new BitmapData(bmd.width, distance, true, 0);
			var result:BitmapData=new BitmapData(bmd.width, distance, true, 0);

			var m:Matrix=new Matrix();
			m.scale(1, -1);
			m.ty=bmd.height;
			flip.draw(bmd, m, null, null, null, true);

			var gmat:Matrix=new Matrix();
			gmat.createGradientBox(grad.width, grad.height, Math.PI / 2);

			var shp:Shape=new Shape();
			shp.graphics.beginGradientFill('linear', [0xFFFFFF, 0xf4f2ec], [0.28, 0.01], [0, 255], gmat);
			shp.graphics.drawRect(0, 0, grad.width, grad.height);
			shp.graphics.endFill();
			grad.draw(shp);
			result.copyPixels(flip, flip.rect, new Point(), grad, new Point(), true);
//			result.applyFilter(result, result.rect, new Point(), GREY_FILTER);
			flip.dispose();
			grad.dispose();

			return result;
		}
	}
}

