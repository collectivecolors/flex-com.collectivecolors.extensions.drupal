package com.collectivecolors.extensions.flex3.drupal
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.emvc.patterns.extension.Extension;
  import com.collectivecolors.extensions.as3.data.ExtensionSet;
  import com.collectivecolors.extensions.as3.data.StatusVO;
  import com.collectivecolors.extensions.flex3.config.ConfigFacade;
  import com.collectivecolors.extensions.flex3.drupal.model.DrupalProxy;
  import com.collectivecolors.extensions.flex3.drupal.model.UserProxy;
  import com.collectivecolors.extensions.flex3.startup.StartupFacade;
  
  //----------------------------------------------------------------------------

  public class DrupalFacade extends Extension
  {
    //--------------------------------------------------------------------------
    // Constants
    
    //----------------
    // Notifications
    
    public static const UPDATED : String = "drupalFacadeUpdated";
    
    public static const SERVICE_READY : String  = "drupalFacadeServiceReady";
    public static const SERVICE_FAILED : String = "drupalFacadeServiceFailed";
    
    // User proxy
    
    public static const USER_FAILED : String  = "drupalFacadeUserFailed";
    
    public static const USER_CONNECTING : String = "drupalFacadeUserConnecting";
    public static const USER_CONNECTED : String  = "drupalFacadeUserConnected";
    		
		public static const USER_LOGGING_IN : String = "drupalFacadeUserLoggingIn";
		public static const USER_LOGGED_IN : String  = "drupalFacadeUserLoggedIn";
		
		public static const USER_LOGGING_OUT :String = "drupalFacadeUserLoggingOut";
		public static const USER_LOGGED_OUT : String = "drupalFacadeUserLoggedOut";
				
		public static const USER_LOADING : String = "drupalFacadeUserLoading";
		public static const USER_LOADED : String  = "drupalFacadeUserLoaded";
		
		public static const USER_SAVING : String = "drupalFacadeUserSaving";
		public static const USER_SAVED : String  = "drupalFacadeUserSaved";
		
		public static const USER_REMOVING : String = "drupalFacadeUserRemoving";
		public static const USER_REMOVED : String  = "drupalFacadeUserRemoved";
		
		//---------------------    
    // Configuration tags
    
    public static const CONFIG_URL : String = "serviceUrl";
    
		// Status types ( for status information )
		
		public static const STATUS_SUCCESS : String = StatusVO.SUCCESS;
		public static const STATUS_NOTICE : String  = StatusVO.NOTICE;
		public static const STATUS_ERROR : String   = StatusVO.ERROR;
    
		//--------------------------------------------------------------------------
		// Properties
		
		protected static var drupalMap : ExtensionSet;
    
    //--------------------------------------------------------------------------
    // Constructor
    
    public function DrupalFacade( extensionName : String )
    {
      super( extensionName );
      
      // Initialize drupal extension set, if not already.
      if ( drupalMap == null )
      {
        drupalMap = new ExtensionSet( );
      }         
    }
    
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function onRegister( ) : void
    {
      // Make sure the config extension exists.
      if ( ! core.hasExtension( ConfigFacade.NAME ) )
      {
        core.registerExtension( new ConfigFacade( ) );
      }
      
      // Add self to drupal extension set ( used in commands !! ).
      drupalMap.addExtension( this );
    }
    
    //--------------------------------------------------------------------------
    
    override public function onRemove( ) : void
    {
      // Remove self from drual extension set.
      drupalMap.removeExtension( getExtensionName( ) );     
    }
    
    //--------------------------------------------------------------------------
    // Accessors
    
    public static function get extensions( ) : Array
    {
      return drupalMap.extensions;
    }
    
    public static function extension( extensionName : String ) : DrupalFacade
    {
      return drupalMap.getExtension( extensionName ) as DrupalFacade;
    }
    
    //--------------------------------------------------------------------------
    
    public static function drupalProxy( extensionName : String ) : DrupalProxy
    {
      return core.retrieveProxy( extensionName + DrupalProxy.NAME_SUFFIX ) 
        as DrupalProxy;
    }
    
    public function get drupalProxy( ) : DrupalProxy
    {
      return drupalProxy( getExtensionName( ) );
    }
    
    //--------------------------------------------------------------------------
    
    public static function userProxy( extensionName : String ) : UserProxy
    {
      return core.registerProxy( extensionName + UserProxy.NAME_SUFFIX )
        as UserProxy;
    }
    
    public function get userProxy( ) : UserProxy
    {
      return userProxy( getExtensionName( ) );
    }
    
    //--------------------------------------------------------------------------
    // eMVC hooks
       
    public function initializeController( ) : void
    {
      core.registerCommand( StartupFacade.REGISTER_RESOURCES, 
                            DrupalStartupCommand );
      
      core.registerCommand( ConfigFacade.PARSE, DrupalConfigParseCommand );
      core.registerCommand( SERVICE_READY, UserStartupCommand );      
    }   
  }
}