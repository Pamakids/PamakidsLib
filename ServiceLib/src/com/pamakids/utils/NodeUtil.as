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

		public static function getTimeDate(time:String):Date
		{
			return getDateByString(getTime(time));
		}

		/**
		 * @param time
		 * @return 2014-1-1
		 *
		 */
		public static function getTime(time:String):String
		{
			return time ? time.split('T')[0] : null;
		}

		/**
		 *
		 * @param time
		 * @return 2014-1-1 12:60:60
		 *
		 */
		public static function getTimeDetail(time:String):String
		{
			var a1:Array=time.split('T');
			var ymd:String=a1[0];
			var hms:String=a1[1].split('.')[0];
			return time ? ymd + ' ' + hms : null;
		}

		/**
		 * 根据日期字符串获得Date
		 * @param date 格式如：2013-08-30 或 2013-08-30 23:25:24
		 */
		public static function getDateByString(date:String):Date
		{
			if (!date)
				return null;
			var d:Date;
			var arr:Array;
			if (date.indexOf(' ') != -1)
			{
				arr=date.split(' ');
				var a1:Array=arr[0].split('-'); //年月日
				var a2:Array=arr[1].split(':'); //时分秒
				d=new Date(a1[0], int(a1[1]) - 1, a1[2], a2[0], a2[1], a2[2]);
			}
			else if (date.indexOf('-') != -1)
			{
				arr=date.split('-');
				d=new Date(arr[0], int(arr[1]) - 1, arr[2]);
			}
			return d;
		}

		/**
		 * 根据NodeJS后台返回的日期字符串获得本地Date
		 * @param date 格式如：2014-05-31T16:00:00.000Z
		 */
		public static function getLocalDate(date:Object):Date
		{
			if (date is Date)
				return date as Date;
			var d:Date;
			if (date)
			{
				try
				{
					var arr:Array=date.split('T');
					var a1:Array=arr[0].split('-');
					var a2:Array=arr[1].split('.')[0].split(':');
					d=new Date(a1[0], parseInt(a1[1]) - 1, a1[2], a2[0], a2[1], a2[2]);
					d.minutes-=d.getTimezoneOffset()
				}
				catch (error:Error)
				{
					trace('get local date error', error);
				}
			}
			return d;
		}

//		public static function getLocalDate():Date
//		{
//
//		}

		/**
		 * 获得NodeJS的日期时间字符串
		 * @param date
		 * @param dateOffset
		 * @return
		 */
		public static function setTime(date:Date, dateOffset:int=0):String
		{
			if (dateOffset)
				date.date+=dateOffset;
			var m:int=date.getMonth() + 1;
			var month:String=m < 10 ? '0' + m : '' + m;
			var d:int=date.getDate();
			var ds:String=d < 10 ? '0' + d : '' + d;
			var ymd:String=date.getFullYear() + '-' + month + '-' + ds; //年月日
			return date ? ymd : '';
		}

		public static function getInDates(from:String, end:String):Array
		{
			return DateUtil.getDatesBetween(getDateByString(from), getDateByString(end));
		}
	}
}


