final float stepScale = 1f;
final float endR = width*0.5f;
final int density = 1;
final float rIni = 0.1f;
final float rStepStep = 0.1f;

void grainyLine(float startX,float startY,float endX,float endY){
  float myStep = stepScale;
  float x = startX;
  float y = startY;
  if((endX-startX)!=0){
    if(endX<startX) myStep = -myStep;
    float k = (endY-startY)/(endX-startX);
    float b = startY-k*startX;
    do{
      x+=myStep;
      y = k*x+b;
      dropPoints(x,y);
    }while(notReachEnd(x,startX,endX));
  }
  else{
    if(endY<startY) myStep = -myStep;
    do{
      y+=myStep;
      x = startX;
      dropPoints(x,y);
    }while(notReachEnd(y,startY,endY));
  }
}

void grainyLine(float startX,float startY,float endX,float endY,PGraphics canvas){
  float myStep = stepScale;
  float x = startX;
  float y = startY;
  if((endX-startX)!=0){
    if(endX<startX) myStep = -myStep;
    float k = (endY-startY)/(endX-startX);
    float b = startY-k*startX;
    do{
      x+=myStep;
      y = k*x+b;
      dropPoints(x,y,canvas);
    }while(notReachEnd(x,startX,endX));
  }
  else{
    if(endY<startY) myStep = -myStep;
    do{
      y+=myStep;
      x = startX;
      dropPoints(x,y,canvas);
    }while(notReachEnd(y,startY,endY));
  }
}

boolean notReachEnd(float x,float start,float end){
  if(start<=end){
      if(x<=end) return true; else return false;
  }
  else{
    if(x>end) return true; else return false;
  }
}

void dropPoints(float x,float y){
  float rStep = 0.0;
  float r = rIni;
  do{
    for(int drops = 0; drops < density;drops++){
      float tempX = random(1)-0.5f;
      float tempY = random(1)-0.5f;
      tempX *= r; tempY *= r;
      while(dist(x+tempX,y+tempY,x,y)>r){
        tempX = random(1)-0.5f;
        tempY = random(1)-0.5f;
        tempX *= r; tempY *= r;
      }
      point(x+tempX,y+tempY);
    }
    rStep+=rStepStep;
    //r=rStep;
    //r=easeOutCirc(rStep)*endR;
    //r=easeInExpo(rStep)*endR;
    r=easeInOutSine(rStep)*endR;
  }while(r<endR);
}

void dropPoints(float x,float y,PGraphics canvas){
  float rStep = 0.0;
  float r = rIni;
  do{
    for(int drops = 0; drops < density;drops++){
      float tempX = random(1)-0.5f;
      float tempY = random(1)-0.5f;
      tempX *= r; tempY *= r;
      while(dist(x+tempX,y+tempY,x,y)>r){
        tempX = random(1)-0.5f;
        tempY = random(1)-0.5f;
        tempX *= r; tempY *= r;
      }
      canvas.point(x+tempX,y+tempY);
    }
    rStep+=rStepStep;
    //r=rStep;
    //r=easeOutCirc(rStep)*endR;
    r=easeInExpo(rStep)*endR;
    //r=easeInOutSine(rStep)*endR;
  }while(r<endR);
}

void grainyPoint(float x,float y){
  grainyLine(x,y,x,y);
}

void grainyPoint(float x,float y,PGraphics canvas){
  grainyLine(x,y,x,y,canvas);
}

void grainyRect(float x,float y,float myWidth,float myHeight){
  grainyLine(x,y,x+myWidth,y);
  grainyLine(x,y,x,y+myHeight);
  grainyLine(x+myWidth,y,x+myWidth,y+myHeight);
  grainyLine(x,y+myHeight,x+myWidth,y+myHeight);
}

void grainyEllipse(float x,float y,float myWidth,float myHeight){
    for (int i=0; i<round(max(myWidth,myHeight)*2f); i++) {
    float a = i * 2 * PI/round(max(myWidth,myHeight)*2f);
    float x1 = myWidth * 0.5f * cos(a);
    float y1 = myHeight * 0.5f * sin(a);
    grainyPoint(x1, y1);
  }
}

void grainyCircle(float x,float y,float r){
  grainyEllipse(x,y,r,r);
}

float easeOutCirc(float x){
  return sqrt(1 - pow(x - 1, 2));
}

float easeInExpo(float x){
  if(x==0){
    return 0;
  }
  else{
    return pow(2, 10 * x - 10);
  }
}

float easeInOutSine(float x){
  return -(cos(PI * x) - 1) / 2;
}
