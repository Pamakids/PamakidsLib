package com.pamakids.manager
{
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class PopupManager
	{
		public static var parent:Sprite;
		public static var maskSprite:Sprite;

		public static function popup(view:DisplayObject, showMask:Boolean=true, fadeIn:Boolean=true, center:Boolean=true):void
		{
			if (showMask && !maskSprite)
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
			if (center)
			{
				view.x=parent.width / 2 - view.width / 2;
				view.y=parent.height / 2 - view.height / 2;
			}
			parent.addChild(view);
		}

		public static function removePopup(view:DisplayObject):void
		{
			if (maskSprite)
			{
				parent.removeChild(maskSprite);
				maskSprite=null;
			}
			parent.removeChild(view);
		}

	}
}
