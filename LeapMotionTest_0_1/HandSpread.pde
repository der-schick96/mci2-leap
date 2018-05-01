import java.time.Instant;


public class HandSpread implements IGesture {
  
  @Override
  public boolean isActive(ArrayList<Hand> hands) {
     int nOutstretchedHands = 0;
     if(hands.isEmpty())
      return false;
     for(Hand hand : hands) {
       if(hand.getOutstretchedFingers().size() < 3)
         for(Finger finger : hand.getOutstretchedFingers())
            if(finger.getType() == 1)
              nOutstretchedHands++;
     }
     return nOutstretchedHands == 2;
  }
  
  @Override
  public IGestureEvent getEvent(ArrayList<Hand> hands) {
    return new HandSpread.Event(hands);
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
      if (getHands().size() == 2) {
        PVector hand1pos = getHands().get(0).getIndexFinger().getPositionOfJointTip();
        PVector hand2pos = getHands().get(1).getIndexFinger().getPositionOfJointTip();
        
        return new PVector((hand1pos.x + hand2pos.x)/2
                          , (hand1pos.y + hand2pos.y)/2
                          , (hand1pos.z + hand2pos.z)/2);
      }
      else return getHands().get(0).getPosition();
    }
    
  }
}
