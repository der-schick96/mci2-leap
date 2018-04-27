
public class HandPublisher extends Observable implements Runnable {
  private LeapMotion lm;
  private ArrayList<IGesture> gestures = new ArrayList<IGesture>();
  public HandPublisher(LeapMotion lm) {
    this.lm = lm;
  }
  
  public void addGesture(IGesture gesture) {
    gestures.add(gesture);
  }
  
  @Override
  public void run() {
    int i = 0;
    while(true) {
      Collection<Hand> hands;
      hands = leap.getHands();
      for (IGesture gesture : gestures) {
        System.out.println("Checking gesture " + i);
        if(gesture.isActive(hands)) {
          setChanged();
          notifyObservers(gesture.getEvent(hands));
        }
      }
      try {
        Thread.sleep(1000);
      } catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
}