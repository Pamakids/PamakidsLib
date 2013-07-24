package com.pamakids.manager
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.StringUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	public class PopupManager
	{
		public static var parent:Sprite;
		public static var maskSprite:Sprite;

		public static function showMask(fadeIn:Boolean=true):void
		{
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
			if (isShowMask && !maskSprite)
				showMask(isShowMask);
			if (center)
			{
				view.x=parent.width / 2 - view.width / 2;
				view.y=parent.height / 2 - view.height / 2;
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

		public static function get hasPopup():Boolean
		{
			return popups.length>0;
		}

		public static function clearMask():void
		{
			if (maskSprite)
			{
				parent.removeChild(maskSprite);
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
			if (cls.indexOf("ShareWindow")>=0)
				view.visible=false;
			else
			{
				parent.removeChild(view);
				popups.splice(popups.indexOf(view), 1);
			}
		}

	}
}
