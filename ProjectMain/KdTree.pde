ArrayList<Line> kdTree(ArrayList<PVector> points) {
    println("K-D TREE");
    KdNode root = buildKdTree(points, 0);
    ArrayList<Line> result = constructLines(root);
    return result;
}

KdNode buildKdTree(ArrayList<PVector> points, int depth) {
    if (points.size() == 1) {
        return new KdNode(depth, points.get(0), null, null, null);
    } else {
        ArrayList<PVector> sortedPoints = null;
        if (even(depth)) {
            sortedPoints = sortByX(points);
        } else {
            sortedPoints = sortByY(points);
        }
        int middle = int(sortedPoints.size() / 2);
        PVector divisor = sortedPoints.get(middle);
        ArrayList<PVector> p1 = new ArrayList<PVector>(sortedPoints.subList(0, middle));
        ArrayList<PVector> p2 = new ArrayList<PVector>(sortedPoints.subList(middle, sortedPoints.size()));

        KdNode vLeft = buildKdTree(p1, depth + 1);
        KdNode vRight = buildKdTree(p2, depth + 1);
        KdNode v = new KdNode(depth, divisor, null, vLeft, vRight);
        v.getLesser().setParent(v);
        v.getGreater().setParent(v);
        return v;
    }
}

ArrayList<Line> constructLines(KdNode node) {
    ArrayList<Line> result = new ArrayList<Line>();
    
    if (node.getLesser() == null && node.getGreater() == null) {
        return null;
    } else {
        result.add(new Line(node.point.x, btnHeight, node.point.x, height));
        return result;
    }
}

boolean even(int value) {
    if (value % 2 == 0) {
        return true;
    } else {
        return false;
    }
}

ArrayList<PVector> sortByX(ArrayList<PVector> points) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    int i;

    for (PVector p: points) {
        i = 0;
        while (i < result.size() && ((result.get(i).x < p.x) || (result.get(i).x == p.x && result.get(i).y < p.y))) {
            i++;
        }
        result.add(i, p);
    }

    return result;
}

ArrayList<PVector> sortByY(ArrayList<PVector> points) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    int i;

    for (PVector p: points) {
        i = 0;
        while (i < result.size() && ((result.get(i).y < p.y) || (result.get(i).y == p.y && result.get(i).x < p.x))) {
            i++;
        }
        result.add(i, p);
    }

    return result;
}
