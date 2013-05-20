package com.pamakids.manager
{
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

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

		public static function popup(view:DisplayObject, isShowMask:Boolean=true, fadeIn:Boolean=true, center:Boolean=true):void
		{
			if (isShowMask && !maskSprite)
				showMask(isShowMask);
			if (center)
			{
				view.x=parent.width / 2 - view.width / 2;
				view.y=parent.height / 2 - view.height / 2;
			}
			parent.addChild(view);
		}

		public static function clearMask():void
		{
			if (maskSprite)
			{
				parent.removeChild(maskSprite);
				maskSprite=null;
			}
		}

		public static function removePopup(view:DisplayObject):void
		{
			clearMask();
			parent.removeChild(view);
		}

	}
}
