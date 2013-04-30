package com.pamakids.util
{
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;

	public class DateUtil
	{

		/*'2010-02-11 11:06:12'*/
		public static function getDateByString(s:String):Date
		{
			var d:Date=DateFormatter.parseDateString(s);
			return d;
		}

		public static function getDateStringByDate(date:Date):String
		{
			var formatterString:String="YYYY-MM-DD HH:NN:SS";
			var dateFormatter:DateFormatter=new DateFormatter();
			dateFormatter.formatString=formatterString;
			return dateFormatter.format(date);
		}

		public static function getYMD(date:Date):String
		{
			var formatterString:String="YYYY-MM-DD";
			var dateFormatter:DateFormatter=new DateFormatter();
			dateFormatter.formatString=formatterString;
			return dateFormatter.format(date);
		}

		public static function isSame(d1:Date, d2:Date):Boolean
		{
			return d1.fullYear == d2.fullYear && d1.month == d2.month && d1.date == d2.date;
		}

		public static function getNianYue(date:Date):String
		{
			return date.fullYear + '年' + (date.month + 1) + '月';
		}

		public static function getDateData(date:Date):ArrayCollection
		{
			var ac:ArrayCollection=new ArrayCollection();

			var td:Date=new Date(date.fullYear, (date.month + 1), 0);
			var i:int=1;
			var d:Date=new Date(date.fullYear, date.month, i);
			for (var j:int=0; j < d.day; j++)
			{
				ac.addItem(null);
			}
			ac.addItem(d);
			i++;
			for (i; i <= td.date; i++)
			{
				d=new Date(date.fullYear, date.month, i);
				ac.addItem(d);
			}

			return ac;
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
		 * 获取小时、分钟、秒
		 */
		public static function getHMSByDate(date:Date):String
		{
			var formatterString:String="HH:NN:SS";
			var dateFormatter:DateFormatter=new DateFormatter();
			dateFormatter.formatString=formatterString;
			return dateFormatter.format(date);
		}

		public static function checkTimeString(time:String):Boolean
		{
			var ok:Boolean=true;
			if (!time)
			{
				return ok;
			}
			var arr:Array=time.split(',');
			for each (var t:String in arr)
			{
				var a2:Array=t.split('-');
				if (isNaN(Number(a2[0])) || isNaN(Number(a2[1])))
				{
					ok=false;
				}
			}
			return ok;
		}

		public static function get24Times():ArrayCollection
		{
			var s:String;
			var ac:ArrayCollection=new ArrayCollection();
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
				ac.addItem(s);
			}
			return ac;
		}

		public static function getTimes(from:int, to:int, interval:int, exclution:String=''):ArrayCollection
		{
			var hours:Array=[];
			for (var i:int; i < 24; i++)
			{
				hours.push(i);
			}
			var index:int;
			var times:Array=[];
			var exTimes:Array;
			var f1:int;
			var f2:int;
			if (exclution)
			{
				exTimes=[];
				var a1:Array=exclution.split(',');
				for each (var t:String in a1)
				{
					var a2:Array=t.split(['-']);
					f1=int(a2[0]);
					f2=int(a2[1]);
					if (f1 > f2)
					{
						for (f1; f1 <= 23; f1++)
						{
							exTimes.push(f1);
						}
						for (var i2:int; i2 < f2; i2++)
						{
							exTimes.push(i2);
						}
					}
					else
					{
						for (f1; f1 < f2; f1++)
						{
							exTimes.push(f1);
						}
					}
				}
			}
			if (from > to)
			{
				for (from; from <= 23; from++)
				{
					if (exTimes)
					{
						index=exTimes.indexOf(from);
						if (index == -1)
						{
							times.push(from);
						}
					}
					else
					{
						times.push(from);
					}
				}
				for (var i3:int; i3 < to; i3++)
				{
					if (exTimes)
					{
						index=exTimes.indexOf(i3);
						if (index == -1)
						{
							times.push(i3);
						}
					}
					else
					{
						times.push(i3);
					}
				}
			}
			else
			{
				for (from; from <= to; from++)
				{
					if (exTimes)
					{
						index=exTimes.indexOf(from);
						if (index == -1)
						{
							times.push(from);
						}
					}
					else
					{
						times.push(from);
					}
				}
			}
			times.sort(Array.NUMERIC);
			var detailTimes:ArrayCollection=new ArrayCollection();
			var ds:String;
			var hs:String;
			var forTimes:int=60 / interval;
			for each (var hour:int in times)
			{
				var i4:int=0;
				if (hour < 10)
				{
					hs='0' + hour;
				}
				else
				{
					hs=hour.toString();
				}
				if (times.indexOf(hour) == times.length - 1)
				{
					ds=hs + ':00';
					detailTimes.addItem(ds);
				}
				else
				{
					for (i4; i4 < forTimes; i4++)
					{
						var its:String;
						var iti:int=i4 * interval;
						if (iti < 10)
						{
							its='0' + iti;
						}
						else
						{
							its=iti.toString();
						}
						ds=hs + ':' + its;
						detailTimes.addItem(ds);
					}
				}
			}

			return detailTimes;
		}

		public static function getDates(now:Date, from:int, to:int, exclution:String=''):ArrayCollection
		{
			var ac:ArrayCollection=new ArrayCollection();
			var arr:Array;
			var dates:Array;
			if (exclution)
			{
				arr=exclution.split(',');
				for each (var d:String in arr)
				{
					dates=[];
					dates.push(d);
				}
			}
//			for (from; from <= to; from++)
//			{
//				var date:Date=dateAdd(DAY_OF_MONTH, from, now);
//				var ds:String=DateField.dateToString(date, 'YYYY-MM-DD');
//				if (dates)
//				{
//					var index:int=dates.indexOf(ds);
//					if (index == -1)
//					{
//						ac.addItem(ds);
//					}
//				}
//				else
//				{
//					ac.addItem(ds);
//				}
//			}
			return ac;
		}

	}
}


