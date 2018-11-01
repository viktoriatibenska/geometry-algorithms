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
