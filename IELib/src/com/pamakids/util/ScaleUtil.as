package com.pamakids.util
{
	import flash.display.DisplayObject;

	public class ScaleUtil
	{
		public static function scale(displayObject:DisplayObject,num:int):void
		{
			displayObject.width = displayObject.width/num;
			displayObject.height = displayObject.height/num;
		}
	}
}

