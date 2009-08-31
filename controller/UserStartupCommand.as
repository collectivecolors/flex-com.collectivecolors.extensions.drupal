package com.collectivecolors.extensions.flex3.drupal.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.drupal.DrupalFacade;
  import com.collectivecolors.extensions.flex3.drupal.model.UserProxy;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class UserStartupCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      var drupal : DrupalFacade  = note.getBody( ) as DrupalFacade;
      var extensionName : String = drupal.getExtensionName( );
      
      var userProxy : UserProxy = new UserProxy( extensionName );
      
      // Register a user proxy for this service extension.
      facade.registerProxy( userProxy );
      
      // Initialize the user proxy.
      userProxy.urls = drupal.drupalProxy.urls;
      userProxy.initialize( );      		  
    }
  }
}