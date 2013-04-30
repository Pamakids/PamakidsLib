package services
{
	import flash.net.URLRequestMethod;

	import controller.Validator;

	import model.ResultVO;
	import model.Routes;
	import model.users.UserVO;

	public class SignUpService extends ServiceBase
	{
		public function SignUpService()
		{
			super(Routes.ADMIN_SIGN_UP, URLRequestMethod.POST);
		}

		override protected function validateData(callback:Function, data:Object):Boolean
		{
			var vo:ResultVO=Validator.validateLogin(data as UserVO);
			if (!vo.status)
				callback(vo);
			return vo.status;
		}
	}
}

