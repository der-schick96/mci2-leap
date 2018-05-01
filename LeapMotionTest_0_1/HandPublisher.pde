
class HandPublisher extends Observable implements Runnable {
  
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
      ArrayList<Hand> hands;
      hands = leap.getHands();
      for (IGesture gesture : gestures) {
        if(gesture.isActive(hands)) {
          setChanged();
          notifyObservers(gesture.getEvent(hands));
        }
      }
      try {
        Thread.sleep(10);
      } catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
}
