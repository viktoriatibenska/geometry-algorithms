public class Point implements Comparable<Point> {
  private float angle;
  private PVector point;
  
  Point (PVector point, float angle) {
    this.point = point;
    this.angle = angle;
  }
  
  @Override
  public int compareTo(Point p) {
    return Float.compare(this.angle, p.getAngle());
  }
  
  public float getAngle() {
    return this.angle;
  }
  
  public void setAngle(float angle) {
    this.angle = angle;
  }
  
  public PVector getPoint() {
    return point;
  }

  public void setPoint(PVector point) {
    this.point = point;
  }
}
