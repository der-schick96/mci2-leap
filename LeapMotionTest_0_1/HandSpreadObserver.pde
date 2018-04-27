import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

public class HandSpreadObserver extends AbstractGestureObserver {
  
  @Override
   public void update(Observable o, Object obj) {
       if (obj instanceof IGestureEvent) {
         HandSpread.Event e = (HandSpread.Event)obj;
         addEvent(e);
         PVector direction = new PVector(0, 0, 0);
         for (IGestureEvent previousEvent : events) {
              direction.add(previousEvent.getHands().);
         }
       }
       
       else throw new IllegalArgumentException();
   }
}