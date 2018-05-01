import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

public class GestureObserver implements Observer {
  
  private Map<String, Object>store;
  
  public GestureObserver(Map<String, Object> store) {
    this.store = store;
  }
  
  
   @Override
   public void update(Observable o, Object obj) {
       store.clear();
       if (obj instanceof HandSpread.Event) {
           HandSpread.Event e = (HandSpread.Event)obj;
           PVector hand1pos = null;
           PVector hand2pos = null;
           PVector pos = e.getPosition();
           if (e.getHands().size() > 0) {
             hand1pos = e.getHands()
             .get(0)
             .getIndexFinger()
             .getPositionOfJointTip();
           } if (e.getHands().size() > 1) {
             hand2pos = e.getHands()
             .get(1)
             .getIndexFinger()
             .getPositionOfJointTip();
           }          
           store.put("hand1pos", hand1pos);
           store.put("hand2pos", hand2pos);
           if (hand1pos == null || hand2pos == null)
              store.put("pos", null);
           else
             store.put("pos", pos);
         }
         else if (obj instanceof ZoomGesture.Event) {
           ZoomGesture.Event e = (ZoomGesture.Event)obj;
           if (e.getHands().size() != 0) {
             Finger indexFinger = e.getHands()
             .get(0)
             .getIndexFinger();
             Finger thumb = e.getHands()
             .get(0)
             .getThumb();
             
             System.out.println(PVector.angleBetween(indexFinger.getIntermediateBone().getDirection(), thumb.getIntermediateBone().getDirection() ));
             if (indexFinger.getPositionOfJointTip()  != null)
               store.put("index-finger", indexFinger.getPositionOfJointTip());
             else
               store.remove("index-finger");
             if (thumb.getRawPositionOfJointTip()  != null)
                 store.put("thumb-finger", thumb.getPositionOfJointTip());
               else
                 store.remove("thumb-finger");  
           }
         }
         else if (obj instanceof MoveGesture.Event) {
           MoveGesture.Event e = (MoveGesture.Event)obj;
           store.put("movepos", e.getHands().get(0).getPosition());
         }
         else if (obj instanceof PointGesture.Event) {
             PointGesture.Event e = (PointGesture.Event)obj;
             store.put("pointpos", e.getHands().get(0).getIndexFinger().getPositionOfJointTip());  
         }
       }
}
       
