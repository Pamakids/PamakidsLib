package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;

	public class PageManager extends Singleton
	{
		public static function get instance():PageManager
		{
			return Singleton.getInstance(PageManager);
		}

		/**
		 * 
		 * @param side 
		 * 
		 */		
		public function startPageFlip(side:uint):void
		{

		}
	}
}
