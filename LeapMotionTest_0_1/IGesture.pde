
public interface IGesture {
  public boolean isActive(Collection<Hand> hands);
  public IGestureEvent getEvent(Collection<Hand> hands);
}