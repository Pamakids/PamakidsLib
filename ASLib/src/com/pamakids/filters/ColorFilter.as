package com.pamakids.filters
{
	import flash.filters.ColorMatrixFilter;

	public class ColorFilter
	{

		/**
		 * @param $highLightValue 高亮的百分比值
		 */
		public static function getHighLightFilter($highLightValue:Number=20,
			$alpha:Number=NaN):ColorMatrixFilter
		{
			var matrix:Array=new Array();
			matrix=matrix.concat([1, 0, 0, 0, $highLightValue]); // red
			matrix=matrix.concat([0, 1, 0, 0, $highLightValue]); // green
			matrix=matrix.concat([0, 0, 1, 0, $highLightValue]); // blue
			if (isNaN($alpha))
			{
				matrix=matrix.concat([0, 0, 0, 1, 0]); // alpha
			}
			else
			{
				matrix=matrix.concat([0, 0, 0, 1, $alpha]); // alpha
			}
			return new ColorMatrixFilter(matrix);
		}

		public static function getDisableFilter():ColorMatrixFilter
		{
			var matrix:Array=new Array();
			matrix=matrix.concat([0.5, 0.5, 0.5, 0, 0]); // red
			matrix=matrix.concat([0.5, 0.5, 0.5, 0, 0]); // green
			matrix=matrix.concat([0.5, 0.5, 0.5, 0, 0]); // blue
			matrix=matrix.concat([0, 0, 0, 1, 0]); // alpha
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			return my_filter;
		}
	}
}
