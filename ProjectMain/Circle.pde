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

    public float crossProduct(RealPoint a, RealPoint b, RealPoint c) {
        float u1 = b.x - a.x;
        float v1 = b.y - a.y;
        float u2 = c.x - a.x;
        float v2 = c.y - a.y;
        return u1 * v2 - v1 * u2;
    }
}