package services
{
	import com.pamakids.util.Base64;
	import com.pamakids.util.CloneUtil;

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

	import model.Errors;
	import model.ResultVO;

	public class ServiceBase
	{
		public static var HOST:String;
		private var url:String;
		private var authHeader:URLRequestHeader;
		protected var method:String;
		protected var headers:Array;
		protected var formate:String;
		public static var id:String;

		private var _uri:String;

		public function ServiceBase(uri:String='', method:String='get', formate:String='text')
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
			l.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
		}

		private function getGetParams(data:Object):String
		{
			var arr:Array=[];
			if (data)
			{
				for (var key:String in data)
				{
					arr.push(key + '=' + data[key]);
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
				if (status == 502)
					message=Errors.getMessage(Errors.NO_NETWORK);
				else
					message=Errors.getMessage(status.toString());
				callbackDic[l](new ResultVO(false, message, status.toString()));
				delete callbackDic[l];
			}
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
			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
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
			var result:Object=formate == 'text' ? JSON.parse(l.data) : l.data;
			var vo:ResultVO;
			if (result is String)
				vo=new ResultVO(true, result.toString());
			else
				vo=new ResultVO(result.status, result.results);
			vo.reason=result.hasOwnProperty('reason') ? result.reason : '';
			callbackDic[l](vo);
			delete callbackDic[l];
		}
	}
}

