package com.pamakids.models
{

	public class Errors
	{
		/**
		 * 插入数据重复
		 */
		public static const DUPLICATE:String="11000";
		/**
		 * 非法字符，用户名不能含@符
		 */
		public static const INVALID_SYMPOL:String="3";
		/**
		 * 已经超过最大登陆尝试次数
		 */
		public static const MAX_ATTEMPTS:String="2";
		/**
		 * 密码错误
		 */
		public static const PASSWORD_INCORRECT:String="1";
		/**
		 * 用户不存在
		 */
		public static const NOT_FOUND:String="0";

		public static const NO_NETWORK:String="NO_NETWORK";

		public static function getMessage(error:String):String
		{
			var message:String;

			switch (error)
			{
				case '502':
					message='网络连接失败，请检查网络连接，稍后再试';
					break;
				case '400':
					message='您填写的数据不对，请查证后再试';
					break;
				case '401':
					message='太长时间没有操作，验证失败，请登陆后再试';
					break;
				default:
					message='网络连接失败，请稍后再试';
					break;
			}

			return message;
		}
	}
}

