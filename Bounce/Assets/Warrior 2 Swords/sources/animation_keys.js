




    var teclado: AnimationClip;
    
    function Update () {
    
    if (Input.GetKey(KeyCode.UpArrow))
    		{
    		animation.Play ("run");}
    		
    else if(Input.GetKey(KeyCode.Space))
    		{
  			  animation.Play ("attack");}
  			  
  	else 
   			 {
    		animation.Play ("idle");}

   	 }
    



    
    
    
    
    
