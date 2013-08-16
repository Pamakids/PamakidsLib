package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
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
		private var sounds:Vector.<Sound>;
		private var playingSounds:Dictionary;
		private var loadingSounds:Vector.<Sound>;
		/**
		 * 记录声音播放位置，方便暂停后继续播放
		 */
		private var playingPosition:Vector.<Number>;
		private var config:Object;

		public function SoundManager()
		{
			sounds=new Vector.<Sound>();
			playingSounds=new Dictionary();
			loadingSounds=new Vector.<Sound>();
			playingPosition=new Vector.<Number>();
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
		 * @param sound 声音对象
		 */
		public function addSound(id:String, sound:Sound):void
		{
			sounds[id]=sound;
		}

		/**
		 * 配置文件里会包含播放次数，url等信息
		 * @param id 播放id
		 * @param times 播放次数
		 */
		public function play(id:String, times:int=0):void
		{
			var s:Sound=sounds[id];
			var o:Object=config[id];
			if (playingSounds[id])
			{
				if (playingPosition[id] != null)
				{
					o=playingSounds[id];
					s=o.sound;
					o.channel=s.play(playingPosition[id], loops(id));
					trace('Sound ' + id + ' is replaying');
				}
				else
				{
					trace('Sound ' + id + ' is playing');
				}
				return;
			}
			if (s)
			{
				var sc:SoundChannel=s.play(times ? times : startTime(id), loops(id));
				sc.addEventListener(Event.SOUND_COMPLETE, playedHandler);
				playingSounds[id]={channel: sc, sound: s, volume: 1};
			}
			else
			{
				if (!o)
				{
					throw new Error('Sound:' + id + ' is not added or configed');
				}
				else
				{
					s=new Sound();
					s.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					s.addEventListener(ProgressEvent.PROGRESS, progressHandler);
					loadingSounds[id]=s;
					s.load(new URLRequest(o.url));
				}
			}
		}

		protected function playedHandler(event:Event):void
		{
			for (var id:String in playingSounds)
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
			if (loadingSounds)
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
				if(
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
