package model
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
		public var results:Object;
		public var reason:String;
		public var errCode:String;

		public function toString()
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
