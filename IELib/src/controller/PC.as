package controller
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.pamakids.manager.FileManager;
	import com.pamakids.util.CloneUtil;
	import com.pamakids.utils.Singleton;

	import flash.display.DisplayObject;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;

	import model.consts.Const;
	import model.consts.ShowEffects;
	import model.consts.ShowPosition;
	import model.content.AssetVO;
	import model.content.BookVO;
	import model.content.ContentVO;
	import model.content.ConversationVO;
	import model.content.EventsVO;
	import model.content.HotAreaVO;
	import model.content.HotPointVO;
	import model.content.PageVO;
	import model.content.SubtitleVO;
	import model.games.GameVO;

	import views.book.Avatar;

	/**
	 * PlayerControl 播放器控制类
	 * @author mani
	 */
	public class PC extends Singleton
	{

		public static function get i():PC
		{
			return Singleton.getInstance(PC);
		}

		public function PC()
		{
			super();
		}

		public var useByCreator:Boolean;
		public var width:Number;
		public var height:Number;
		public var vo:BookVO;

		private const NO_MOVING_EFFECTS:Array=[ShowEffects.CENTER_ELASTIC, ShowEffects.SHAKE];

		public var playingVO:SubtitleVO;

		public function playHotArea(vo:HotAreaVO, target:DisplayObject):void
		{
			var vars:Object=vo.effectData;
			switch (vo.effect)
			{
				case ShowEffects.CENTER_ELASTIC:
					var scale:Number=Number(vo.effectData);
					target.x=target.width * (scale - 1) / 2;
					target.y=target.height * (scale - 1) / 2;
					target.scaleX=target.scaleY=scale;
					vars={x: 0, y: 0, transformAroundCenter: {scaleX: 1, scaleY: 1}, ease: Elastic.easeOut};
					break;
				case ShowEffects.SHAKE:
					vars={shake: vo.effectData};
					break;
			}
			TweenMax.to(target, vo.effectDuration, vars);
		}


		/**
		 * 显示字幕或角色动画
		 * @param subtitleVO
		 * @param target
		 * @param onComplete
		 *
		 */
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
			if (target.parent)
				target.parent.removeChild(target);
		}

		public function getUrl(url:String):String
		{
			var s:String=this.contentDir + url;

			if (useByCreator)
				s=new File(s).url;

			return s;
		}

		public var updatePainter:Function;
		public var enableDrag:Boolean;

		/**
		 * 内容文件夹
		 */
		public var contentDir:String;

		public function parseBook(object:Object):BookVO
		{
			var bookVO:BookVO=CloneUtil.convertObject(object, BookVO);

			var files:Array;
			var boolean:Boolean;
			var hotPointVO:HotPointVO;
			var tempArr:Array;
			var fs:FileStream=new FileStream();
			var pages:Array=bookVO.pages;
			if (pages)
				pages=convertHotPoints(pages);
			var file:File=new File(contentDir + '/contents');
			files=file.getDirectoryListing();
			tempArr=[];
			for each (file in files)
			{
				if (file.name.indexOf(Const.PAGE_EXTENSION) != -1)
				{
					boolean=false;
					if (pages)
					{
						for each (hotPointVO in pages)
						{
							if (hotPointVO.content.indexOf(file.name) != -1)
							{
								boolean=true;
								break;
							}
						}
					}
					if (!boolean)
					{
						fs.open(file, FileMode.READ);
						tempArr.push(fs.readObject());
					}
				}
			}
			if (tempArr.length)
			{
				tempArr=convertHotPoints(tempArr);
				pages=pages ? pages.concat(tempArr) : tempArr;
			}
			bookVO.pages=pages;
			bookVO.dir=contentDir;

			globalAssets=FileManager.readFile(contentDir + '/' + Const.GLOBAL_ASSETS) as Array;
			if (globalAssets)
				globalAssets=CloneUtil.convertArrayObjects(globalAssets, AssetVO);
			file=new File(contentDir + '/global');
			if (file.exists)
			{
				files=file.getDirectoryListing();
				for each (file in files)
				{
					if (file.name.indexOf(Const.ASSET_EXTENSION) != -1)
					{
						if (!globalAssets)
							globalAssets=[];
						fs.open(file, FileMode.READ);
						globalAssets.push(CloneUtil.convertObject(fs.readObject(), AssetVO));
					}
				}
			}
			file=new File(contentDir + '/' + Const.ALERT_DIR);
			if (file.exists)
			{
				files=file.getDirectoryListing();
				alerts=[];
				for each (file in files)
				{
					if (file.name.indexOf(Const.ALERT_EXTENSION) != -1)
					{
						fs.open(file, FileMode.READ);
						alerts.push(CloneUtil.convertObject(fs.readObject(), ConversationVO));
					}
				}
			}
			fs.close();
			return bookVO;
		}

		public var globalAssets:Array;
		public var alerts:Array;

		private function convertHotPoints(points:Array):Array
		{
			var arr:Array=[];
			for each (var p:Object in points)
			{
				var a:Array=[];
				if (p.hotAreas)
				{
					for each (var h:Object in p.hotAreas)
					{
						if (h.gameVO)
							h.gameVO=CloneUtil.convertObject(h.gameVO, GameVO);
						a.push(CloneUtil.convertObject(h, HotAreaVO));
					}
					p.hotAreas=a;
				}
				if (p.events)
				{
					a=[];
					for each (var e:Object in p.events)
					{
						if (e.gameVO)
							e.gameVO=CloneUtil.convertObject(e.gameVO, GameVO);
						var evo:EventsVO=CloneUtil.convertObject(e, EventsVO);
						if (evo.type == Const.SUBTITLE)
							evo.subtitles=CloneUtil.convertArrayObjects(evo.subtitles, SubtitleVO);
						else if (evo.type == Const.CONVERSATION)
							evo.subtitles=CloneUtil.convertArrayObjects(evo.subtitles, ConversationVO);
						a.push(evo);
					}
					p.events=a;
				}
				arr.push(CloneUtil.convertObject(p, PageVO));
			}
			return arr;
		}
	}
}
