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

ArrayList<ActiveEdge> delaunay(ArrayList<PVector> points) {
  println("DELAUNAY TRIANGULATION");
  ArrayList<RealPoint> realPoints = new ArrayList<RealPoint>();
  PVector leftmost = chooseStart(points);
  RealPoint first = new RealPoint(leftmost.x, leftmost.y);
  RealPoint closest = null;
  float distance = Float.MAX_VALUE;

  /* Find the closest point to the chosen leftmost one */
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
  realPoints.remove(closest);
  println("Leftmost: ", leftmost);
  println("Closest: ", closest.toString());

  ArrayList<ActiveEdge> AEL = new ArrayList<ActiveEdge>();
  ArrayList<ActiveEdge> DT = new ArrayList<ActiveEdge>();
  ActiveEdge e1 = new ActiveEdge(first, closest);
  
  RealPoint p = findClosestDelaunay(e1, realPoints);
  if (p == null) {
    e1.changeOrientation();
    p = findClosestDelaunay(e1, realPoints);
  }
  realPoints.remove(p);
  println("Closest delaunay: ", p.toString());
  ActiveEdge e2 = new ActiveEdge(e1.to, p);
  ActiveEdge e3 = new ActiveEdge(p, e1.from);
  e1.setNext(e2);
  e2.setNext(e3);
  e3.setNext(e1);
  AEL.add(e1);
  AEL.add(e2);
  AEL.add(e3);

  while (AEL.size() > 0) {
    ActiveEdge e = AEL.get(0);
    ActiveEdge twin = new ActiveEdge(e.to, e.from);
    twin.setTwin(e);
    p = findClosestDelaunay(twin, realPoints);
    if (p != null) {
      e2 = new ActiveEdge(twin.to, p);
      e3 = new ActiveEdge(p, twin.from);
      twin.setNext(e2);
      e2.setNext(e3);
      e3.setNext(twin);
      e.setTwin(twin);
      realPoints.remove(p);

      // TODO: deal with adding edges to AEL and DT
      ActiveEdge flip = new ActiveEdge(e2.to, e2.from);
      if (isInList(flip, AEL)) {
        
        if (isInList(flip, DT)) {

        }
      }
    }
    DT.add(e);
    AEL.remove(0);
  }

  return AEL;
}

boolean isInList(ActiveEdge e, ArrayList<ActiveEdge> list) {
  for (ActiveEdge edge: list) {
    if (edge.x == e.x && edge.y == e.y) {
      return true;
    }
  }
  return false;
}

RealPoint findClosestDelaunay(ActiveEdge e, ArrayList<RealPoint> points) {
  RealPoint result = null;
  float distance = Float.MAX_VALUE;

  for (RealPoint p: points) {
    float currentDistance = delaunayDistance(e.from, e.to, p);
    if (isLeft(e, p) && currentDistance < distance) {
      result = p;
      distance = currentDistance;
    }
  }

  return result;
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
    float aSq = (float) (Math.pow(a.x, 2) + Math.pow(a.y, 2));
    float bSq = (float) (Math.pow(b.x, 2) + Math.pow(b.y, 2));
    float cSq = (float) (Math.pow(c.x, 2) + Math.pow(c.y, 2));
    num = aSq * (b.y - c.y) + bSq * (c.y - a.y) + cSq * (a.y - b.y);
    centerX = num / (2.0 * crossProduct);
    num = aSq * (c.x - b.x) + bSq * (a.x - c.x) + cSq * (b.x - a.x);
    centerY = num / (2.0 * crossProduct);
    RealPoint center = new RealPoint(centerX, centerY);
    Circle circle = new Circle(center, center.distance(a));
    
    if (isLeft(a, b, circle.center)) {
      return circle.radius;
    } else {
      return -1 * circle.radius;
    }
  } else {
    return Float.MAX_VALUE;
  }
}

public float crossProduct(RealPoint a, RealPoint b, RealPoint c) {
    float u1 = b.x - a.x;
    float v1 = b.y - a.y;
    float u2 = c.x - a.x;
    float v2 = c.y - a.y;
    return u1 * v2 - v1 * u2;
}

boolean isLeft(RealPoint a, RealPoint b, RealPoint c){
  float crossProduct = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);

  if (crossProduct > 0){
    return true;
  } else {
    return false;
  }
}

boolean isLeft(ActiveEdge e, RealPoint c){
  float crossProduct = (e.to.x - e.from.x) * (c.y - e.from.y) - (e.to.y - e.from.y) * (c.x - e.from.x);

  if (crossProduct > 0){
    return true;
  } else {
    return false;
  }
}

ArrayList<Line> getDelaunayLines(ArrayList<ActiveEdge> dt) {
  ArrayList<Line> result = new ArrayList<Line>();
  
  for (ActiveEdge e: dt) {
    Line currentLine = new Line(e.from.x, e.from.y, e.to.x, e.to.y);
    // TODO: add check if the line is not already added
    result.add(currentLine);
  }

  if (result.size() > 0) {
    return result;
  } else {
    return null;
  }
}
