package com.pamakids.sqlite.events
{
	import flash.events.Event;
	
	public class StatementCompleteEvent extends Event 
	{
		/**
		 *  Holds the event string name
		 */		
		public static const COMMAND_EXEC_SUCCESSFULLY:String = "commandExecSuccesfully";
		
		/**
		 * Holds results object 
		 */			
		public var results:Object;
		
		/**
		 * In case user sets the name of the originated user gesture that sets the event 
		 */		
		public var userGestureName:String;
		
		/**
		 * The data of results 
		 */
		public var data:Object;
		
		/**
		 * Default constructor
		 *  
		 * @param type	event name
		 * @param holds the results object
		 * 
		 */			
		public function StatementCompleteEvent(type:String, results:Object, userGestureName:String)
		{
			this.results = results;
			data = results.hasOwnProperty('data') ? results.data : results;
			this.userGestureName = userGestureName;
			super(type);
		}
	}
}