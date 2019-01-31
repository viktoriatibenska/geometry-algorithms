public class ActiveEdge {
    RealPoint from;
    RealPoint to;
    ActiveEdge next;
    ActiveEdge twin;

    public ActiveEdge(RealPoint from, RealPoint to) {
        this.from = from;
        this.to = to;
        this.twin = null;
    }

    public void changeOrientation() {
        RealPoint temp = from;
        this.from = to;
        this.to = temp;
    }

    public ActiveEdge getOppositeOrientation() {
        ActiveEdge result = new ActiveEdge(this.to, this.from);
        return result;
    }

    public void setNext(ActiveEdge next) {
        this.next = next;
    }

    public void setTwin(ActiveEdge twin) {
        this.twin = twin;
    }
}
