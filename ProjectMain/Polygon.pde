public class Polygon {
    ArrayList<PVector> points;
    ArrayList<Line> lines;

    public Polygon() {
        this.points = new ArrayList<PVector>();
        this.lines = new ArrayList<Line>();
    }

    public void addPoint(PVector point) {
        this.points.add(point);
    }

    public ArrayList<PVector>  getPoints() {
        return this.points;
    }

    public ArrayList<Line> getLines() {
        lines.clear();
        for (int i = 0; i < points.size() - 1; i++) {
            lines.add(new Line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y));
        }
        lines.add(new Line(points.get(points.size()-1).x, points.get(points.size()-1).y, points.get(0).x, points.get(0).y));

        return lines;
    }

    public ArrayList<PVector> sortPoints() {
        ArrayList<PVector> result = new ArrayList<PVector>();
        int i;

        for (PVector p: this.points) {
            i = 0;
            while (i < result.size() && ((result.get(i).y < p.y) || (result.get(i).y == p.y && result.get(i).x < p.x))) {
                i++;
            }
            result.add(i, p);
        }

        return result;
    }
}