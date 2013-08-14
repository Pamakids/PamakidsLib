package com.pamakids.components.interfaces
{
	import com.pamakids.components.ItemRenderer;

	public interface IItemRendererOwner
	{
		/**
		 * 返回在数据项渲染器里显示的文本
		 * @param item
		 * @return
		 *
		 */
		function itemToLabel(item:Object):String;

		function updateRenderer(renderer:ItemRenderer, itemIndex:int, data:Object):void;
	}
}
