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

		public static function getDateString(todayOffset:int=0, monthOffset:int=0):String
		{
			var dateString:String;

			var date:Date=new Date();
			date.date+=todayOffset;
			date.month+=monthOffset;
			dateString=date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();

			return dateString;
		}
	}
}
