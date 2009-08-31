package com.collectivecolors.extensions.flex3.drupal.model.data
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.data.URLSet;
  import com.collectivecolors.extensions.as3.data.StatusVO;
  
  //----------------------------------------------------------------------------
  
  public class DrupalVO extends StatusVO
  {
    //--------------------------------------------------------------------------
    // Properties
    
    private var _location : URLSet;
    
    public var initialized : Boolean = false;
        
    //--------------------------------------------------------------------------
    // Constructor
    
    public function DrupalVO( extensionName : String = null )
    {
      super( extensionName );
      
      _location = new URLSet( );  
    }
    
    //--------------------------------------------------------------------------
    // Accessors / modifiers
    
    public function get location( ) : URLSet
    {
      return _location;
    } 
  }
}