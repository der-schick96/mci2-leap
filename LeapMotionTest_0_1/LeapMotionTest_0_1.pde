import de.voidplus.leapmotion.*;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Observer;
import java.util.Observable;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.text.DecimalFormat;

LeapMotion leap;
HandPublisher handPublisher;
PImage img;

Instant lastResize;
Instant lastMoved;

GameMap gameMap;

HashMap<String, Object> state = new HashMap<String, Object>();

float pointerZOffset;
float pointerXOffset;
float pointerZFactor;
float pointerXFactor;


void setup() {
  //fullScreen();
  size(1920, 1920);
  background(255);
  stroke(0x000000);
  
  pointerXOffset = 0;
  pointerZOffset = 0;
  pointerXFactor=1;
  pointerZFactor=10;
  
  
  leap = new LeapMotion(this);
  
  handPublisher = new HandPublisher(leap);
  handPublisher.addObserver(new GestureObserver(state));
  handPublisher.addGesture(new HandSpread());
  handPublisher.addGesture(new MoveGesture());
  handPublisher.addGesture(new PointGesture());
  
  gameMap = new GameMap();
  gameMap.loadFromXML(loadXML("./test.xml"));
  //gameMap.addPlace(new Place(100, 100, 300, 300, "test"));
  //saveXML(gameMap.toXML(), "text.xml");
  
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


void moveImage(PVector offsetPosition) {
   imgX += (offsetPosition.x*2)/scale;
   imgY += (offsetPosition.z * -20)/scale;    
}

void zoom(float zoomFactor) {
 imgX += (width/scale - zoomFactor*width/scale)/2;
 imgY += (height/scale - zoomFactor*height/scale)/2;  
 
 scale = scale * zoomFactor; 
}

PVector translatePointerPosition(PVector pointerPosition) {
  return new PVector((pointerPosition.x*pointerXFactor+pointerXOffset)/scale, (pointerPosition.z*pointerZFactor+pointerZOffset)/scale);
}



PVector pointerToImagePosition(PVector pointerPosition) {
  return translatePointerPosition(pointerPosition).sub(imgX, imgY);
}

void drawCross(float x, float y) {
   line(x - 10/scale, y-10/scale, x + 10/scale, y + 10/scale);
   line(x + 10/scale, y-10/scale, x - 10/scale, y + 10/scale);
}

void drawCross(PVector position) {
   drawCross(position.x, position.y);
}

void drawPointer(PVector pointerPosition, PShape pointerShape) {
  PVector pos = translatePointerPosition(pointerPosition);
  pointerShape.scale(1/scale);
  shape(pointerShape, pos.x , pos.y);
  
}

void drawZoomPointer(PVector centerPosition, PVector leftHandPosition, PVector rightHandPosition) {
  
  PVector centerPos = translatePointerPosition(centerPosition);
  drawCross(translatePointerPosition(centerPosition));
  drawCross(translatePointerPosition(leftHandPosition));
  drawCross(translatePointerPosition(rightHandPosition));
    
  textSize(20/scale);
  DecimalFormat df = new DecimalFormat();
  df.setMaximumFractionDigits(2);
  text("x" + df.format(scale), centerPos.x, centerPos.y);
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
         
          if (abs(dDist) > 10 && scale*zoomFactor > 0.25 && scale*zoomFactor < 10) {
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
     
    if(!lastMovePosition.equals(movePosition) && (lastMovePosition.dist(movePosition) < 50 || lastMoved.until(Instant.now(), ChronoUnit.MILLIS) < 200)) {
      println(movePosition.dist(lastMovePosition));
      if (movePosition != null ) {
        if (!lastMovePosition.equals(new PVector(0, 0, 0)) && movePosition.dist(lastMovePosition) < 300) {
          PVector movePCopy = movePosition.copy();
          PVector offsetPosition = movePCopy.sub(lastMovePosition);
          moveImage(offsetPosition);  
        }
      } 
      lastMoved = Instant.now();
      
   
    }
    lastMovePosition = movePosition;
      
    }
      
    image(img, imgX, imgY);
      
    if(pos != null && hand1pos != null && hand2pos != null) {
      drawZoomPointer(pos.copy(), hand1pos.copy(), hand2pos.copy());
    }
    PShape movePointer = loadShape("move.svg");
    if (movePosition != null) {
      //shape(movePointer, (movePosition.x + pointerXOffset)/scale , (movePosition.y + pointerZOffset)/scale);
      drawPointer(movePosition, movePointer);
      //rect((movePosition.x + pointerXOffset)/scale , (movePosition.z*10 + pointerZOffset)/scale, 50/scale, 50/scale);
    }
      
    PVector pointerPos = (PVector)state.get("pointpos");
    System.out.println(pointerToImagePosition(pointerPos));
    PShape normalPointer = loadShape("pointer.svg");
    if (pointerPos != null) {
        fill(0xffff0000);
        //shape(normalPointer, (pointerPos.x+ pointerXOffset)/scale , (pointerPos.y + pointerZOffset)/scale);
        drawPointer(pointerPos, normalPointer);
        ArrayList<Place> mapPlaces = gameMap.getPlacesByPosition(pointerToImagePosition(pointerPos));
        if (mapPlaces.size() > 0)
          mapPlaces.get(0).draw(imgX, imgY, scale);
        //ellipse((pointerPos.x+ pointerXOffset)/scale , (pointerPos.y + pointerZOffset)/scale, 10/scale, 10/scale);
    }
      
       
 
  } catch(Exception e) {
    e.printStackTrace();
  }
    
}
