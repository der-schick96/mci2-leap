import java.time.Instant;


public class MoveGesture implements IGesture {
  
  @Override
  public boolean isActive(ArrayList<Hand> hands) {
    if(hands.isEmpty())
      return false;
     int nOutstretchedHands = 0;
     for(Hand hand : hands) {
       if(hand.getOutstretchedFingers().size() > 0) {
         nOutstretchedHands++;
       }
     }
     return nOutstretchedHands == 0;
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
