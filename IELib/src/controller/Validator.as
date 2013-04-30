package controller
{
	import model.ResultVO;
	import model.users.UserVO;

	public class Validator
	{

		public static function validateLogin(value:UserVO):ResultVO
		{
			var vo:ResultVO=validateUsername(value.name);
			if (!vo.status)
				return vo;
			vo=validatePassword(value.password);
			return vo;
		}

		private static function validateUsername(value:String):ResultVO
		{
			var vo:ResultVO;
			if (!value)
				vo=new ResultVO(false, '用户名不能为空');
			else if (value.length < 2 || value.length > 15)
				vo=new ResultVO(false, '用户名长度必须在2-15个字符之间');
			else
				vo=new ResultVO(true);
			return vo;
		}

		private static function validatePassword(value:String):ResultVO
		{
			var vo:ResultVO;
			if (!value)
				vo=new ResultVO(false, '密码不能为空');
			else if (value.length < 6 || value.length > 15)
				vo=new ResultVO(false, '密码长度必须在6-15个字符之间');
			else
				vo=new ResultVO(true);
			return vo;
		}

	}
}
