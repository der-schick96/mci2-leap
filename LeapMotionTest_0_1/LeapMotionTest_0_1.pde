import de.voidplus.leapmotion.*;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Observer;
import java.util.Observable;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

LeapMotion leap;
HandPublisher handPublisher;
PImage img;

Instant lastResize;
Instant lastMoved;

HashMap<String, Object> state = new HashMap<String, Object>();

void setup() {
  size(1920, 1920);
  background(255);
  stroke(0x000000);
  // ...
  leap = new LeapMotion(this);
  
  handPublisher = new HandPublisher(leap);
  handPublisher.addObserver(new GestureObserver(state));
  handPublisher.addGesture(new HandSpread());
  handPublisher.addGesture(new MoveGesture());
  handPublisher.addGesture(new PointGesture());
  
  
  img = loadImage("test.jpg");
  
  thread("runObserver");
  lastResize = Instant.now();
  lastMoved = Instant.now();
}

void runObserver() {
  handPublisher.run();
}

float previousDistance = 0;
float distance = 0;
float scale = 1;
float imgX = 0;
float imgY = 0;
PVector lastMovePosition = new PVector(0, 0, 0);
PVector movePosition = new PVector(0, 0, 0);

float pointerZOffset = -1000;
float pointerXOffset = 0;

void moveImage(PVector offsetPosition) {
   imgX += (offsetPosition.x*2)/scale;
   imgY += (offsetPosition.z * -20)/scale;    
}

void zoom(float zoomFactor) {
 imgX += (width/scale - zoomFactor*width/scale)/2;
 imgY += (height/scale - zoomFactor*height/scale)/2;  
 
 scale = scale * zoomFactor; 
}

PVector pointerToImagePosition(PVector pointerPosition) {
  return new PVector((pointerPosition.x + pointerXOffset)/scale  - imgX, (pointerPosition.y + pointerZOffset)/scale  - imgY);
}

void draw() {
  frameRate(leap.getFrameRate());
  
  background(204);
    
  try {
    PVector pos = (PVector)state.get("pos");
    PVector hand1pos = (PVector)state.get("hand1pos");
    PVector hand2pos = (PVector)state.get("hand2pos");
    
    
    
    if (hand1pos != null && hand2pos != null) {
      distance = hand1pos.dist(hand2pos);
      if (abs(previousDistance - distance) > 0.01 ) {
        float dDist = distance - previousDistance;
        if (img.width > 128 
            && abs(dDist) < 200
            && img.width < 16000 
            && lastResize.plusMillis(25).isBefore(Instant.now()))
        { 
          float zoomFactor = max(min(1 + dDist/300, 2), 0); 
         
          if (abs(dDist) > 10) {
            zoom(zoomFactor);
          }
          lastResize = Instant.now();
        }  
      }
      previousDistance = distance; 
    }
     
    scale(scale);
     
    movePosition = (PVector)state.get("movepos");
    if (movePosition != null) {
     
    System.out.println(lastMoved.until(Instant.now(), ChronoUnit.MILLIS));
     
    if(lastMoved.until(Instant.now(), ChronoUnit.MILLIS) < 300) {
     
      if (movePosition != null ) {
        if (!lastMovePosition.equals(new PVector(0, 0, 0)) && movePosition.dist(lastMovePosition) < 300) {
          PVector movePCopy = movePosition.copy();
          PVector offsetPosition = movePCopy.sub(lastMovePosition);
          moveImage(offsetPosition);  
        }
      } 
        
   
    }
    lastMoved = Instant.now();
    lastMovePosition = movePosition;
      
    }
      
    image(img, imgX, imgY);
     if (pos != null)
      ellipse((pos.x + pointerXOffset)/scale, (pos.z*10 + pointerZOffset)/scale, 10/scale, 10/scale);
    if (hand1pos != null)
      ellipse((hand1pos.x + pointerXOffset)/scale , (hand1pos.z*10 + pointerZOffset)/scale, 10/scale, 10/scale);
    if (hand2pos != null)
      ellipse((hand2pos.x+ pointerXOffset)/scale , (hand2pos.z*10 + pointerZOffset)/scale, 10/scale, 10/scale);
    PShape movePointer = loadShape("move.svg");
    if (movePosition != null) {
      shape(movePointer, (movePosition.x + pointerXOffset)/scale , (movePosition.y + pointerZOffset)/scale);
      //rect((movePosition.x + pointerXOffset)/scale , (movePosition.z*10 + pointerZOffset)/scale, 50/scale, 50/scale);
    }
      
    PVector pointerPos = (PVector)state.get("pointpos");
    System.out.println(pointerToImagePosition(pointerPos));
    PShape normalPointer = loadShape("pointer.svg");
    if (pointerPos != null) {
        fill(0xffff0000);
        //shape(normalPointer, (pointerPos.x+ pointerXOffset)/scale , (pointerPos.y + pointerZOffset)/scale);
        ellipse((pointerPos.x+ pointerXOffset)/scale , (pointerPos.y + pointerZOffset)/scale, 10/scale, 10/scale);
    }
      
       
 
  } catch(Exception e) {
    e.printStackTrace();
  }
    
}
