import de.voidplus.leapmotion.*;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Observer;
import java.util.Observable;

LeapMotion leap;

void setup() {
  size(1024, 768);
  background(255);
  // ...
  leap = new LeapMotion(this);
  HandPublisher handPublisher = new HandPublisher(leap);
  handPublisher.addObserver(new HandSpreadObserver());
  handPublisher.addGesture(new HandSpread());
  
  
  Thread leapObserver = new Thread(handPublisher);
  leapObserver.run();
  
}

void loop() {
    
}