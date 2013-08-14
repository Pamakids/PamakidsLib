package com.pamakids.utils
{

	/**
	 * 跟Nodejs后台交互时使用
	 * @author mani
	 *
	 */
	public class NodeUtil
	{
		public function NodeUtil()
		{
		}

		public static function getTime(time:String):String
		{
			return time ? time.split('T')[0] : null;
		}

		public static function getDateByString(date:String):Date
		{
			var arr:Array=date.split('-');
			return new Date(arr[0], int(arr[1]) - 1, arr[2]);
		}

		public static function setTime(date:Date, dateOffset:int=0):String
		{
			if (dateOffset)
				date.date+=dateOffset;
			var m:int=date.getMonth() + 1;
			var month:String=m < 10 ? '0' + m : '' + m;
			var d:int=date.getDate();
			var ds:String=d < 10 ? '0' + d : '' + d;
			return date ? date.getFullYear() + '-' + month + '-' + ds : '';
		}

		public static function getInDates(from:String, end:String):Array
		{
			var arr:Array=[];

			var f:Date=getDateByString(from);
			var e:Date=getDateByString(end);
			for (var i:int; i < 365; i++)
			{
				arr.push(f);
				if (f.fullYear == e.fullYear && f.month == e.month && f.date == e.date)
					break;
				f.date++;
			}

			return arr;
		}
	}
}
