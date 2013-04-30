package com.pamakids.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapDataUtil
	{
		public static function getBitmapData(vSource:DisplayObject, vW:Number=NaN, vH:Number=NaN, vTransparent:Boolean=true, vColor:int=0xFF00FF, vMatrix:Matrix=null):BitmapData
		{
			var vWidth:int=(isNaN(vW)) ? vSource.width : vW;
			var vHeight:int=(isNaN(vH)) ? vSource.height : vH;

			var vBmp:BitmapData=new BitmapData(vWidth, vHeight, vTransparent, vColor);

			if (vMatrix == null)
				vBmp.draw(vSource, null, null, null, null, true);
			else
				vBmp.draw(vSource, vMatrix, null, null, null, true);

			return vBmp;
		}

		public static function getScaleMatrix(scale:Number):Matrix
		{
			var matrix:Matrix=new Matrix();
			matrix.scale(scale, scale);
			return matrix;
		}

		public static const RESIZE_SCALE:String='ImageEdit.resizeScale';
		public static const RESIZE_LETTERBOX:String='ImageEdit.resizeLetterbox';
		public static const RESIZE_CROP:String='ImageEdit.resizeCrop';

		public static function getResizedBitmapData(sourceBitmap:BitmapData, targetWidth:Number, targetHeight:Number, resizingMethod:String='', disposeSourceBmp:Boolean=true, transparent:Boolean=true):BitmapData
		{
			try
			{
				var curW:Number=sourceBitmap.width;
			}
			catch (error:Error)
			{
				trace("Invalid BitmapData");
				return null;
			}

			var curH:Number=sourceBitmap.height;

			var ratio_w:Number=targetWidth / curW;
			var ratio_h:Number=targetHeight / curH;
			var shorterRatio:Number=(ratio_w > ratio_h) ? ratio_h : ratio_w;
			var longerRatio:Number=(ratio_w > ratio_h) ? ratio_w : ratio_h;

			var resizedWidth:int;
			var resizedSourceBmp:BitmapData;
			var matrix:Matrix;
			var destBitmap:BitmapData;
			var offset:Point;
			var resizedHeight:Number;

			switch (resizingMethod)
			{
				case RESIZE_CROP:
					resizedWidth=Math.round(curW * longerRatio);
					resizedHeight=Math.round(curH * longerRatio);

					resizedSourceBmp=new BitmapData(resizedWidth, resizedHeight, transparent, 0x00000000);
					matrix=new Matrix();
					matrix.scale(longerRatio, longerRatio);
					resizedSourceBmp.draw(sourceBitmap, matrix, null, null, null, true);

					destBitmap=new BitmapData(targetWidth, targetHeight, transparent, 0x00000000);
					offset=new Point(targetWidth / 2 - resizedWidth / 2, targetHeight / 2 - resizedHeight / 2);
					destBitmap.copyPixels(resizedSourceBmp, new Rectangle(-offset.x, -offset.y, resizedSourceBmp.width, resizedSourceBmp.height), new Point());

					resizedSourceBmp.dispose();
					if (disposeSourceBmp)
						sourceBitmap.dispose();

					return destBitmap;
					break;

				case RESIZE_LETTERBOX:
					resizedWidth=Math.round(curW * shorterRatio);
					resizedHeight=Math.round(curH * shorterRatio);

					resizedSourceBmp=new BitmapData(resizedWidth, resizedHeight, transparent, 0x00000000);
					matrix=new Matrix();
					matrix.scale(shorterRatio, shorterRatio);
					resizedSourceBmp.draw(sourceBitmap, matrix, null, null, null, true);

					destBitmap=new BitmapData(targetWidth, targetHeight, transparent, 0x00000000);
					var pastePoint:Point=new Point(targetWidth / 2 - resizedWidth / 2, targetHeight / 2 - resizedHeight / 2);
					destBitmap.copyPixels(resizedSourceBmp, new Rectangle(0, 0, resizedSourceBmp.width, resizedSourceBmp.height), pastePoint);

					resizedSourceBmp.dispose();
					if (disposeSourceBmp)
						sourceBitmap.dispose();

					return destBitmap;
					break;

				case RESIZE_SCALE:
				default:
					var vBmp:BitmapData=new BitmapData(targetWidth, targetHeight, transparent, 0x00000000);
					matrix=new Matrix();
					matrix.scale(ratio_w, ratio_h);
					vBmp.draw(sourceBitmap, matrix, null, null, null, true);

					if (disposeSourceBmp)
						sourceBitmap.dispose();

					return vBmp;
					break;

			}
			return null;
		}
	}
}
