import de.voidplus.leapmotion.*;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Observer;
import java.util.Observable;
import java.time.Instant;

LeapMotion leap;
HandPublisher handPublisher;
PImage img;

Instant lastResize;

HashMap<String, Object> state = new HashMap<String, Object>();

void setup() {
  size(1920, 1080);
  background(255);
  stroke(0x000000);
  frameRate(30);
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

float pointerZOffset = 520;
float pointerXOffset = 600;

void draw() {
    background(204);
    
   
    try {
       PVector pos = (PVector)state.get("pos");
       PVector hand1pos = (PVector)state.get("hand1pos");
       PVector hand2pos = (PVector)state.get("hand2pos");
       
       if (hand1pos != null && hand2pos != null) {
         System.out.println(hand1pos + "  " + hand2pos);
         distance = hand1pos.dist(hand2pos);
         if (abs(previousDistance - distance) > 0.0001 ) {
           //System.out.println(abs(previousDistance - distance));
           float dDist = distance - previousDistance;
           if (img.width > 128 
               && abs(dDist) < 200
               && img.width < 16000 
               && lastResize.plusMillis(25).isBefore(Instant.now()))
           {
             //System.out.println(dDist);
             //System.out.println(scale);
             
             imgX += (dDist > 0 ? ((width * 0.95 - width)*1/scale)/2 : ((width *  1.05 - width)*1/scale)/2);
             imgY += (dDist > 0 ? ((height * 0.95 - height)*1/scale)/2 : ((height *  1.05 - height)*1/scale)/2);
             
             scale = scale * (dDist < 0 ? 0.95 : 1.05);
             
             lastResize = Instant.now();
             
           }  
         }
         previousDistance = distance; 
       }
       
       scale(scale);
      
       movePosition = (PVector)state.get("movepos");
       if (movePosition != null)
       //System.out.println(movePosition + " " + lastMovePosition + " " + movePosition.dist(lastMovePosition));
       
       if (movePosition != null ) {
         if (!lastMovePosition.equals(new PVector(0, 0, 0)) && movePosition.dist(lastMovePosition) < 100) {
           PVector movePCopy = movePosition.copy();
           PVector offsetPosition = movePCopy.sub(lastMovePosition);
           imgX += offsetPosition.x;
           imgY += offsetPosition.z * -10;
           System.out.println(offsetPosition.x + " " + offsetPosition.z);
         }
         lastMovePosition = movePosition;
       }
       
       image(img, imgX, imgY);

       if (pos != null)
         ellipse((pos.x + pointerXOffset)/scale, (pos.z + pointerZOffset)/scale, 50/scale, 50/scale);
       if (hand1pos != null)
         ellipse((hand1pos.x + pointerXOffset)/scale , (hand1pos.z + pointerZOffset)/scale, 50/scale, 50/scale);
       if (hand2pos != null)
         ellipse((hand2pos.x+ pointerXOffset)/scale , (hand2pos.z + pointerZOffset)/scale, 50/scale, 50/scale);
        
        
        
     } catch(Exception e) {
       e.printStackTrace();
     }
     
     previousDistance = distance;
}
