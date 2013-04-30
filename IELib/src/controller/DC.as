package controller
{
	import com.pamakids.utils.Singleton;

	import model.users.UserVO;

	public class DC extends com.pamakids.utils.Singleton
	{

		public function get admin():UserVO
		{
			return _admin;
		}

		public function set admin(value:UserVO):void
		{
			_admin=value;
		}

		public static function get i():DC
		{
			return Singleton.getInstance(DC);
		}

		private var _admin:UserVO;
		public var user:UserVO;
	}
}
