package com.collectivecolors.extensions.flex3.drupal.model.services
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.extensions.flex3.drupal.model.data.UserVO;
	import com.collectivecolors.rpc.IServiceAgent;
	import com.collectivecolors.rpc.RemoteService;
	
	import mx.rpc.events.ResultEvent;
	
	//----------------------------------------------------------------------------
	
	public class SystemService extends RemoteService
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const SOURCE : String = 'system';
		
		//---------------------
		
		private static const CONNECT : String = 'connect';
		
		private static const MAIL : String    = 'mail';
		
		private static const GET_VARIABLE : String = 'getVariable';
		private static const SET_VARIABLE : String = 'setVariable';
		
		private static const MODULE_EXISTS : String = 'moduleExists';
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function SystemService( agent : IServiceAgent, urls : Array = null )
		{
			super( agent, urls );
			
			// Register system service handlers
			agent.register( CONNECT, connectResultHandler, serviceFaultHandler );
			                              
			agent.register( MAIL, mailResultHandler, serviceFaultHandler );
			
			agent.register( GET_VARIABLE, executeResultHandler, serviceFaultHandler );
			agent.register( SET_VARIABLE, setVariableResultHandler, 
			                              serviceFaultHandler );
			                                   
			agent.register( MODULE_EXISTS, executeResultHandler, 
			                               serviceFaultHandler );
		}
		
		//--------------------------------------------------------------------------
		// Service methods
		
		/**
		 * Register connect method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function connectResultHandler( user : UserVO ) : void
		 *  function connectFaultHandler( statusMessage : String ) : void
		 */
		public function connectHandlers( resultHandler : Function,
		                                 faultHandler : Function = null ) : void
		{
		  registerHandlers( CONNECT, resultHandler, faultHandler );
		}
		
		/**
		 * Execute remote connect method and return current user.
		 */
		public function connect( ) : void
		{
		  agent.execute( CONNECT );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register mail method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function mailResultHandler( mailSentMessage : String ) : void
		 *  function mailFaultHandler( statusMessage : String ) : void
		 */
		public function mailHandlers( resultHandler : Function = null,
		                              faultHandler : Function  = null ) : void
		{
		  registerHandlers( MAIL, resultHandler, faultHandler );
		}		
		
		/**
		 * Execute the remote mail method.
		 */
		public function mail( mailId : String,
		                      toEmail : String, 
								          subject : String,
								          body : String,
								          fromEmail : String = null,
								          headers : Object = null ) : void
		{
		  agent.execute( MAIL, 
		                 mailId, 
		                 toEmail, subject, body, fromEmail, 
		                 headers );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register getVariable method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function getVariableResultHandler( variable : Object ) : void
		 *  function getVariableFaultHandler( statusMessage : String ) : void
		 */
		public function getVariableHandlers( resultHandler : Function = null,
		                                     faultHandler : Function = null ) : void
		{
		  registerHandlers( GET_VARIABLE, resultHandler, faultHandler );
		}
		
		/**
		 * Execute the remote getVariable method.
		 */
		public function getVariable( variableName : String ) : void
		{
		  agent.execute( GET_VARIABLE, variableName );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register setVariable method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function setVariableResultHandler( message : String ) : void
		 *  function setVariableFaultHandler( statusMessage : String ) : void
		 */
		public function setVariableHandlers( resultHandler : Function = null,
		                                     faultHandler : Function = null ) : void
		{
		  registerHandlers( SET_VARIABLE, resultHandler, faultHandler );
		}
		
		/**
		 * Execute the remote getVariable method.
		 */
		public function setVariable( variableName : String, value : Object ) : void
		{
		  agent.execute( SET_VARIABLE, variableName, value );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Register moduleExists method handlers.
		 * 
		 * Prototypes :
		 * 
		 *  function moduleExistsResultHandler( version : String ) : void
		 *  function moduleExiistsFaultHandler( statusMessage : String ) : void
		 */
		public function moduleExistsHandlers( resultHandler : Function = null,
		                                     faultHandler : Function = null ) : void
		{
		  registerHandlers( MODULE_EXISTS, resultHandler, faultHandler );
		}
		
		/**
		 * Execute the remote moduleExists method.
		 */
		public function moduleExists( moduleName : String ) : void
		{
		  agent.execute( MODULE_EXISTS, moduleName );
		}
		
		//--------------------------------------------------------------------------
		// Event handlers
		
		/**
		 * Executed when remote connect method returns sucessfully.
		 */
		protected function connectResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseConnectResult );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Executed when remote mail method returns sucessfully.
		 */
		protected function mailResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseMailResult );
		}
		
		//--------------------------------------------------------------------------
		
		/**
		 * Executed when remote get variable method returns successfully.
		 */
		protected function setVariableResultHandler( event : ResultEvent ) : void
		{
		  executeResultHandler( event, parseSetVariableResult );
		}
		
		//--------------------------------------------------------------------------
		// Result parsers
		
		/**
		 * Parse the result of the remote connect method into a UserVO object
		 * that represents the user who is currently logged in.
		 * 
		 * If user is not logged in and does not have a user account then a uid
		 * of 0 is assigned and most UserVO fields are not available.
		 */
		protected function parseConnectResult( result : Object ) : UserVO
		{
		  var userObj : Object  = result.user;
			var userData : UserVO = new UserVO( );
			
			userData.sessionId = result.sessid;
			userData.uid       = userObj.userid;
			userData.hostname  = userObj.hostname;
			
			for ( var rid : String in userObj.roles )
			{
				userData.addRole( rid as int, userObj.roles[ rid ] );
			}
			
			if ( userData.uid )
			{
				userData.name           = userObj.name;
				userData.initMail       = userObj.init;
				userData.currentMail    = userObj.mail;
				userData.createdTime    = new Date( userObj.created );
				userData.lastLoginTime  = new Date( userObj.login );
				userData.lastAccessTime = new Date( userObj.access );
				userData.status         = userObj.status;
				userData.contact        = ( userObj.contact ? true : false );
				userData.timezone       = userObj.timezone;
				userData.language       = userObj.language;
				userData.imagePath      = userObj.picture;
			}			
			
			return userData;
		}
		
		/**
		 * Return a message that indicates that a message was sent sucessfully.
		 */
		protected function parseMailResult( result : Object ) : String
		{
		  return 'Message was sent successfully';
		}
		
		/**
		 * Return a message that indicates the variable was set sucessfully.
		 */
		protected function parseSetVariableResult( result : Object ) : String
		{
		  return 'Variable was set successfully';
		}			
	}
}