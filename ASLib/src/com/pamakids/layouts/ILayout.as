package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;

	import flash.display.DisplayObject;

	public interface ILayout
	{
		function update():void;
		function updateAll():void;
		function measure():void;
		function addItem(displayObject:DisplayObject):void;
		function removeItem(displayObject:DisplayObject):void;
		function dispose():void;
		function set gap(value:Number):void;
		function set itemWidth(value:Number):void;
		function set itemHeight(value:Number):void;
		function set container(value:Container):void;
		function set width(value:Number):void;
		function set height(value:Number):void;
		function setAnimation(duration:Number, vars:Object, tweenX:Boolean=true, tweeny:Boolean=true):void;
		function get useVirtualLayout():Boolean;
		function set useVirtualLayout(value:Boolean):void;
		function set paddingBottom(value:Number):void;
		function set updateImmediately(value:Boolean):void;
	}
}
