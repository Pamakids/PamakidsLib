package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;

	import flash.events.Event;
	import flash.net.Socket;

	public class SocketManager extends Singleton
	{

		private var socket:Socket;

		public function SocketManager()
		{
			socket=new Socket();
			socket.addEventListener(Event.CONNECT, function(e:Event):void
			{

			});
		}

		public static function get instance():SocketManager
		{
			return Singleton.getInstance(SocketManager);
		}
	}
}
