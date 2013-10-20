package com.pamakids.models
{

	public class ResultVO
	{
		public function ResultVO(status:Boolean, results:Object=null, errCode:String='')
		{
			this.status=status;
			this.results=results;
			this.errCode=errCode;
		}

		public var status:Boolean;
		private var _results:Object;
		public var reason:String;
		public var errCode:String;
		public var code:String;

		public function getTotal():int
		{
			if (_results && _results.hasOwnProperty('total'))
				return int(_results.total);
			return 0;
		}

		public function get results():Object
		{
			var o:Object;
			if (_results && _results.hasOwnProperty('results'))
				o=_results.results;
			else
				o=_results;
			return o;
		}

		public function set results(value:Object):void
		{
			_results=value;
		}

		public function get errorResult():String
		{
			return results as String;
		}

		public function toString():String
		{
			var s:String;
			for (var p:* in this)
			{
				s+=p + '=' + this[p] + '\n';
			}
			return s;
		}
	}
}
