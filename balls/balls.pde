import processing.sound.*;
SoundFile file;

int R = 75;
int X;
int Y;
PVector tmp;

class Ball{
  PVector poz,velo,g;
  color szin=color(255,random(255), random(255));
  Ball(PVector p,PVector v){
    this.poz=p;
    this.velo=v;
    this.g=new PVector(0,0.2);
  }
  void update(){
    this.poz.add(this.velo);
    this.velo.add(this.g);
  }
  void place(){
    fill(szin);
    circle(this.poz.x, this.poz.y,R);
  }
  void check(){
    if((this.poz.x+R/2)>width ){
      this.velo.x*=-.95;
      this.poz.x=width-R/2;
      
      file.play();
    }
    if((this.poz.x-R/2)<0){
      this.velo.x*=-.95;
      this.poz.x=0+R/2;
      
      file.play();
    }
    if((this.poz.y+R/2)>height){
      this.velo.y*=-.95;
      this.poz.y=height-R/2;
      
      file.play();
    }
  }
}

ArrayList<Ball> balls = new ArrayList<Ball>();

void setup(){
  size(1000,1000);
  file = new SoundFile(this, "pop.wav");
  //balls.add(new Ball(new PVector(100,100),new PVector(5,0)));
}

void mousePressed(){
  X=mouseX;
  Y=mouseY;
}

void mouseReleased(){
  balls.add(new Ball(new PVector(X,Y), new PVector((mouseX-X)/100,(mouseY-Y)/100)));
}

void draw(){
  frameRate(10000);
  background(0);
  //println(balls.size());
  for(int i=0;i<balls.size();++i){
    for(int j=i+1;j<balls.size();++j){
      if(dist(balls.get(i).poz.x,balls.get(i).poz.y,balls.get(j).poz.x,balls.get(j).poz.y)<80){
        PVector midJI = balls.get(i).poz.copy().sub(balls.get(j).poz.copy());
        PVector midIJ = balls.get(j).poz.copy().sub(balls.get(i).poz.copy());
        float phi = PVector.angleBetween(midJI,balls.get(j).velo);
        float fi = PVector.angleBetween(midIJ,balls.get(i).velo);
        float f1=balls.get(j).velo.copy().mag()*cos(phi);
        float f2=balls.get(i).velo.copy().mag()*cos(fi);
        
        balls.get(i).velo.add(midJI.setMag(f2));
        balls.get(i).velo.sub(midIJ.setMag(f1));
        balls.get(j).velo.add(midIJ.setMag(f1));
        balls.get(j).velo.sub(midJI.setMag(f2));
        
        balls.get(i).velo.x*=0.8;
        balls.get(i).velo.y*=0.8;
        balls.get(j).velo.x*=0.8;
        balls.get(j).velo.y*=0.8;
        file.play();
      }
    }
    balls.get(i).update();
    balls.get(i).check();
    
    balls.get(i).place();
  }
}
