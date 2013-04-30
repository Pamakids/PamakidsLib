package controller
{
	import com.pamakids.utils.Singleton;

	public class HotAreaController extends Singleton
	{
		private static var _instance:HotAreaController;

		public static function get instance():HotAreaController
		{
			return Singleton.getInstance(HotAreaController);
		}


	}
}

