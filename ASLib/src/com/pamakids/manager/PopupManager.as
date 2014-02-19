package com.pamakids.manager
{
	import com.greensock.TweenLite;
	import com.pamakids.events.ResizeEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * 弹出管理器
	 * @author mani
	 */
	public class PopupManager
	{
		public static var parent:Sprite;
		public static var maskSprite:Sprite;

		public static function showMask(fadeIn:Boolean=true, parentD:Sprite=null):void
		{
			var parent:Sprite=parentD ? parentD : PopupManager.parent;
			maskSprite=new Sprite();
			maskSprite.graphics.beginFill(0, 0.5);
			maskSprite.graphics.drawRect(0, 0, parent.width, parent.height);
			maskSprite.graphics.endFill();
			var num:int=parent.numChildren ? parent.numChildren - 1 : 0;
			parent.addChildAt(maskSprite, num);
			if (fadeIn)
			{
				maskSprite.alpha=0;
				TweenLite.to(maskSprite, 0.5, {alpha: 1});
			}
		}

		private static var popups:Array=[];

		public static function popup(view:DisplayObject, isShowMask:Boolean=true, center:Boolean=true):void
		{
			if (!parent)
			{
				throw new Error('parent can not be null, you should set it equal where you want to popup');
				return;
			}
			if (isShowMask && !maskSprite)
				showMask(isShowMask);
			if (center)
			{
				view.x=parent.width / 2 - view.width / 2;
				view.y=parent.height / 2 - view.height / 2;
				view.addEventListener(ResizeEvent.RESIZE, resizeHandler);
			}
			if (parent.contains(view))
				parent.setChildIndex(view, parent.numChildren - 1);
			else
			{
				parent.addChildAt(view, parent.numChildren - 1);
				popups.push(view);
			}
			view.visible=true;
		}

		public static function popupWithin(view:DisplayObject, parentDOC:Sprite, isShowMask:Boolean=true, center:Boolean=true):void
		{
			var parent:Sprite=parentDOC ? parentDOC : PopupManager.parent;
			if (!parent)
			{
				throw new Error('parent can not be null, you should set it equal where you want to popup');
				return;
			}
			if (isShowMask && !maskSprite)
				showMask(isShowMask, parent);
			if (center)
			{
				centerTarget(view);
				view.addEventListener(ResizeEvent.RESIZE, resizeHandler);
			}
			if (parent.contains(view))
			{
				parent.setChildIndex(view, parent.numChildren - 1);
			}
			else
			{
				parent.addChildAt(view, parent.numChildren - 1);
				popups.push(view);
			}
			view.visible=true;
		}

		protected static function centerTarget(d:DisplayObject):void
		{
			if (!d.parent)
				return;
			d.x=d.parent.width / 2 - d.width / 2;
			d.y=d.parent.height / 2 - d.height / 2;
		}

		protected static function resizeHandler(event:Event):void
		{
			centerTarget(event.target as DisplayObject);
		}

		public static function get hasPopup():Boolean
		{
			return popups.length > 0;
		}

		public static function clearMask():void
		{
			if (maskSprite)
			{
				maskSprite.parent.removeChild(maskSprite);
				maskSprite=null;
			}
		}

		public static function clear():void
		{
			while (parent.numChildren)
				parent.removeChildAt(0);
			maskSprite=null;
		}

		public static function removePopup(view:DisplayObject):void
		{
			clearMask();
			var cls:String=getQualifiedClassName(view);
			if (cls.indexOf("ShareWindow") >= 0)
			{
				view.visible=false;
			}
			else
			{
				view.removeEventListener(ResizeEvent.RESIZE, resizeHandler);
				view.parent.removeChild(view);
				popups.splice(popups.indexOf(view), 1);
			}
		}

	}
}
