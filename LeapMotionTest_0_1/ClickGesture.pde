
public class ClickGesture implements IGesture {
  
  @Override 
  boolean isActive(ArrayList<Hand> hands) {
    if (hands.size() != 1)
      return false;
    Hand hand = hands.get(0);
    return hand
    .getThumb()
    .getPositionOfJointTip()
    .dist(
      hand.getIndexFinger().getPositionOfJointTip()
      ) < 20;
  }
  
  @Override
  IGestureEvent getEvent(ArrayList<Hand> hands) {
    return new Event(hands);
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
      if (getHands().size() == 1) {
        PVector hand1pos = getHands().get(0).getIndexFinger().getPositionOfJointTip();
        PVector hand2pos = getHands().get(0).getThumb().getPositionOfJointTip();
        
        
        return new PVector((hand1pos.x + hand2pos.x)/2
                          , (hand1pos.y + hand2pos.y)/2
                          , (hand1pos.z + hand2pos.z)/2);
      }
      else return getHands().get(0).getPosition();
    }
    
  }
}
