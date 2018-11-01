/*
Function gets coordinates x and y and checks whether the current
mouse position is in a circle with those coordinates and diameter
"pointDiameter".

Returns: true if mouse is within a point
         false if mouse isn't within a point
*/
boolean overPoint(float x, float y) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < pointDiameter/2 ) {
    return true;
  } else {
    return false;
  }
}

/*
Function checks, whether the position specified by coordinates
x and y is valid or not. Invalid position is if the coordinates
are out of bounds of the screen dimentions, or if it is in the
buttons area.

Returns: true if position is valid
         false if position is invalid
*/
boolean invalidArea(float x, float y) {
  float pointRadius = pointDiameter / 2;
  
  // Out of bounds width-wise
  if (x - pointRadius < 0 || x + pointRadius > width) {
    return true;
  }
  // Out of bounds height-wise
  if (y - pointRadius < 0 || y + pointRadius > height) {
    return true;
  }
  // In the buttons area
  if (x - pointRadius < numOfBtns * btnWidth && y - pointRadius < btnHeight) {
    return true;
  }
  
  return false;
}

/*
Function gets coordinates x and y, width and height of a button and checks whether
the current mouse position is in a rectangle (button) with those attributes.

Returns: true if mouse is within a rectangle
         false if mouse isn't within a rectangle
*/
boolean overBtn(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

/* Function adds point at current mouse position. */
ArrayList<PVector> addPoint(ArrayList<PVector> points) {
  println("ADDING POINT");
  points.add(new PVector(mouseX, mouseY));
  return points;
}

/* Function deletes a point at the current mouse position, if there is one. */
ArrayList<PVector> removePoint(ArrayList<PVector> points) {
  println("REMOVING POINT");
  /* Go through the list of points */
  for (PVector p : points) {
    /* Check whether mouse is over current point, and if so, remove it. */
    if (overPoint(p.x, p.y)) {
      points.remove(p);
      break;
    }
  }
  return points;
}

void drawLines(ArrayList<Line> lines) {
  for(Line l : lines) {
    line(l.getFromX(), l.getFromY(), l.getToX(), l.getToY());
  }
}

ArrayList<PVector> deleteUnusedPoints(ArrayList<PVector> polygonPoints, ArrayList<PVector> points) {
  ArrayList<PVector> result = new ArrayList<PVector>(points);
  
  for (PVector p: points) {
    if (!polygonPoints.contains(p)) {
      result.remove(p);
    }
  }

  return result;
}
