ArrayList<Line> sweepLine(Polygon polygon) {
  println("SWEEP LINE TRIANGULATION");
  //color lineColor = color(128, 227, 0);
  color lineColor = color(255);
  ArrayList<Line> result = new ArrayList<Line>();
  Stack<PVector> stack = new Stack<PVector>();
  ArrayList<PVector> right = new ArrayList<PVector>();
  ArrayList<PVector> left = new ArrayList<PVector>();

  /*
  println("Polygon points order:");
  for (PVector p: polygon.getPoints()){
    println(p);
  }
  */

  // Sort points lexicographically
  ArrayList<PVector> sortedPoints = polygon.sortPoints();
  PVector first = sortedPoints.get(0);
  PVector last = sortedPoints.get(sortedPoints.size() - 1);
  
  // Separate left and right paths
  int indexFirst = polygon.points.indexOf(first);
  int indexLast = polygon.points.indexOf(last);
  int index = (indexFirst + 1) % polygon.points.size();
  boolean switchSides;
  if (first.x >= polygon.points.get(index).x) {
    switchSides = false;
  } else {
    switchSides = true;
  }
  left.add(first);
  while (index != indexFirst) {
    if (index == indexLast) {
      switchSides = !switchSides;
    }
    if (!switchSides) {
      left.add(polygon.points.get(index));
    } else {
      right.add(polygon.points.get(index));
    }
    index = (index + 1) % polygon.points.size();
  }
  
  /*
  println("Left path");
  for (PVector p: left){
    println(p);
  }

  println("Right path");
  for (PVector p: right){
    println(p);
  }
  */

  stack.push(first);
  stack.push(sortedPoints.get(1));

  for (int i = 2; i < sortedPoints.size(); i++) {
    PVector vi = sortedPoints.get(i);
    PVector stackTop = stack.peek();
    boolean correctLine = true;
    int checkPath = samePath(vi, stackTop, right, left);
    println("Current: ", vi, " ... StackTop: ", stackTop, " ... Path: ", pathName(checkPath));
    if (checkPath == 0 || checkPath == 1) {
      while (stack.size() >= 2 && correctLine) {
        PVector vj = stack.pop();
        PVector vk = stack.pop();
        if ((checkLeftTurnCriterion(vk, vj, vi) && checkPath == 0) || (!checkLeftTurnCriterion(vk, vj, vi) && checkPath == 1)) {
          result.add(new Line(vi.x, vi.y, vk.x, vk.y, lineColor));
          stack.push(vk);
        } else {
          stack.push(vk);
          stack.push(vj);
          correctLine = false;
        }
      }
    } else {
      while (stack.size() > 0) {
        PVector v = stack.pop();
        result.add(new Line(vi.x, vi.y, v.x, v.y, lineColor));
      }
      stack.push(stackTop);
    }
    stack.push(vi);
  }

  result.addAll(polygon.lines);
  return result;
}

String pathName(int value) {
  if (value == 0) {
    return "both right";
  } else if (value == 1) {
    return "both left";
  } else {
    return "different";
  }
}

/*
Return values:
0 - both points on right path
1 - both points on left path
2 - points arent on the same path
*/
int samePath(PVector p1, PVector p2, ArrayList<PVector> right, ArrayList<PVector> left) {
  if (right.contains(p1) && right.contains(p2)) {
    return 0;
  }
  if (left.contains(p1) && left.contains(p2)) {
    return 1;
  }
  return 2;
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

  ArrayList<ActiveEdge> AEL = new ArrayList<ActiveEdge>();
  ArrayList<ActiveEdge> DT = new ArrayList<ActiveEdge>();
  ActiveEdge e1 = new ActiveEdge(first, closest);
  
  RealPoint p = findClosestDelaunay(e1, realPoints);
  if (p == null) {
    e1.changeOrientation();
    p = findClosestDelaunay(e1, realPoints);
  }
  ActiveEdge e2 = new ActiveEdge(e1.to, p);
  ActiveEdge e3 = new ActiveEdge(p, e1.from);
  e1.setNext(e2);
  e2.setNext(e3);
  e3.setNext(e1);
  e1.setTwin(e1.getOppositeOrientation());
  e2.setTwin(e2.getOppositeOrientation());
  e3.setTwin(e3.getOppositeOrientation());
  AEL.add(e1);
  AEL.add(e2);
  AEL.add(e3);
  DT.add(e1);
  DT.add(e2);
  DT.add(e3);
  /*println("Triangle:");
  printEdge(e1);
  printEdge(e2);
  printEdge(e3);*/

  while (AEL.size() > 0) {
    ActiveEdge e = AEL.get(0);
    ActiveEdge twin = e.getOppositeOrientation();
    twin.setTwin(e);
    p = findClosestDelaunay(twin, realPoints);
    if (p != null) {
      e2 = new ActiveEdge(twin.to, p);
      e3 = new ActiveEdge(p, twin.from);
      twin.setNext(e2);
      e2.setNext(e3);
      e3.setNext(twin);
      e2.setTwin(e2.getOppositeOrientation());
      e3.setTwin(e3.getOppositeOrientation());
      twin.twin.setTwin(e3);
      e2.twin.setTwin(twin);
      e3.twin.setTwin(e2);

      if (isInList(e2.twin, AEL)) {
        AEL.remove(e2);
      } else if (!isInList(e2, DT)) {
        AEL.add(e2);
      }
      if (isInList(e3.twin, AEL)) {
        AEL.remove(e3);
      } else if (!isInList(e3, DT)) {
        AEL.add(e3);
      }
      DT.add(twin);
      DT.add(e2);
      DT.add(e3);
      /*println("Triangle:");
      printEdge(twin);
      printEdge(e2);
      printEdge(e3);*/
    }
    e.setTwin(twin);
    AEL.remove(e);
  }

  return DT;
}

void printEdge(ActiveEdge e) {
  println("Edge: [", e.from.x, e.from.y, "] -> [", e.to.x, e.to.y, "]");
}

ArrayList<Line> voronoi(ArrayList<ActiveEdge> dt) {
  println("VORONOI DIAGRAMS");
  color lineColor = color(128, 227, 0);
  ArrayList<Line> voronoiLines = new ArrayList<Line>();
  ArrayList<ArrayList<ActiveEdge>> previousTriplets = new ArrayList<ArrayList<ActiveEdge>>();

  for (int i = 0; i < dt.size(); i++) {
    ArrayList<ActiveEdge> edges = new ArrayList<ActiveEdge>();
    edges.add(dt.get(i));
    edges.add(edges.get(edges.size()-1).next);
    edges.add(edges.get(edges.size()-1).next);
    Circle circle = circumscribe(edges.get(0).from, edges.get(1).from, edges.get(2).from);
    if (circle != null && uniqueEdges(edges, previousTriplets)) {
      for (ActiveEdge e: edges) {
        if (e.twin != null && e.twin.next != null) {
          Circle neighbourCircle = circumscribe(e.from, e.to, e.twin.next.to);
          if (neighbourCircle != null) {
            voronoiLines.add(new Line(circle.center.x, circle.center.y, neighbourCircle.center.x, neighbourCircle.center.y, lineColor));
          }
        }
        if (e.twin.next == null) {
          PVector perpendicular = e.perpendicularVector();
          PVector endPoint = new PVector(circle.center.x + perpendicular.x * circle.radius * 5, circle.center.y + perpendicular.y * circle.radius * 5);
          voronoiLines.add(new Line(circle.center.x, circle.center.y, endPoint.x, endPoint.y, lineColor));
        }
      }
    }
    previousTriplets.add(edges);
  }

  return voronoiLines;
}

boolean uniqueEdges(ArrayList<ActiveEdge> currentEdges, ArrayList<ArrayList<ActiveEdge>> previousTriplets) {
  for (ArrayList<ActiveEdge> p: previousTriplets) {
    if(p.contains(currentEdges.get(0)) && p.contains(currentEdges.get(1)) && p.contains(currentEdges.get(2))) {
      return false;
    }
  }
  return true;
}

boolean isInList(ActiveEdge e, ArrayList<ActiveEdge> list) {
  for (ActiveEdge edge: list) {
    if (edge.from.x == e.from.x && edge.from.y == e.from.y && edge.to.x == e.to.x && edge.to.y == e.to.y) {
      return true;
    }
  }
  return false;
}

RealPoint findClosestDelaunay(ActiveEdge e, ArrayList<RealPoint> points) {
  RealPoint result = null;
  float distance = Float.MAX_VALUE;

  for (RealPoint p: points) {
    if (!p.equals(e.from) && !p.equals(e.to)) {
      float currentDistance = delaunayDistance(e.from, e.to, p);
      //println("Distance for", p, "is", currentDistance, "left:", isLeft(e, p));
      if (isLeft(e, p) && currentDistance < distance) {
        result = p;
        distance = currentDistance;
      }
    }
  }
  // println("Delaunay distance:", result, distance);
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

Circle circumscribe(RealPoint a, RealPoint b, RealPoint c) {
  Circle res = null;
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
    res = new Circle(center, center.distance(a));
  }
  return res;
}

float delaunayDistance(RealPoint a, RealPoint b, RealPoint c) {
  Circle circle = circumscribe(a, b, c);
  if (circle != null) {
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

  if (crossProduct >= 0){
    return true;
  } else {
    return false;
  }
}

ArrayList<Line> getDelaunayLines(ArrayList<ActiveEdge> dt) {
  ArrayList<Line> result = new ArrayList<Line>();
  
  for (ActiveEdge e: dt) {
    Line currentLine = new Line(e.from.x, e.from.y, e.to.x, e.to.y);
    result.add(currentLine);
  }

  if (result.size() > 0) {
    return result;
  } else {
    return null;
  }
}
