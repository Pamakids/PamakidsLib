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
				result=hours + ":";

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
			var nd:Date=new Date(from.fullYear, from.month, from.date);
			for (var i:int=1; i < 365; i++)
			{
				if (nd.getFullYear() == end.getFullYear() && nd.getMonth() == end.getMonth() && nd.getDate() == end.getDate())
					break;
				nd.date++;
			}
			return i;
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
