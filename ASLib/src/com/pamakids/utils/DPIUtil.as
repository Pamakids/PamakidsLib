package com.pamakids.utils
{
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
				return NaN;
			}

			return targetDPI / sourceDPI;
		}

	}
}
