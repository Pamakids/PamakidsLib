package com.pamakids.utils
{

	public class DateUtil
	{
		public function DateUtil()
		{
		}

		/**
		 * 将秒格式化为HH:MM:SS
		 * @param value 秒
		 * @return
		 *
		 */
		public static function formateTime(value:Number):String
		{
			value=Math.round(value);

			var hours:uint=Math.floor(value / 3600) % 24;
			var minutes:uint=Math.floor(value / 60) % 60;
			var seconds:uint=value % 60;

			var result:String="";
			if (hours != 0)
				result=(hours >= 10 ? hours : '0' + hours) + ":";

			if (result && minutes < 10)
				result+="0" + minutes + ":";
			else
				result+=minutes + ":";

			if (seconds < 10)
				result+="0" + seconds;
			else
				result+=seconds;

			return result;
		}

		/**
		 * HH:MM:SS
		 * @param hhmmss
		 * @return Date
		 *
		 */
		public static function getDateByHHMMSS(hhmmss:String):Date
		{
			var d:Date;
			try
			{
				d=new Date();
				var arr:Array=hhmmss.split(':');
				if (arr.length == 3)
					d.setHours(arr[0], arr[1], arr[2], 0);
				else
					d.setHours(arr[0], arr[1], 0, 0);
			}
			catch (error:Error)
			{
			}
			return d;
		}

		/**
		 * 获取时:分:秒
		 * @param date
		 * @return 10:10:10
		 */
		public static function getHMS(date:Date):String
		{
			var hours:uint=date.getHours();
			var minutes:uint=date.getMinutes();
			var seconds:uint=date.getSeconds();

			var result:String="";
			result=(hours >= 10 ? hours : '0' + hours) + ":";

			if (result && minutes < 10)
				result+="0" + minutes + ":";
			else
				result+=minutes + ":";

			if (seconds < 10)
				result+="0" + seconds;
			else
				result+=seconds;

			return result;
		}

		/**
		 * 获取开始到结束之间的天数
		 */
		public static function getInDays(from:Date, end:Date):int
		{
			if (!from || !end)
				return 0;
			var nd:Date=new Date(from.fullYear, from.month, from.date);
			for (var i:int=1; i < 365; i++)
			{
				if (nd.getFullYear() == end.getFullYear() && nd.getMonth() == end.getMonth() && nd.getDate() == end.getDate())
					break;
				nd.date++;
			}
			return i;
		}

		/**
		 * 判断两个日期是否相等
		 * @param date1 日期1
		 * @param date2 日期2
		 * @param judgeAll 判断日期的所有部分，默认为false，只判断年月日
		 * @return
		 */
		public static function dateIsEqual(date1:Date, date2:Date, judgeAll:Boolean=false):Boolean
		{
			if (!date1 || !date2)
				return false;
			return date1.fullYear == date2.fullYear && date1.month == date2.month && date1.date == date2.date;
		}

		public static function isInDates(from:Date, end:Date, date:Date):Boolean
		{
			return date.time >= from.time && date.time <= end.time;
		}

		public static function getDateString(todayOffset:int=0, monthOffset:int=0, includeHMS:Boolean=false):String
		{
			var dateString:String;

			var date:Date=new Date();
			date.date+=todayOffset;
			date.month+=monthOffset;
			dateString=date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
			if (includeHMS)
				dateString+='-' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();

			return dateString;
		}

		public static function get24Times():Array
		{
			var s:String;
			var ac:Array=[];
			for (var i:int; i < 24; i++)
			{
				if (i < 10)
				{
					s='0' + i + ':00';
				}
				else
				{
					s=i + ':00';
				}
				ac.push(s);
			}
			return ac;
		}

		public static function getNianYue(date:Date):String
		{
			return date.fullYear + '年' + (date.month + 1) + '月';
		}

		/**
		 * 获取年月日
		 * @param date 当前日期
		 * @param dateOffset 变差天数
		 * @return 年/月/日
		 */
		public static function getYMD(date:Date, dateOffset:int=0):String
		{
			if (!date)
				return '';
			date.date+=dateOffset;
			return date.fullYear + '/' + (date.month + 1) + '/' + date.date;
		}

		public static function getDatesBetween(from:Date, end:Date):Array
		{
			if (!from || !end)
				return null;
			var arr:Array=[];
			var nd:Date=new Date(from.fullYear, from.month, from.date);
			for (var i:int=1; i < 365; i++)
			{
				arr.push(new Date(nd.getFullYear(), nd.getMonth(), nd.getDate()));
				if (nd.getFullYear() == end.getFullYear() && nd.getMonth() == end.getMonth() && nd.getDate() == end.getDate())
					break;
				nd.date++;
			}
			return arr;
		}

		public static function getDateData(date:Date):Array
		{
			var ac:Array=[];

			var td:Date=new Date(date.fullYear, (date.month + 1), 0);
			var i:int=1;
			var d:Date=new Date(date.fullYear, date.month, i);
			for (var j:int=0; j < d.day; j++)
			{
				ac.push(null);
			}
			ac.push(d);
			i++;
			for (i; i <= td.date; i++)
			{
				d=new Date(date.fullYear, date.month, i);
				ac.push(d);
			}

			return ac;
		}

		public static function clone(date:Date):Date
		{
			return new Date(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds(), date.getMilliseconds());
		}
	}
}


