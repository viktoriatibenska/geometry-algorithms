ArrayList<Line> sweepLine(Polygon polygon) {
  println("SWEEP LINE TRIANGULATION");
  ArrayList<Line> result = new ArrayList<Line>();
  ArrayList<PVector> sortedPoints = polygon.sortPoints();
  Stack<PVector> stack = new Stack<PVector>();
  Queue<PVector> right = new LinkedList<PVector>();
  Queue<PVector> left = new LinkedList<PVector>();

  PVector first = sortedPoints.get(0);
  PVector last = sortedPoints.get(sortedPoints.size() - 1);

  result.addAll(polygon.getLines());

  stack.push(first);
  stack.push(sortedPoints.get(1));

  
  for (int i = 2; i < sortedPoints.size(); i++) {
    println(sortedPoints.get(i).y, sortedPoints.get(i).x);
  }

  print(first);
  print(last);

  return result;
}

void delaunay(ArrayList<PVector> points) {
  ArrayList<RealPoint> realPoints = new ArrayList<RealPoint>();
  PVector leftmost = chooseStart(points);
  RealPoint first = new RealPoint(leftmost.x, leftmost.y);
  RealPoint closest;
  float distance = Float.MAX_VALUE;

  for (PVector p: points) {
    if (!p.equals(leftmost)) {
      RealPoint rp = new RealPoint(p.x, p.y);
      realPoints.add(rp);
      if (first.distance(rp) < distance) {
        distance = first.distance(rp);
        closest = rp;
      }
    }
  }

}

PVector chooseStart(ArrayList<PVector> points) {
  PVector pivot = null;

  for (PVector p : points) {
    if (pivot == null) {
      pivot = p;
    } else if (pivot.x > p.x) {
      pivot = p;
    }
  }
  
  return pivot;
}

float delaunayDistance(RealPoint a, RealPoint b, RealPoint c) {
  float num, centerX, centerY;

  float crossProduct = crossProduct(a, b, c);
  if (crossProduct != 0) {
    float aSq = Math.pow(a.x, 2) + Math.pow(a.y, 2);
    float bSq = Math.pow(b.x, 2) + Math.pow(b.y, 2);
    float cSq = Math.pow(c.x, 2) + Math.pow(c.y, 2);
    num = aSq * (b.y - c.y) + bSq * (c.y - a.y) + cSq * (a.y - b.y);
    centerX = num / (2.0 * crossProduct);
    num = aSq * (c.x - b.x) + bSq * (a.x - c.x) + cSq * (b.x - a.x);
    centerY = num / (2.0 * crossProduct);
    RealPoint center = new RealPoint(centerX, centerY);
    Circle circle = new Circle(center, center.distance(a))
    
  } else {
    return null;
  }
}
