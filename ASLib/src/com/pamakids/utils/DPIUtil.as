package com.pamakids.utils
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	public class DPIUtil
	{
		/**
		 *  Density value for low-density devices.
		 */
		public static const DPI_160:Number=160;

		/**
		 *  Density value for medium-density devices.
		 */
		public static const DPI_240:Number=240;

		/**
		 *  Density value for high-density devices.
		 */
		public static const DPI_320:Number=320;

		public function DPIUtil()
		{
		}

		public static function getRuntimeDPI():Number
		{
			var dpi:Number=Capabilities.screenDPI;
//			return 169;
			if (Capabilities.screenResolutionX > 2000 || Capabilities.screenResolutionY > 2000)
				return DPI_320;
			if (dpi < 200)
				return DPI_160;
			if (dpi <= 280)
				return DPI_240;
			return DPI_320;
		}

		public static function getDPIScale(sourceDPI:Number=160):Number
		{
			var targetDPI:Number=getRuntimeDPI();
			// Unknown dpi returns NaN
			if ((sourceDPI != DPI_160 && sourceDPI != DPI_240 && sourceDPI != DPI_320) ||
				(targetDPI != DPI_160 && targetDPI != DPI_240 && targetDPI != DPI_320))
			{
				return 1;
			}

			return targetDPI / sourceDPI;
		}

		public static var stage:Stage;

		/**
		 * array[scale,offsetX,offsetY]
		 * */
		public static function getAndroidSize():Array
		{
			var w:int=Math.max(stage.fullScreenHeight,stage.fullScreenWidth);
			var h:int=Math.min(stage.fullScreenHeight,stage.fullScreenWidth);

			var scale:Number=0;
			var offsetX:Number=0
			var offsetY:Number=0;
			if (h / 768 > w / 1024)
			{
				scale=w / 1024;
				offsetY=(h - 768 * scale) / 2;
			}
			else
			{
				scale=h / 768;
				offsetX=(w - 1024 * scale) / 2;
			}
			var arr:Array=[scale, offsetX, offsetY];
			return arr;
		}

		public static function getStageSize(stageW:Number, stageH:Number):Array
		{
			var w:int=Math.max(stageW, stageH);
			var h:int=Math.min(stageW, stageH);

			var scale:Number=0;
			var offsetX:Number=0
			var offsetY:Number=0;
			if (h / 768 > w / 1024)
			{
				scale=w / 1024;
				offsetY=(h - 768 * scale) / 2;
			}
			else
			{
				scale=h / 768;
				offsetX=(w - 1024 * scale) / 2;
			}
			var arr:Array=[scale, offsetX, offsetY];
			return arr;
		}

	}
}


