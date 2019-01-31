Polygon giftWrapping(ArrayList<PVector> points) {
  println("GIFT WRAPPING");

  Polygon result = null;
  PVector pivot = null;

  for (PVector p : points) {
    if (pivot == null) {
      pivot = p;
    } else if ((pivot.y < p.y) || (pivot.y == p.y && pivot.x < p.x)) {
      pivot = p;
    }
  }

  if (pivot != null) {
    result = new Polygon();

    PVector chosenPoint = pivot;
    PVector candidate;
    do {
      result.addPoint(chosenPoint);
      candidate = points.get((points.indexOf(chosenPoint) + 1) % points.size());

      for (PVector p: points) {
        if (checkLeftTurnCriterion(chosenPoint, p, candidate)) {
          candidate = p;
        }
      }

      chosenPoint = candidate;
    } while (!chosenPoint.equals(pivot));
  }
  return result;
}

/*
  Calculates the cross product of 3 points. If the result is greater than 0,
  the left turn criterion is fulfilled, if it is less than 0, it is not.
*/
boolean checkLeftTurnCriterion(PVector a, PVector b, PVector c){
  float crossProduct = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);

  if (crossProduct > 0){
    return true;
  } else {
    return false;
  }
}


ArrayList<Point> sortPointsByAngle(ArrayList<PVector> points, PVector relativeTo) {
  ArrayList<Point> result = new ArrayList<Point>();
  float angle;

  for (PVector p : points) {
    if (relativeTo != p) {
      PVector v = PVector.sub(p, relativeTo);
      
      angle = PVector.angleBetween(v, new PVector(1, 0));
      result.add(new Point(p, angle));
    }
  }
  Collections.sort(result);

  return result;
}

PVector choosePivot(ArrayList<PVector> points) {
  PVector pivot = null;
  
  for (PVector p : points) {
    if (pivot == null) {
      pivot = p;
    } else if ((pivot.y < p.y) || (pivot.y == p.y && pivot.x < p.x)) {
      pivot = p;
    }
  }

  return pivot;
}

Polygon grahamScan(ArrayList<PVector> points) {
  println("GRAHAM SCAN");
  
  Polygon result = null;
  ArrayList<Point> sortedPoints = new ArrayList<Point>();
  Stack<Point> s = new Stack<Point>();
  int j;
  PVector pivot = choosePivot(points);
  
  if (pivot != null && points.size() > 2) {
    // Sort the points by angle relative to pivot
    sortedPoints = sortPointsByAngle(points, pivot);

    // For the points that have the same angle, remove the ones closer to pivot
    j = 0;
    while (j < sortedPoints.size() - 1) {
      if (sortedPoints.get(j).angle == sortedPoints.get(j+1).angle) {
        if (pivot.dist(sortedPoints.get(j).point) > pivot.dist(sortedPoints.get(j+1).point)) {
          sortedPoints.remove(j+1);
        } else {
          sortedPoints.remove(j);
        }
      } else {
        j++;
      }
    }
    
    j = 1;
    Point last = sortedPoints.get(0);
    Point beforeLast = new Point(pivot, 0.0);
    s.push(beforeLast);
    s.push(last);
    
    while (j < sortedPoints.size()) {
      Point current = sortedPoints.get(j);
      if (checkLeftTurnCriterion(beforeLast.point, current.point, last.point)) {
        beforeLast = last;
        last = current;
        s.push(last);
        j++;
      } else {
        s.pop();
        last = s.pop();
        beforeLast = s.peek();
        s.push(last);
      }
    }

    result = new Polygon();
    result.addPoint(s.pop().point);
    
    while(s.size() > 0) {
      result.addPoint(s.pop().point);
    }
  }
  return result;
}
