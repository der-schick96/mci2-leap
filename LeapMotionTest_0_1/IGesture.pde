
public interface IGesture {
  public boolean isActive(ArrayList<Hand> hands);
  public IGestureEvent getEvent(ArrayList<Hand> hands);
}
