public class Polygon {
    ArrayList<PVector> points;
    ArrayList<Line> lines;

    public Polygon() {
        this.points = new ArrayList<PVector>();
        this.lines = new ArrayList<Line>();
    }

    public Polygon(ArrayList<PVector> points) {
        this.points = points;
        this.lines = new ArrayList<Line>();
    }

    public void addPoint(PVector point) {
        this.points.add(point);
    }

    public ArrayList<PVector>  getPoints() {
        return this.points;
    }

    public ArrayList<Line> getLines() {
        this.lines.clear();
        for (int i = 0; i < this.points.size() - 1; i++) {
            this.lines.add(new Line(this.points.get(i).x, this.points.get(i).y, this.points.get(i+1).x, this.points.get(i+1).y));
        }
        this.lines.add(new Line(this.points.get(this.points.size()-1).x, this.points.get(points.size()-1).y, this.points.get(0).x, this.points.get(0).y));

        return this.lines;
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