import java.time.Instant;


public class MoveGesture implements IGesture {
  
  @Override
  public boolean isActive(ArrayList<Hand> hands) {
    if(hands.isEmpty())
      return false;
    for(Hand hand : hands) {
      for(Finger finger : hand.getFingers()) {
        if (finger.getType() == 0)
          continue;
        println("Winkel: " + PVector.angleBetween(finger.getDistalBone().getRawDirection(), finger.getMetacarpalBone().getRawDirection()));
        if (PVector.angleBetween(finger.getDistalBone().getRawDirection(), finger.getMetacarpalBone().getRawDirection()) < PI*0.8 )
          return false;
      }    
    }
    return true;
  }
  
  @Override
  public Event getEvent(ArrayList<Hand> hands) {
    return new MoveGesture.Event(hands);
  }
  
  
  public class Event implements IGestureEvent {
    ArrayList<Hand> hands;
    private Instant timestamp;
    public Event(ArrayList<Hand> hands) {
      this.hands = hands;
      this.timestamp = Instant.now();
    }
    public ArrayList<Hand> getHands() {
      return hands; 
    }
    public Instant getTimestamp() {
      return timestamp; 
    }
    @Override
    public PVector getPosition() {
      return hands.get(0).getPosition();
    }
    
  }
}
