import processing.sound.*;

import pt.citar.diablu.processing.mindset.*;
import processing.serial.*;

import java.util.*;

MindSet mindSet;
SoundFile file;
PGraphics render;
float maxDist;
PVector myPoint,velocity,acc;

final int preSize = 1000;
final int mySize = 1080;
int OO = 6220;//10000 < OO < 20000
int II = 10020;//10000 < II < 20000

int layers = 4;
float colorOffset = 0f; // 0<offset<30000

//the radius' of the outer and inner circles
float outerRad,innerRad;
//the rotational angles for the outer "oribit/rotation" and inner rotation
float outerAng = 0;
float innerAng = 0;

//the incremental value of used angles
float angPlus = 1.6f;

//current coordinates
float pointX = 0;
float pointY = 0;

//to decide how much the inner radius you wish to use
float f = 0.4;

/*
void settings(){
  size(preSize,preSize);
}
*/


void setup() {
  fullScreen();
  noCursor();
  mindSet = new MindSet(this, "COM11");
  file = new SoundFile(this,"myMusic.wav");
  file.loop();
  colorOffset = random(30000);
  ellipseMode(RADIUS);
  colorMode(HSB,30000,100,100,1000);
  background(0);
  //stroke(200, 200, 250, 150);

  render = createGraphics(mySize,mySize);
  render.beginDraw();
  render.background(0);
  render.strokeWeight(2.0);
  
  myPoint = new PVector(15000,15000);//imagine a point slide on a 2D surface freely
  velocity = new PVector(0,0);
  acc = new PVector(random(-1,1),random(-1,1));
  //attention and mediation constructs the acceleration vector
}

void draw() {
  background(0);
  /*
  velocity.add(acc);
  myPoint.add(velocity);
  myPoint.x=round(max(myPoint.x,1000));
  myPoint.x=round(min(myPoint.x,30000));
  myPoint.y=round(max(myPoint.y,1000));
  myPoint.y=round(min(myPoint.y,30000));
  */
  //myPoint.x=round(myPoint.x);
  myPoint.y=15000;
  
  for(int i = 0; i < layers; i++){
    preview();
  }
  colorOffset += 480;
  //renderAndSave();
  
  //println(frameCount+" "+int(myPoint.x)+" "+int(myPoint.y));
}

float hueCorr(float hue){
  return hue%30000.0;
}

int gcd(int a,int b){
  if(a>b){
    int t = a;
    a = b;
    b = t;
  }
  if(a==0) return b;
  return gcd(b%a,a);
}

void patternNorm(int threshold){
  int gcdt = gcd(OO,II);
  if(gcd(OO,II)!=1){
    OO = OO/gcdt;
    II = II/gcdt;
  }
  while (max(OO,II)<threshold*20) {
    OO *= 2;
    II *= 2;
  }
}

int pointStuckDetec=0;
void preview(){
  strokeWeight(preSize*0.005);
  pushMatrix();
  //OO = max(mouseX,1); II = max(mouseY,1);
  OO = int(myPoint.x); II = int(myPoint.y);
  if((OO==1000 || OO==30000) && (II==1000 || II==30000)) pointStuckDetec++;
  if(pointStuckDetec>9) {
    myPoint = new PVector(15000,15000);
    pointStuckDetec = 0;
  }
  
  patternNorm(height);
  outerRad = preSize*(OO/30000.0);
  innerRad = preSize*(II/30000.0);
  
  translate(width/2, height/2);    //move the drawing origin to the center of the canvas
  maxDist = 0.0;
  for(float i=0;i<max(innerRad,outerRad)*20;i+=angPlus){
    //compute the value for inner rotational angle, based on the outer rotational angle
    outerAng = i;
    innerAng = (outerRad / innerRad - 1) * outerAng;
    
    //compute the coordinate values at the edge of the inner circle based on the outer rotational angle
    pointX = (outerRad - innerRad) * cos(radians(outerAng)) + f * innerRad * cos(radians(innerAng));
    pointY = (outerRad - innerRad) * sin(radians(outerAng)) - f * innerRad * sin(radians(innerAng));
    //println(pointX+" "+pointY);
    
    if(dist(pointX,pointY,0,0)>maxDist) {
      maxDist = dist(pointX,pointY,0,0);
    }
  }
  popMatrix();
  
  pushMatrix();
  translate(width/2, height/2);    //move the drawing origin to the center of the canvas
  scale(preSize/2/maxDist*0.9f);
  strokeWeight(preSize*0.0005/(preSize/2/maxDist*0.9f));
  for(float i=0;i<max(innerRad,outerRad)*100;i+=angPlus){
    //compute the value for inner rotational angle, based on the outer rotational angle
    outerAng = i;
    innerAng = (outerRad / innerRad - 1) * outerAng;
    
    //compute the coordinate values at the edge of the inner circle based on the outer rotational angle
    pointX = (outerRad - innerRad) * cos(radians(outerAng)) + f * innerRad * cos(radians(innerAng));
    pointY = (outerRad - innerRad) * sin(radians(outerAng)) - f * innerRad * sin(radians(innerAng));
    
    float myHue = hueCorr(dist(pointX,pointY,0,0)/( preSize / 2 )*10000*mySize/preSize+colorOffset);
    stroke(myHue, 40, 100, 30000);
    point(pointX, pointY);
  }
  popMatrix();
}

void renderAndSave(){
  render.strokeWeight(2.0);
  render.colorMode(HSB,30000,100,100,1000);
  render.background(0);
  
  for(int j = 0; j < layers; j++){
    
    render.pushMatrix();
    //OO = max(mouseX,1); II = max(mouseY,1);
    OO = int(myPoint.x); II = int(myPoint.y);
    patternNorm(mySize);
    outerRad = mySize*(OO/30000.0);
    innerRad = mySize*(II/30000.0);
    
    render.translate(mySize/2, mySize/2);    //move the drawing origin to the center of the canvas
    maxDist = 0.0;
    for(float i=0;i<max(innerRad,outerRad)*120;i+=angPlus){
      //compute the value for inner rotational angle, based on the outer rotational angle
      outerAng = i;
      innerAng = (outerRad / innerRad - 1) * outerAng;
      
      //compute the coordinate values at the edge of the inner circle based on the outer rotational angle
      pointX = (outerRad - innerRad) * cos(radians(outerAng)) + f * innerRad * cos(radians(innerAng));
      pointY = (outerRad - innerRad) * sin(radians(outerAng)) - f * innerRad * sin(radians(innerAng));
      //println(pointX+" "+pointY);
      
      if(dist(pointX,pointY,0,0)>maxDist) {
        maxDist = dist(pointX,pointY,0,0);
      }
    }
    render.popMatrix();
    
    render.pushMatrix();
    render.translate(mySize/2, mySize/2);    //move the drawing origin to the center of the canvas
    render.scale(mySize/2/maxDist*0.9f);
    render.strokeWeight(mySize*0.0002/(mySize/2/maxDist*0.9f));
    for(float i=0;i<max(innerRad,outerRad)*120;i+=angPlus){
      //compute the value for inner rotational angle, based on the outer rotational angle
      outerAng = i;
      innerAng = (outerRad / innerRad - 1) * outerAng;
      
      //compute the coordinate values at the edge of the inner circle based on the outer rotational angle
      pointX = (outerRad - innerRad) * cos(radians(outerAng)) + f * innerRad * cos(radians(innerAng));
      pointY = (outerRad - innerRad) * sin(radians(outerAng)) - f * innerRad * sin(radians(innerAng));
  
      float myHue = hueCorr(dist(pointX,pointY,0,0)/( mySize / 2 )*10000.1+colorOffset);
      render.stroke(myHue, 40, 100, 30000);
      grainyPoint(pointX,pointY,render);
    }
    render.popMatrix();
  }
  //render.save(OO+"_"+II+"_"+colorOffset+".png");
  String frameName = zeroFormat(frameCount,4,true);
  render.save("AnimationTest_"+frameName+".png");
  //exit();
}

/*
void keyPressed() {
  if (key == 's') {
    renderAndSave();
  }
}
*/

String zeroFormat(Integer num, int len, boolean prev) {
    int l = num.toString().length();
    StringBuffer sb = new StringBuffer();
    if(!prev)
        sb.append(num);
    for(int i=0;i<len-l;i++)
        sb.append("0");
    if(prev)
        sb.append(num);
    return sb.toString();
}

public void attentionEvent(int attentionLevel) {
  if(attentionLevel!=0){
    myPoint.x=map(attentionLevel,0,100,14000,21111)+random(100);
    //acc.x=(attentionLevel-50)/12;
    println(attentionLevel);
  }
}


public void meditationEvent(int meditationLevel) {
  if(meditationLevel!=0)
  myPoint.y=15000+random(-5,5);
  //acc.y=(meditationLevel-50)/12;
  //println(meditationLevel);
}

int poorSigCount = 0;
public void poorSignalEvent(int sig) {
  if(sig>0) poorSigCount++;
  if(sig==0) poorSigCount=0;
  if(poorSigCount>30) {
    myPoint = new PVector(15000,15000);
    poorSigCount = 0;
  }
}
