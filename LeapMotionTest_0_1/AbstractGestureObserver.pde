import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

public abstract class AbstractGestureObserver implements Observer {

  public AbstractGestureObserver() {
     events = new ArrayBlockingQueue<IGestureEvent>(20); 
  }
  
  protected ArrayBlockingQueue<IGestureEvent> events;
  protected void addEvent(IGestureEvent ev) {
    try {
    if(events.remainingCapacity() == 0)
      events.take();
    } catch (InterruptedException e) {
       e.printStackTrace(); 
    }
    events.add(ev);
  }
}