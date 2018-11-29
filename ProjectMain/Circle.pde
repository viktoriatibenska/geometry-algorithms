public class Circle {
    RealPoint center;
    float radius;

    public Circle(RealPoint center, float radius) {
        this.center = center;
        this.radius = radius;
    }

    public boolean inside(RealPoint p) {
        if (center.distance(p) < Math.pow(radius, 2)) {
            return true;
        } else {
            return false;
        }
    }
}
