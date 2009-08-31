package com.collectivecolors.extensions.flex3.drupal.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.drupal.DrupalFacade;
  import com.collectivecolors.extensions.flex3.drupal.model.DrupalProxy;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class DrupalStartupCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      var flashVars : Object = note.getBody( );
      
      // Register drupal proxies for each registered extension.
      
			for each ( var drupal : DrupalFacade in DrupalFacade.extensions )
			{
			  var extensionName : String = drupal.getExtensionName( );		  
			  facade.registerProxy( new DrupalProxy( extensionName, flashVars ) );
			}			  
    }
  }
}