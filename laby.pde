class Laby{
      
      int size_x , size_y ;
      float pos_x,pos_y,scale;
      float speed = 0;
      float l = 0;
      int[][] data;  
      boolean[][] h_wall; 
      boolean[][] v_wall ;
      
      
      
      Laby(float x_, float y_,int sx, int sy , float cs){
        
        size_x = sx ; 
        size_y = sy;
        scale = cs;
        pos_x = x_;
        pos_y = y_;
        data = new int[size_x][size_y];
        h_wall = new boolean[size_x][size_y+1];
        v_wall = new boolean[size_x+1][size_y];
        
      }
       
       
      int hover_x(){
      
        int output = mouseX;
        output -= (2*pos_x-size_x*scale)/2;
        output /= scale;
        return(output);
        
      }
      
      int hover_y(){
      
        int output = mouseY;
        output -= (2*pos_y-size_y*scale)/2;
        output /= scale;
        return(output);
      
      }
      
      void update(){
         
        graphics_update();
        physics_update();
          
      }
      
      void graphics_update(){
        
          
            fill(240);
            rectMode(CENTER);
            noStroke();
            
            rect(pos_x,pos_y,size_x*scale,size_y*scale);
            
            rectMode(CORNER);
            stroke(210);
            
            int alternance = 240;
            for(int i = 0; i  < size_x ; i++){
              
              if(i % 2 == 1){
                 alternance = 230; 
              }else{
                 alternance = 240; 
              }
              
              for(int j = 0; j  < size_y ; j++){
                
                if(alternance == 240){
                  alternance = 230;
                }else{
                  alternance = 240;
                }
                
                fill(alternance);
                rect((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,scale,scale);
                
                if( i == hover_x() && j == hover_y()){
                  
                    fill(248,153,75,150);
                    rect((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,scale,scale);
                    
                }
                
                if(data[i][j] == 1){
                  
                    fill(193,15,39,120);
                    rect((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,scale,scale);
                  
                }
                 if(data[i][j] == -1){
                  
                    fill(0,0,0);
                    rect((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,scale,scale);
                  
                }
              }
            }
            
            stroke(5);
            strokeWeight(3);
            
            for(int i = 0; i  < size_x ; i++){
              for(int j = 0; j  < size_y+1 ; j++){
                if(!h_wall[i][j]){
                  line((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,(pos_x*2-size_x*scale)/2+(i+1)*scale,(pos_y*2-size_y*scale)/2+j*scale);
                }
                 
              }
            }
            
            for(int i = 0; i  < size_x+1 ; i++){
              for(int j = 0; j  < size_y ; j++){
                if(!v_wall[i][j]){
                  line((pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+j*scale,(pos_x*2-size_x*scale)/2+i*scale,(pos_y*2-size_y*scale)/2+(j+1)*scale);
                }
                 
              }
            }
            strokeWeight(1);
        
      }
      
      void physics_update(){
        
        l += 1/frameRate;
        if( l > speed){
          l = 0; 
          calculate_new_case();
        }
        listener();
        
      }
      
       void calculate_new_case(){
          
           int[][] border_ref = new int[size_x*size_y][2];
           boolean[][] border_n = new boolean[size_x*size_y][4];
           int loop = 0;
           for(int i = 0; i  < size_x ; i++){
             for(int j = 0; j  < size_y ; j++){
             
                 
                 if(data[i][j] == 1){
                     
                       boolean up = false;
                       boolean down = false;
                       boolean right = false;
                       boolean left = false;
                       
                       try{
                         left = data[i-1][j] == 2;
                       }
                       catch(Exception  e){}
                       
                       
                       try{
                         right = data[i+1][j] == 2;
                       }
                       catch(Exception  e){}
                       
                       
                       try{
                         up = data[i][j-1] == 2;
                       }
                       catch(Exception  e){}
                       
                       
                       try{
                         down = data[i][j+1] == 2;
                       }
                       catch(Exception  e){}
                       border_ref[loop][0] = i;
                       border_ref[loop][1] = j;
                       border_n[loop][0] = up;
                       border_n[loop][1] = down;
                       border_n[loop][2] = left;
                       border_n[loop][3] = right;
                       loop++;
                 }
               
               
             }
           }
         
           
           if(loop != 0 && loop != size_x*size_y){
             
             Random rand = new Random();
             int case_r = rand.nextInt(loop);
           
             
             data[border_ref[case_r][0]][border_ref[case_r][1]] = 2;
             
             int border_r = rand.nextInt(4);
             while(!border_n[case_r][border_r]){
               border_r = rand.nextInt(4);
             }
             
             if(border_r == 0){
                h_wall[border_ref[case_r][0]][border_ref[case_r][1]] = true;
             }
             if(border_r == 1){
                h_wall[border_ref[case_r][0]][border_ref[case_r][1]+1] = true;
             }
             if(border_r == 2){
                v_wall[border_ref[case_r][0]][border_ref[case_r][1]] = true;
             }
             if(border_r == 3){
                v_wall[border_ref[case_r][0]+1][border_ref[case_r][1]] = true;
             }
             
             assigned_new_red_case(border_ref[case_r][0],border_ref[case_r][1]);
             
             
           }
           
          
          
     }
     
    void assigned_new_red_case(int X, int Y){
        try{
           if(data[X-1][Y] == 0){
             data[X-1][Y] = 1;
           }
        }catch(Exception  e){}
        
        try{
           if(data[X+1][Y] == 0){
             data[X+1][Y] = 1;
           }
        }catch(Exception  e){}
        
        try{
           if(data[X][Y-1] == 0){
             data[X][Y-1] = 1;
           }
        }catch(Exception  e){}
        
        try{
           if(data[X][Y+1] == 0){
             data[X][Y+1] = 1;
           }
        }catch(Exception  e){}
      
    }
    
    void listener(){
      if(keyPressed && keycode == 10){
        data = new int[size_x][size_y];
        h_wall = new boolean[size_x][size_y+1];
        v_wall = new boolean[size_x+1][size_y];
        
      }
      
      if(mousePressed && mouseButton == LEFT){
        
          
        try{
          
          data[hover_x()][hover_y()] = 2;
          assigned_new_red_case(hover_x(),hover_y());
          
        }
        catch(Exception  e){
          
          
          
        }
        
      }
      if(mousePressed && mouseButton == RIGHT){
        try{
          data[hover_x()][hover_y()] = -1;
        }catch(Exception e){}
      }
      
    }
  
    
}
