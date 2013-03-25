package com.pamakids.manager
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 文件加载管理
	 * @author mani
	 * 
	 */
	public class LoadManager
	{

		public static const BITMAP:String="BITMAP";
		private static var _instance:LoadManager;

		public static function get instance():LoadManager
		{
			if (!_instance)
				_instance=new LoadManager();
			return _instance;
		}

		public function LoadManager()
		{//初始化各种变量:存东西数组有顺序 哈希表没顺序
			loaderDic=new Dictionary();
			loadingDic=new Dictionary();
			loadedDataPool=new Dictionary();
			savePathDic=new Dictionary();
			completedActionSet=new Dictionary();
			completeParamsDic=new Dictionary();//为什么一个简单的参数还需要单独去存?;
		}
		private var completeParamsDic:Dictionary; //加载完成后回调函数的参数字典//
		private var loadedDataPool:Dictionary; //已经加载的数据字典

		private var loaderDic:Dictionary; //Loader字典
		private var loaderFormat:Dictionary=new Dictionary();
		private var loadingDic:Dictionary; //正在加载字典
		private var completedActionSet:Dictionary; //加载完成后回调函数字典
		private var savePathDic:Dictionary; //存储路径字典

		/**
		 * 加载
		 * @param url url地址
		 * @param onComplete 加载完成回调函数
		 * @param savePath //存储路径
		 * @param params //传递的参数
		 * @param loadingCallBack //加载的回调函数
		 * @param formate 加载文件的格式
		 */
		public function load(url:String, onComplete:Function, savePath:String=null, params:Array=null, loadingCallBack:Function=null, forceReload:Boolean=false, format:String=URLLoaderDataFormat.BINARY):void
		{
			var b:ByteArray;

			//如果有存储路径，先去本地缓存找是否有
			if (savePath)//一个return会一直load下去,两个return条件会更严密?//save path 本来是没有的怎么能拿来做判断?
			{
				var cachedData:Object=FileManager.readFile(savePath);
				if(cachedData is ByteArray)//bytearray 和bitmap的关系
					cachedData = cachedData as ByteArray;
				if(cachedData)
				{
					params ? onComplete(cachedData, params) : onComplete(cachedData);
					return;//params究竟在干什么
				}
				
				/*b= cachedData as ByteArray;
				if (b)
				{
					if (params)
						onComplete(b, params);
					else
						onComplete(b);
					//return;
				}
				else if (cachedData)
				{
					if (params)
						onComplete(cachedData, params);
					else
						onComplete(cachedData);
					//return;
				}
				return*/
			}

			var URLloaderInLoading:URLLoader=loadingDic[url];//难道有无数个urlloader需要存起来?
			completeParamsDic[onComplete]=params;

			//如果有正在加载的，则把加载完成的回调函数添加到数组里
			if (URLloaderInLoading)
			{
				var arr:Array=loaderDic[URLloaderInLoading];
				if (arr.indexOf(onComplete) == -1)
					arr.push(onComplete);
				return;
			}

			if (!forceReload)//所有的这些判断 好像都有问题,凭什么认定括号里所指的就是自己想要的;
			{
				b=loadedDataPool[url] as ByteArray;

				//如果从程序缓存里找到了已加载的数据，则返回
				if (b)
				{
					if (params)
					{
						trace("ImageCache - Load Cached image  from : ");
						onComplete(b, params);
						delete completeParamsDic[onComplete];
					}
					else
					{
						onComplete(b);
					}
					return;
				}
			}

//开始加载---------------------------------------------------------------------------------------------------
			URLloaderInLoading=new URLLoader();
			
			loaderFormat[URLloaderInLoading]=format;
			loadingDic[url]=URLloaderInLoading;//为什么不写成loaderFormat[[loadingDic[url]]
			
			if (savePath)
				savePathDic[URLloaderInLoading]=savePath;
			loaderDic[URLloaderInLoading]=[onComplete];
			if (format == BITMAP)
				format=URLLoaderDataFormat.BINARY;
			URLloaderInLoading.dataFormat=format;//反复无常的给format赋值 究竟有何用意?
			URLloaderInLoading.load(new URLRequest(url));
			completeParamsDic[URLloaderInLoading]=params;
			//dataInLoading.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			URLloaderInLoading.addEventListener(Event.COMPLETE, onBinaryLoaded);
			if (loadingCallBack)
			{
				URLloaderInLoading.addEventListener(ProgressEvent.PROGRESS, loadingCallBack);
			}
		}
//----------------------------------------------------------------------------------------------------------
		protected function onLoaded(event:Event):void
		{
			var l:LoaderInfo=event.target as LoaderInfo;
			l.removeEventListener(Event.COMPLETE, onLoaded);
			var callbacksContainer:Array=loaderDic[l.loader];
			delete loaderDic[l.loader];

			var params:Array;

			//每个回调函数都激活
			params=completeParamsDic[l.loader];
			delete completeParamsDic[l.loader];
			for each (var f:Function in callbacksContainer)
			{
				
				if (params)
				{
					f(l.content, params);//这里的参数是干嘛的
				}
				else
				{
					f(l.content);
				}
			}
		}
// decoding
		private function getBitmapFromByteArray(byteArray:ByteArray, callbacks:Array=null, params:Array=null):void
		{//为什么不返回呢?为什么不静态呢?
			var l:Loader=new Loader();
			loaderDic[l]=callbacks;
			l.loadBytes(byteArray);//为什么要loadbytes
			completeParamsDic[l]=params;//params
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
		}

		/*private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace('load io error');
			if (errorHandler != null)
				errorHandler();
		}*/
		private function onBinaryLoaded(event:Event):void
		{
			var u:URLLoader=event.target as URLLoader;
			u.removeEventListener(Event.COMPLETE, onBinaryLoaded);
			var f:Function;
			var arr:Array=loaderDic[u];//这个arr装的是-----
			var params:Array;

			var b:ByteArray=u.data as ByteArray;//undefined也能过去?
			if (b && b.length == 0)
				return;

			//将加载的数据存到项目缓存里
			for (var key:String in loadingDic)
			{
				if (loadingDic[key] == u)//主要是if里面的判断句觉得不成立
				{
					loadedDataPool[key]=u.data;
					delete loadingDic[key];
					break;
				}
			}

			//将加载数据存到本地文件
			var savePath:String=savePathDic[u];
			if (savePath)
			{
				FileManager.saveFile(savePath, u.data);
				delete savePathDic[u];
			}
			delete loaderDic[u];
			var format:String=loaderFormat[u];
			delete loaderFormat[u];
			params=completeParamsDic[u];//这次怎么不用dictionary了?这个array装的是---
			delete completeParamsDic[u];
			if (format == BITMAP && b)
			{
				getBitmapFromByteArray(b, arr, params);//这个括号里已经有两个array了要这么多array干嘛?
				return;
			}

			//每个回调函数都调用
			for each (f in arr)
			{
				params?f(u.data,params):f(u.data);
			}
		}
	}
}