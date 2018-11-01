public class KdNode {
    int k = 2;
    int depth;
    PVector point;
    KdNode parent;
    KdNode lesser;
    KdNode greater;

    public KdNode(int depth, PVector point,KdNode parent, KdNode lesser, KdNode greater) {
        this.depth = depth;
        this.point = point;
        this.parent = parent;
        this.lesser = lesser;
        this.greater = greater;
    }

    public void setParent(KdNode parent) {
        this.parent = parent;
    }
    public KdNode getParent() {
        return this.parent;
    }

    public void setLesser(KdNode lesser) {
        this.lesser = lesser;
    }
    public KdNode getLesser() {
        return this.lesser;
    }

    public void setGreater(KdNode greater) {
        this.greater = greater;
    }
    public KdNode getGreater() {
        return this.greater;
    }
}
