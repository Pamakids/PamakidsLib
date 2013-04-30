package controller
{
	import com.pamakids.utils.Singleton;

	import flash.net.URLRequestMethod;

	import model.ResultVO;
	import model.Routes;
	import model.users.UserVO;

	import services.ServiceBase;
	import services.SignUpService;

	public class ServiceController extends Singleton
	{
		private var serviceBase:ServiceBase;
		public var useOffline:Boolean;

		public function ServiceController()
		{
		}

		public function signUp(vo:UserVO, callback:Function):void
		{
			var ss:SignUpService=new SignUpService();
			ss.call(callback, vo);
		}

		public function login(vo:UserVO, callback:Function):void
		{
			serviceBase=new ServiceBase(Routes.ADMIN_SIGN_IN, URLRequestMethod.POST);
			serviceBase.validateFun=validateLogin;
			serviceBase.call(callback, vo);
		}

		private function validateLogin(callback:Function, data:UserVO):Boolean
		{
			var vo:ResultVO=Validator.validateLogin(data);
			if (!vo.status)
				callback(vo);
			return vo.status;
		}

		public static function get instance():ServiceController
		{
			return Singleton.getInstance(ServiceController);
		}
	}
}
