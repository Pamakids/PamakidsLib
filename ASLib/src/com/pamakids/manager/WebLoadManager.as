package com.pamakids.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 文件加载管理
	 * @author mani
	 */
	public class WebLoadManager
	{

		public static const BITMAP:String="BITMAP";
		public static const SWF:String="SWF";

		private var bigDataFormates:Array;

		private static var _instance:WebLoadManager;

		public function get errorHandler():Function
		{
			return _errorHandler;
		}

		private var errorHandlers:Array;

		public function set errorHandler(value:Function):void
		{
			_errorHandler=value;
			if (!errorHandlers)
				errorHandlers=[];
			if (value != null)
				errorHandlers.push(value);
		}

		public static function get instance():WebLoadManager
		{
			if (!_instance)
				_instance=new WebLoadManager();
			return _instance;
		}

		public function WebLoadManager()
		{
			loaderDic=new Dictionary();
			loadingDic=new Dictionary();
			loadedDic=new Dictionary();
			onCompleteDic=new Dictionary();
			completeParamsDic=new Dictionary();
			bigDataFormates=[BITMAP, SWF];
		}

		private var _errorHandler:Function;

		private var completeParamsDic:Dictionary; //加载完成后回调函数的参数字典

		private var loadedDic:Dictionary; //已经加载的数据字典

		private var loaderDic:Dictionary; //Loader字典

		private var loaderFormate:Dictionary=new Dictionary();

		private var loadingDic:Dictionary; //正在加载字典

		private var onCompleteDic:Dictionary; //加载完成后回调函数字典

		public function loadText(url:String, onComplete:Function, savePath:String=''):void
		{
			load(url, onComplete, savePath, null, null, false, URLLoaderDataFormat.TEXT);
		}

		public function loadSWF(url:String, onComplete:Function, savePath:String=''):void
		{
			load(url, onComplete, savePath, null, null, false, SWF);
		}

		public function loadImage(url:String, onComplete:Function, savePath:String=''):void
		{
			load(url, onComplete, savePath, null, null, false, BITMAP);
		}

		/**
		 *  *
		 * load（）：分为五部分
		 * <li>1：在本地找，</li>
		 * 2：在应用缓存去找
		 * 3：前面都没有的情况下就正式加载，
		 * onBinaryLoaded（）：加载完成，注意清除侦听事件，
		 * 4在加载完成事件里村道应用缓存里，也就是loadedDic里
		 * 5存到本地文件，通过FileManager.saveFile();
		 *
		 * 然后就是清理工作，把用到的字典都删除掉。
		 * 然后执行每个回调函数
		 * 二：判断类型formate是否等于bitmap，如果是就执行loader（）
		 *
		 * 添加loaderonComplete，
		 * 执行回调函数，f（);*
		 * @param url url地址
		 * @param onComplete 加载完成回调函数
		 * @param savePath //存储路径
		 * @param params //传递的参数
		 * @param loadingCallBack //加载的回调函数
		 * @param formate 加载文件的格式
		 */
		public function load(url:String, onComplete:Function, savePath:String=null, params:Array=null, loadingCallBack:Function=null, forceReload:Boolean=false, formate:String=URLLoaderDataFormat.BINARY):void
		{
			var b:ByteArray;
			var u:URLLoader=loadingDic[url];
			var arr:Array;

			//如果有正在加载的，则把加载完成的回调函数添加到数组里
			if (u)
			{
				arr=loaderDic[u];
				if (arr && arr.indexOf(onComplete) == -1)
					arr.push(onComplete);
				return;
			}

			if (!forceReload)
			{
				b=loadedDic[url] as ByteArray;

				//如果从程序缓存里找到了已加载的数据，则返回
				if (b)
				{
					b.position=0;
					params ? onComplete(b, params) : onComplete(b);
					return;
				}
			}

			//开始加载
			u=new URLLoader();
			loaderFormate[u]=formate;
			loadingDic[url]=u;
			loaderDic[u]=[onComplete];
			if (bigDataFormates.indexOf(formate) != -1)
				formate=URLLoaderDataFormat.BINARY;
			u.dataFormat=formate;
			u.load(new URLRequest(url));
			completeParamsDic[u]=params;
			u.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			u.addEventListener(Event.COMPLETE, onBinaryLoaded);

			if (loadingCallBack != null)
				u.addEventListener(ProgressEvent.PROGRESS, loadingCallBack);
		}

		protected function contentLoadedHandler(event:Event):void
		{
			var l:LoaderInfo=event.target as LoaderInfo;
			l.removeEventListener(Event.COMPLETE, contentLoadedHandler);
			var callbacks:Object=loaderDic[l.loader];
			delete loaderDic[l.loader];

			var params:Array;

			//每个回调函数都调用
			params=completeParamsDic[l.loader];
			delete completeParamsDic[l.loader];
			if (callbacks is Array)
			{
				var bitmap:Bitmap=l.content as Bitmap;
				var returnContent:DisplayObject;
				for each (var f:Function in callbacks)
				{
					if (bitmap)
						returnContent=new Bitmap(bitmap.bitmapData.clone());
					else
						returnContent=l.content;
					params ? f(returnContent, params) : f(returnContent);
				}
			}
			else if (callbacks is Function)
			{
				callbacks(l.content);
			}
		}

		public function loadContentFromByteArray(byteArray:ByteArray, callback:Function):void
		{
			var l:Loader=new Loader();
			var lc:LoaderContext=new LoaderContext(false, ApplicationDomain.currentDomain, null);
			lc.imageDecodingPolicy=ImageDecodingPolicy.ON_LOAD;
			lc.allowCodeImport=true;
			lc.allowLoadBytesCodeExecution=true;
			loaderDic[l]=callback;
			l.loadBytes(byteArray, lc);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadedHandler);
		}

		private function getContentFromByteArray(byteArray:ByteArray, callbacks:Array=null, params:Array=null):void
		{
			var l:Loader=new Loader();
//			var lc:LoaderContext=new LoaderContext(false, ApplicationDomain.currentDomain, null);
//			lc.imageDecodingPolicy=ImageDecodingPolicy.ON_LOAD;
//			lc.allowCodeImport=true;
//			lc.allowLoadBytesCodeExecution=true;
			loaderDic[l]=callbacks;
			l.loadBytes(byteArray);
			completeParamsDic[l]=params;
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadedHandler);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('Load IO Error: ' + event.toString());
			var u:URLLoader=event.currentTarget as URLLoader;
			delete loadingDic[u];
			delete loaderDic[u];
			delete loaderFormate[u];
			delete completeParamsDic[u];
			if (errorHandlers)
			{
				for each (var f:Function in errorHandlers)
				{
					f();
				}
				errorHandlers=null;
			}
		}

		private function onBinaryLoaded(event:Event):void
		{
			var u:URLLoader=event.target as URLLoader;
			u.removeEventListener(Event.COMPLETE, onBinaryLoaded);
			var f:Function;
			var arr:Array=loaderDic[u];
			var params:Array;

			var b:ByteArray=u.data as ByteArray;
			if (b && b.length == 0)
				return;

			var formate:String=loaderFormate[u];
			//将加载的数据存到应用缓存里
			for (var key:String in loadingDic)
			{
				if (loadingDic[key] == u)
				{
					if (bigDataFormates.indexOf(formate) == -1)
						loadedDic[key]=u.data;
					delete loadingDic[key];
					break;
				}
			}

			delete loaderDic[u];
			delete loaderFormate[u];
			params=completeParamsDic[u];
			delete completeParamsDic[u];
			if (bigDataFormates.indexOf(formate) != -1 && b)
			{
				getContentFromByteArray(b, arr, params);
				return;
			}

			//每个回调函数都调用
			for each (f in arr)
			{
				params ? f(u.data, params) : f(u.data);
			}
		}
	}
}