
public class ZoomGesture implements IGesture {
  
  public boolean isActive(ArrayList<Hand> hands) {
           
    for(Hand hand : hands) {
      boolean hasIndexOutstretched = false;
      boolean hasThumbOutstretched = false;
      
      for(Finger finger : hand.getOutstretchedFingers()) {
        if (finger.getType() != 1 && finger.getType() != 0)
          return false;
        if(finger.getType() == 1)
          hasIndexOutstretched = true;
        if(finger.getType() == 0)
          hasThumbOutstretched = true;
      }
      return hasIndexOutstretched && hasThumbOutstretched;
    }
    return false;
  }
  
  public IGestureEvent getEvent(ArrayList<Hand> hands){
    return new Event(hands);
  }
  
  public class Event implements IGestureEvent {
    private ArrayList<Hand> hands;
    private Instant timestamp;
    
    public Event(ArrayList<Hand> hands) {
      timestamp = Instant.now();
      this.hands = hands;
    }
    
    public ArrayList<Hand> getHands() {
      return hands;
    }
    public Instant getTimestamp() {
      return timestamp;
    }
    public PVector getPosition() {
      return hands.get(0).getIndexFinger().getRawPositionOfJointTip();
    }
  }
}
