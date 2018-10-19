void sweepLine(Polygon polygon) {
  println("SWEEP LINE");

  ArrayList<PVector> sortedPoints = polygon.sortPoints();
  Stack<PVector> stack = new Stack<PVector>();

  for (PVector p: sortedPoints) {
    println(p.y, p.x);
  }
}
