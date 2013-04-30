package controller
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.pamakids.utils.Singleton;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	import model.consts.ShowEffects;
	import model.consts.ShowPosition;
	import model.content.BookVO;
	import model.content.ConversationVO;
	import model.content.SubtitleVO;

	import views.book.Avatar;

	/**
	 * PlayerControl 播放器控制类
	 * @author mani
	 */
	public class PC extends Singleton
	{

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url=value;
		}

		public static function get i():PC
		{
			return Singleton.getInstance(PC);
		}

		public function PC()
		{
			super();
		}

		public var useByCreator:Boolean;
		private var _url:String;
		public var width:Number;
		public var height:Number;
		public var vo:BookVO;

		private const NO_MOVING_EFFECTS:Array=[ShowEffects.CENTER_ELASTIC, ShowEffects.SHAKE];

		public var playingVO:SubtitleVO;

		public function showVO(subtitleVO:SubtitleVO, target:DisplayObject, onComplete:Function=null):void
		{
			if (!subtitleVO || playingVO == subtitleVO)
				return;
			playingVO=subtitleVO;
			trace('Show VO' + subtitleVO.text);
			var tox:Number;
			var toy:Number;
			var startX:Number;
			var startY:Number;
			var atBottom:Boolean=subtitleVO.showPosition == ShowPosition.BOTTOM;
			var atLeft:Boolean=subtitleVO.showPosition == ShowPosition.LEFT;
			var cvo:ConversationVO=subtitleVO as ConversationVO;
			target.visible=true;
			switch (subtitleVO.showPosition)
			{
				case ShowPosition.BOTTOM:
				case ShowPosition.TOP:
					tox=(width - target.width) / 2;
					target.x=tox;
					target.y=atBottom ? height : -target.height;
					toy=atBottom ? height - target.height - vo.subtitleGap : vo.subtitleGap;
					break;
				case ShowPosition.LEFT:
				case ShowPosition.RIGHT:
					toy=(height - target.height) / 2;
					target.y=toy;
					target.x=atLeft ? -target.width : width;
					tox=atLeft ? vo.subtitleGap : width - target.width - vo.subtitleGap;
					break;
				case ShowPosition.CUSTOMIZE:
					startX=cvo.avatarStartX;
					startY=cvo.avatarStartY;
					tox=cvo.avatarX;
					toy=cvo.avatarY;
					if (NO_MOVING_EFFECTS.indexOf(subtitleVO.showEffect) != -1)
					{
						target.x=tox;
						target.y=toy;
					}
					else
					{
						target.x=startX;
						target.y=startY;
					}
					break;
			}
			var duration:Number=subtitleVO.effectDuration;
			if (!subtitleVO.showEffect)
			{
				target.x=tox;
				target.y=toy;
			}
			else
			{
				var vars:Object;
				switch (subtitleVO.showEffect)
				{
					case ShowEffects.SOFT:
						vars={x: tox, y: toy, ease: Cubic.easeOut};
						break;
					case ShowEffects.MOTHION_BLUR:
						vars={x: tox, y: toy, ease: Cubic.easeInOut, motionBlur: true};
						break;
					case ShowEffects.BACK:
						vars={x: tox, y: toy, ease: Back.easeOut};
						break;
					case ShowEffects.BOUNCE:
						vars={x: tox, y: toy, ease: Bounce.easeOut};
						break;
					case ShowEffects.ELASTIC:
						vars={x: tox, y: toy, ease: Elastic.easeOut};
						break;
					case ShowEffects.CENTER_ELASTIC:
						var scale:Number=Number(cvo.effectData);
						target.x=tox - target.width * (scale - 1) / 2;
						target.y=toy - target.height * (scale - 1) / 2;
						target.scaleX=target.scaleY=scale;
						vars={x: tox, y: toy, transformAroundCenter: {scaleX: cvo.avatarScale, scaleY: cvo.avatarScale}, ease: Elastic.easeOut};
						break;
					case ShowEffects.SHAKE:
						var ed:Object=cvo.effectData;
						vars={shake: ed};
						break;
				}
				if (cvo)
				{
					if (cvo.fadeIn)
					{
						target.alpha=0;
						vars.alpha=1;
					}
				}
				if (onComplete != null)
					vars.onComplete=onComplete;
				var t:TweenMax=TweenMax.to(target, duration, vars);
				if (cvo)
					tweenDic[subtitleVO]=t;
			}
		}

		private var tweenDic:Dictionary=new Dictionary();

		public function revertAvatar(vo:ConversationVO):void
		{
			var t:TweenMax=tweenDic[vo];
			if (!t)
				return;
			t.reverse();
			TweenLite.killDelayedCallsTo(removeRevertedAvatar);
			TweenLite.delayedCall(vo.effectDuration, removeRevertedAvatar, [t.target]);
			delete tweenDic[vo];
		}

		private function removeRevertedAvatar(target:Avatar):void
		{
			target.parent.removeChild(target);
		}

		public function getUrl(url:String):String
		{
			var s:String=this.url + url;

			if (useByCreator)
				s=new File(s).url;

			return s;
		}
	}
}
