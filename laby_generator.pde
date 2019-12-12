import java.lang.*;
import java.util.*;


// laby generation :

Laby laby ;



void setup(){
    
    int taille = 900;
    size(900,900);
    laby = new Laby(taille/2,taille/2,20,20,30);
    
}

void draw(){
  
  
  background(120);
  laby.update();
  
  
}
