package com.collectivecolors.extensions.flex3.drupal.model.data
{
	//----------------------------------------------------------------------------
	
	public class RoleVO
	{
		//--------------------------------------------------------------------------
		// Properties
		
		public var rid : int;
		public var name : String;
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function RoleVO( rid : int, name : String )
		{
			this.rid  = rid;
			this.name = name;
		}
	}
}