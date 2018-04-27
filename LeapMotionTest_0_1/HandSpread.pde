
public class HandSpread implements IGesture {
  
  public boolean isActive(Collection<Hand> hands) {
    ArrayList<PVector> fingerPositions = new ArrayList<PVector>(); 
    if(hands.isEmpty())
      return false;
     for(Hand hand : hands)
       if(hand.getOutstretchedFingers().size() >= 4)
         return true;
     return false;
  }
  
  
  public IGestureEvent getEvent(Collection<Hand> hands) {
    return new HandSpread.Event(hands);
  }
  
  
  public class Event implements IGestureEvent {
    Collection<Hand> hands;
    public Event(Collection<Hand> hands) {
      this.hands = hands;       
    }
    public Collection<Hand> getHands() {
      return hands; 
    }
    
  }
}