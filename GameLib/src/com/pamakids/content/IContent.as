package com.pamakids.content
{
	import flash.events.IEventDispatcher;

	public interface IContent extends IEventDispatcher
	{
		function initialize(width:Number, height:Number):void;
		function dispose():void;
		function get events():Array;
	}
}
