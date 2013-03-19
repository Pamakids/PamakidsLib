package com.pamakids.layouts
{
	import flash.display.DisplayObject;

	public interface ILayout
	{
		function update():void;
		function measure():void;
		function addItem(displayObject:DisplayObject):void;
		function removeItem(displayObject:DisplayObject):void;
		function dispose():void;
		function set gap(value:Number):void;
		function set itemWidth(value:Number):void;
		function set itemHeight(value:Number):void;
	}
}
