import java.time.Instant;


public class PointGesture implements IGesture {
  
  @Override
  public boolean isActive(ArrayList<Hand> hands) {
    if(hands.isEmpty() || hands.size() != 1)
      return false;
     int nOutstretchedFingers = 0;
     for(Hand hand : hands) {
       if(hand.getOutstretchedFingers().size() <= 2 && hand.getIndexFinger().isExtended()) {
         nOutstretchedFingers++;
       }
     }
     return nOutstretchedFingers == 1;
  }
  
  @Override
  public Event getEvent(ArrayList<Hand> hands) {
    return new PointGesture.Event(hands);
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
      return hands.get(0).getIndexFinger().getRawPositionOfJointTip();
    }
    
  }
}
