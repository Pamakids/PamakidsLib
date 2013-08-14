package com.pamakids.services
{
	import com.pamakids.models.Errors;
	import com.pamakids.models.ResultVO;
	import com.pamakids.utils.CloneUtil;
	import com.pamakids.utils.ObjectUtil;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class ServiceBase
	{
		public static var HOST:String;
		private var url:String;
		private var authHeader:URLRequestHeader;
		protected var method:String;
		protected var headers:Array;
		protected var formate:String;
		public static var id:String='';

		public static var showBusy:Function;
		public static var hideBusy:Function;

		private var _uri:String;

		public function ServiceBase(uri:String='', method:String='GET', formate:String='text')
		{
			this.uri=uri;
			callbackDic=new Dictionary(true);
			this.method=method;
			this.formate=formate;
		}

		private var callbackDic:Dictionary;

		public function get uri():String
		{
			return _uri;
		}

		public function set uri(value:String):void
		{
			_uri=value;
			if (!value)
				return;
			if (value.charAt(0) != '/')
				value='/' + value;
			url=HOST + value;
			trace('URL: ' + url);
		}

		public var validateFun:Function;

		protected function validateData(callback:Function, data:Object):Boolean
		{
			var b:Boolean=true;
			if (validateFun != null)
				b=validateFun(callback, data);
			return b;
		}

		protected function getURLVariables(data:Object):URLVariables
		{
			var uv:URLVariables;
			if (data)
			{
				uv=new URLVariables();
				CloneUtil.copyValue(data, uv, true);
			}
			else
			{
				uv=new URLVariables();
			}
			if (ServiceBase.id)
				uv.id=ServiceBase.id;
			return uv;
		}

		public function call(callback:Function, data:Object=null):void
		{
			if (!validateData(callback, data))
				return;
			for each (var f:Function in callbackDic)
			{
				if (f == callback)
					return;
			}
			var l:URLLoader=new URLLoader();
			var ur:URLRequest=getURLRequest();
			if (method == URLRequestMethod.POST)
				ur.data=getURLVariables(data)
			else
				ur.url+=getGetParams(data);
			trace('Call url: ' + ur.url);
			l.load(ur);
			l.dataFormat=formate;
			callbackDic[l]=callback;
			l.addEventListener(Event.COMPLETE, loadedHandler);
			l.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			l.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			l.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
//			l.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);

			if (showBusy != null)
				showBusy();
		}

		private function getGetParams(data:Object):String
		{
			var arr:Array=[];
			if (data)
			{
				var qNames:Array=ObjectUtil.getClassInfo(data).properties as Array;
				for each (var q:QName in qNames)
				{
					var od:Object=data[q.localName];
					if (typeof od == 'object')
					{
						for (var p:* in od)
						{
							arr.push(p + '=' + od[p]);
						}
					}
					else
					{
						arr.push(q.localName + '=' + od);
					}
				}
			}
			arr.push('id=' + id);
			return '?' + arr.join('&');
		}

		protected function getURLRequest(data:Object=null):URLRequest
		{
			var u:URLRequest=new URLRequest();
			u.requestHeaders=headers;
			u.method=method;
			u.data=data;
			u.url=url;
			return u;
		}

//		http://localhost:9050/admin/users?page=1&perPage=1

		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			onError(event);
		}

		private function onError(event:Event, removeListeners:Boolean=true, status:int=0):void
		{
			var l:URLLoader=event.target as URLLoader;
			if (removeListeners)
				removeEventListeners(l);
			trace('Error:', l.data);
			if (callbackDic[l])
			{
				var message:String;
				message=Errors.getMessage(status.toString());
				callbackDic[l](new ResultVO(false, message, status.toString()));
				delete callbackDic[l];
			}
			if (hideBusy != null)
				hideBusy();
		}

		protected function onHttpStatus(event:HTTPStatusEvent):void
		{
			var status:int=event.status;
			if (status && status != 200)
			{
				trace('HttpStatus Error:' + status);
				onError(event, false, status);
			}
		}

		private function removeEventListeners(loader:URLLoader):void
		{
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
//			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			loader.removeEventListener(Event.COMPLETE, loadedHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			onError(event);
		}

		protected function loadedHandler(event:Event):void
		{
			var l:URLLoader=event.target as URLLoader;
			removeEventListeners(l);

			if (l.data)
			{
				var result:Object=formate == 'text' ? JSON.parse(l.data) : l.data;
				var vo:ResultVO;
				if (result is String)
					vo=new ResultVO(true, result.toString());
				else
					vo=new ResultVO(result.status, result.results, result.code);
				vo.reason=result.hasOwnProperty('reason') ? result.reason : '';
			}
			else
			{
				vo=new ResultVO(false);
			}
			callbackDic[l](vo);
			delete callbackDic[l];
			if (hideBusy != null)
				hideBusy();
		}
	}
}

