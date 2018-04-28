import java.time.Instant;

public interface IGestureEvent {
  public ArrayList<Hand> getHands();
  public Instant getTimestamp();
  public PVector getPosition();
}
