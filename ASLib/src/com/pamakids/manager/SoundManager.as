package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * 声音管理类
	 * 根据配置文件自动匹配，可加入绑定声音，也可根据配置文件动态加载，操作的时候只需记住id即可
	 * 方便迁移到服务器，可方便更新和替换
	 * {
	 * 	  id: {url:'素材相对路径', loops:'循环次数'}
	 * }
	 * init 根据配置文件初始化所有会用到的声音文件信息
	 * play
	 * stop
	 * clear
	 * pause
	 * resume
	 * @author mani
	 */
	public class SoundManager extends Singleton
	{
		private var sounds:Dictionary;
		private var playingSounds:Dictionary;
		private var loadingSounds:Dictionary;
		/**
		 * 记录声音播放位置，方便暂停后继续播放
		 */
		private var playingPosition:Dictionary;
		private var config:Object={};

		public function SoundManager()
		{
			sounds=new Dictionary();
			playingSounds=new Dictionary();
			loadingSounds=new Dictionary();
			playingPosition=new Dictionary();
		}

		public static function get instance():SoundManager
		{
			return Singleton.getInstance(SoundManager);
		}

		/**
		 * 通过配置文件初始化声音
		 * @param config 配置文件地址
		 */
		public function init(config:String):void
		{
			LoadManager.instance.loadText(config, function(s:String):void
			{
				this.config=JSON.parse(s);
			});
		}

		/**
		 * 添加绑定的声音
		 * @param id 播放id
		 * @param sound 声音对象或类
		 * @loops 循环播放次数
		 */
		public function addSound(id:String, sound:Object, loops:int=0, volume:Number=1):void
		{
//			trace(sound is Sound);
			sounds[id]=sound;
			config[id]={loops: loops, volume: volume};
		}

		/**
		 * 直接播放未配置的url
		 * @param url
		 * @param loops
		 */
		public function playUrl(url:String, loops:int=0):void
		{
			config[url]={url: url, loops: loops};
			play(url);
		}

		/**
		 * 配置文件里会包含播放次数，url等信息
		 * @param target 播放id 或 绑定类 或 绑定Sound对象
		 * @param startPosition 播放起始时间
		 */
		public function play(target:Object, startPosition:int=0, _vol:Number=-1):void
		{
			var s:Object;
			var o:Object;
			if (target is String)
			{
				var vol:Number=volume(target as String);
				s=sounds[target];
				o=config[target];
				if (playingSounds[target])
				{
					if (playingPosition[target])
					{
						o=playingSounds[target];
						s=o.sound;
						o.channel=s.play(playingPosition[target], loops(target as String));
						if (_vol >= 0)
							vol=_vol;
						if (vol >= 0)
						{
							var st:SoundTransform=new SoundTransform(vol);
							o.channel.soundTransform=st;
						}
						trace('Sound ' + target + ' is replaying');
					}
					else
					{
						trace('Sound ' + target + ' is playing');
					}
					return;
				}
			}
			if (!s)
				s=target;
			if (s)
			{
				s=s as Sound ? s as Sound : new s;
				var sc:SoundChannel=s.play(startPosition ? startPosition : startTime(target as String), loops(target as String));
				var volume:Number=volume(target as String);
				if (_vol >= 0)
					volume=_vol;
				if (volume >= 0)
				{
					var ts:SoundTransform=new SoundTransform(volume);
					sc.soundTransform=ts;
				}
				sc.addEventListener(Event.SOUND_COMPLETE, playedHandler);
				playingSounds[target]={channel: sc, sound: s, volume: volume};
			}
			else
			{
				if (!o)
				{
					throw new Error('Sound:' + target + ' is not added or configed');
				}
				else
				{
					s=new Sound();
					s.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					s.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					loadingSounds[target]=s;
					s.load(new URLRequest(o.url));
				}
			}
		}

		protected function playedHandler(event:Event):void
		{
			for (var id:Object in playingSounds)
			{
				if (playingSounds[id].channel == event.currentTarget)
				{
					delete playingSounds[id];
					break;
				}
			}
			event.currentTarget.removeEventListener(Event.SOUND_COMPLETE, playedHandler);
		}

		protected function progressHandler(event:ProgressEvent):void
		{
			if (event.bytesLoaded == event.bytesTotal)
			{
				var s:Sound=event.currentTarget as Sound;
				var id:String=clearLoading(s);
				var sc:SoundChannel=s.play(startTime(id), loops(id));
				sounds[id]=s;
				playingSounds[id]={channel: sc, sound: s, volume: 1};
				if (pausedAll)
					sc.stop();
			}
		}

		private function clearLoading(s:Sound):String
		{
			if (!s)
				return '';
			for (var id:String in loadingSounds)
			{
				if (loadingSounds[id] == s)
				{
					delete loadingSounds[id];
					break;
				}
			}
			s.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			s.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			return id;
		}

		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('Sound IO Error:' + clearLoading(event.currentTarget as Sound));
		}

		private function loops(id:String):int
		{
			return config[id] ? config[id].loops : 0;
		}

		private function volume(id:String):Number
		{
			return config[id] ? config[id].volume : 1;
		}

		private function startTime(id:String):Number
		{
			return playingPosition[id] ? playingPosition[id] : 0;
		}

		/**
		 * 停掉声音，如果该声音不常用，直接clear掉更好
		 * @param id 声音id
		 */
		public function stop(id:String):void
		{
			if (loadingSounds[id])
			{
				try
				{
					loadingSounds[id].close();
				}
				catch (error:Error)
				{
					trace('Close Sound Error: ' + id + ' ' + error.message);
				}
				clearLoading(loadingSounds[id]);
			}
			else if (playingSounds[id])
			{
				playingSounds[id].channel.stop();
				delete playingSounds[id];
				delete playingPosition[id];
			}
		}

		private var pausedAll:Boolean;

		public function pauseAll():void
		{
			if (pausedAll)
				return;
			pausedAll=true;
			for (var id:String in playingSounds)
			{
				var o:Object=playingSounds[id];
				var sc:SoundChannel=o.channel;
				sc.stop();
				playingPosition[id]=sc.position;
			}
		}

		public function resumeAll():void
		{
			if (!pausedAll)
				return;
			pausedAll=false;
			for (var id:String in playingSounds)
			{
				var o:Object=playingSounds[id];
				var s:Sound=o.sound;
				o.channel=s.play(startTime(id), loops(id));
				delete playingPosition[id];
			}
		}

		/**
		 * 清空声音资源
		 * @param id 声音id
		 */
		public function clear(id:String):void
		{
			stop(id);
			delete sounds[id];
		}

		/**
		 * 清空并停止所有声音
		 */
		public function clearAll():void
		{
			var id:String;
			for (id in loadingSounds)
			{
				stop(id);
			}
			for (id in sounds)
			{
				clear(id);
			}
		}

		public function stopAll():void
		{
			var id:String;
			for (id in loadingSounds)
			{
				stop(id);
			}
			for (id in playingSounds)
			{
				stop(id);
			}
		}
	}
}
