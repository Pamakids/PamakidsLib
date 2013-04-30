package com.pamakids.sqlite.events
{
	import flash.events.Event;
	
	public class DatabaseSuccessEvent extends Event 
	{
		/**
		 *  Holds the event string names
		 */		
		public static const COMMAND_EXEC_SUCCESSFULLY:String = "commandExecSuccesfully";
		public static const DATABASE_CONNECTED_SUCCESSFULLY:String = "databaseConnectedSuccessfully";
		public static const DATABASE_READY:String = "databaseReady";
		public static const CREATING_DATABASE:String = "creatingDatabase";		
		
		/**
		 * Holds a message
		 */			
		public var message:String;
		
		/**
		 * Default constructor
		 *  
		 * @param type	event name
		 * @param message	holds a message
		 * 
		 */			
		public function DatabaseSuccessEvent(type:String, message:String="")
		{
			super(type);
			this.message = message;
		}
	}
}