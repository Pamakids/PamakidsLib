package com.pamakids.sqlite.events
{
	import flash.events.Event;
	
	public class DatabaseFailEvent extends Event 
	{
		/**
		 *  Holds the event string name
		 */		
		public static const DATABASE_FAIL:String = "databaseFail";
		public static const COMMAND_EXEC_FAILED:String = "commandExecFailed";
		
		/**
		 * Holds error message
		 */			
		public var errorMessage:String;
		
		/**
		 * Flag indicates weather the transaction was rolled back because of this error 
		 */		
		public var isRolledBack:Boolean;
		
		/**
		 * Default constructor
		 *  
		 * @param type	event name
		 * @param errorMessage	holds the error message
		 * 
		 */			
		public function DatabaseFailEvent(type:String, errorMessage:String, isRolledBack:Boolean=false)
		{
			this.isRolledBack = isRolledBack;
			this.errorMessage = errorMessage;
			super(type);
		}
	}
}