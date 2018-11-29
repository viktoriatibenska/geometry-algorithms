import java.lang.Math;

public class RealPoint {
    float x;
    float y;

    public RealPoint(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public float distance(RealPoint a, RealPoint b) {
        return (float) Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
    }

    public float distance(RealPoint p) {
        return (float) Math.sqrt(Math.pow(this.x - p.x, 2) + Math.pow(this.y - p.y, 2));
    }

    @Override
    public String toString() {
        return "(x: " + this.x + ", y: " + this.y + ")";
    }
}
