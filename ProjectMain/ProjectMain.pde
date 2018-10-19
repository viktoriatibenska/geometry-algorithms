import java.util.*;

/*
Declaration of global variables
*/

/* Buttons coordinates */
int randomBtnX, randomBtnY;
int clearBtnX, clearBtnY;
int grahamScanBtnX, grahamScanBtnY;
int giftWrappingBtnX, giftWrappingBtnY;
int sweepLineBtnX, sweepLineBtnY;

/* Current number of used buttons */
int numOfBtns = 5;

/* Button dimensions */
int btnWidth = 150;
int btnHeight = 40;

/* Button color and mouseover highlight color */
color btnColor, btnHighlight;
/* Background color */
color bColor;

/* Boolean variables specifying whether mouse is over said buttons or not */
boolean randomBtnOver = false;
boolean clearBtnOver = false;
boolean grahamScanBtnOver = false;
boolean giftWrappingBtnOver = false;
boolean sweepLineBtnOver = false;

PFont font;

/* Number of points that will be randomly generated on button click */
int randomPointsNum = 5;
/* Diameter of points */
int pointDiameter = 12;
/* List of all static points */
ArrayList<PVector> points;
/* Variable for point currently being moved by user.
   If such point doesn't exist, value is null. */
int movingIndex = -1;
ArrayList<Line> lines;

Polygon grahamScan = null;
Polygon giftWrap = null;

void setup() {
  size(1500, 900);
  
  points = new ArrayList<PVector>();
  lines = new ArrayList<Line>();
  
  /* Position of the random button */
  randomBtnX = 0;
  randomBtnY = 0;
  
  /* Position of the clear button, relative to the random button */
  clearBtnX = randomBtnX + btnWidth;
  clearBtnY = randomBtnY;
  
  giftWrappingBtnX = clearBtnX + btnWidth;
  giftWrappingBtnY = randomBtnY;
  
  grahamScanBtnX = giftWrappingBtnX + btnWidth;
  grahamScanBtnY = randomBtnY;

  sweepLineBtnX = grahamScanBtnX + btnWidth;
  sweepLineBtnY = randomBtnY;
  
  bColor = color(0, 26, 51);
  btnColor = color(242);
  btnHighlight = color(150);
  
  font = createFont("Arial", 18);
  textFont(font); 
}

void draw() {
  /* Call of update function to reset the values of BtnOver variables */
  update();
  background(bColor);
  
  stroke(0);
  
  /* If mouse is over random button, set color to highlight, otherwise use btnColor */
  if (randomBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  /* Draw random button */
  rect(randomBtnX, randomBtnY, btnWidth, btnHeight);
  
  /* If mouse is over clear button, set color to highlight, otherwise use btnColor */
  if (clearBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  /* Draw clear button */
  rect(clearBtnX, clearBtnY, btnWidth, btnHeight);
  
  /* If mouse is over gift wrapping button, set color to highlight, otherwise use btnColor */
  if (giftWrappingBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  /* Draw gift wrapping button */
  rect(giftWrappingBtnX, giftWrappingBtnY, btnWidth, btnHeight);
  
  /* If mouse is over graham scan button, set color to highlight, otherwise use btnColor */
  if (grahamScanBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  /* Draw graham scan button */
  rect(grahamScanBtnX, grahamScanBtnY, btnWidth, btnHeight);

  if (sweepLineBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  rect(sweepLineBtnX, sweepLineBtnY, btnWidth, btnHeight);
  
  /* Print button labels */
  fill(0);
  text("Random points", randomBtnX + 12, randomBtnY + 27);
  text("Clear", clearBtnX + 48, clearBtnY + 27);
  text("Gift wrapping", giftWrappingBtnX + 22, giftWrappingBtnY + 27);
  text("Graham scan", grahamScanBtnX + 19, grahamScanBtnY + 27);
  text("Sweep line", sweepLineBtnX + 31, sweepLineBtnY + 27);
  
  /* Draw moving point, if the user is moving one */
  if (movingIndex != -1) {
    stroke(255);
    fill(255);
    
    /* If user goes out of valid area for dropping the point, coordinates stay at last valid position. */
    if (!invalidArea(mouseX, mouseY)) {
      points.get(movingIndex).x = mouseX;
      points.get(movingIndex).y = mouseY;
    }
    ellipse(points.get(movingIndex).x, points.get(movingIndex).y, pointDiameter, pointDiameter);
  }
  
  stroke(255);
  strokeWeight(3);
  for(Line l : lines) {
    line(l.getFromX(), l.getFromY(), l.getToX(), l.getToY());
  }

  if (grahamScan != null) {
    grahamScan = grahamScan(points);
    stroke(252, 196, 27);
    strokeWeight(3);
    for(Line l : grahamScan.getLines()) {
      line(l.getFromX(), l.getFromY(), l.getToX(), l.getToY());
    }
  }

  if (giftWrap != null) {
    stroke(39, 249, 151);
    strokeWeight(3);
    for(Line l : giftWrap.getLines()) {
      line(l.getFromX(), l.getFromY(), l.getToX(), l.getToY());
    }
  }
  
  /* Draw every point from the points list */
  stroke(255);
  for (PVector p : points) {
    fill(255);
    ellipse(p.x, p.y, pointDiameter, pointDiameter);
  }
}

void mouseReleased() {
  /* Drop moving point if user releases mouse button. */
  if (movingIndex != -1) {
    movingIndex = -1;
  }
}

/* Handles mouse press events in all possible situations. */
void mousePressed() {
  /* User presses button to generate random points. */
  if (randomBtnOver) {
    generateRandomPoints();
  } 
  /* User presses button to clear the screen. */
  else if (clearBtnOver) {
    clearScreen();
  } 
  else if (grahamScanBtnOver) {
    grahamScan = grahamScan(points);
  }
  else if (giftWrappingBtnOver) {
    giftWrap = giftWrapping(points);
    lines.clear();
    grahamScan = null;
  }
  else if (sweepLineBtnOver) {
    if (grahamScan != null) {
      sweepLine(grahamScan);
    } else if (giftWrap != null) {
      sweepLine(giftWrap);
    }
  }
  /* User presses mouse outside of the buttons area */
  else {
    /* In case left mouse button was pressed, check if there is a point at the mouse position.
       If so, move it, if not, create a new one. */
    if (mouseButton == LEFT) {
      for (int i = 0; i < points.size(); i++) {
        if (overPoint(points.get(i).x, points.get(i).y)) {
          movingIndex = i;
          break;
        }
      }
      
      /* If no point was found at mouse coordinates, create a new one. */
      if (movingIndex == -1) {
        addPoint();
      }
    } 
    /* If the right mouse button was clicked, delete the point at current coordinates, if there is one. */
    else if (mouseButton == RIGHT) {
      removePoint();
    }
  }
}

/* When called, function updates the values of ___BtnOver variables, according to the current mouse position */
void update() {
  /* Check random button */
  if (overBtn(randomBtnX, randomBtnY, btnWidth, btnHeight)) {
    randomBtnOver = true;
  } else {
    randomBtnOver = false;
  }
  
  /* Check clear button */
  if (overBtn(clearBtnX, clearBtnY, btnWidth, btnHeight)) {
    clearBtnOver = true;
  } else {
    clearBtnOver = false;
  }
  
  /* Check graham scan button */
  if (overBtn(grahamScanBtnX, grahamScanBtnY, btnWidth, btnHeight)) {
    grahamScanBtnOver = true;
  } else {
    grahamScanBtnOver = false;
  }
  
  /* Check gift wrapping button */
  if (overBtn(giftWrappingBtnX, giftWrappingBtnY, btnWidth, btnHeight)) {
    giftWrappingBtnOver = true;
  } else {
    giftWrappingBtnOver = false;
  }

  /* Check sweep line button */
  if (overBtn(sweepLineBtnX, sweepLineBtnY, btnWidth, btnHeight)) {
    sweepLineBtnOver = true;
  } else {
    sweepLineBtnOver = false;
  }
}

/* Function generates new random points.
   The number of points generates is "randomPointsNum". */
void generateRandomPoints() {
  float x, y;
  
  for (int i = 0; i < randomPointsNum; i++) {
    /* The bounds of randomization specified, so that the points generated will
       be centralized, in order to eliminate too wide of a dispersion. */
    x = random(pointDiameter + width/5, width*4/5 - pointDiameter);
    y = random(pointDiameter + btnHeight + height/6, height*5/6 - pointDiameter);
    
    points.add(new PVector(x, y));
  }
}

/* Functions clears the screen by deleting all existing points. */
void clearScreen() {
  points.clear();
  lines.clear();
  grahamScan = null;
  giftWrap = null;
}

/* Function adds point at current mouse position. */
void addPoint() {
  points.add(new PVector(mouseX, mouseY));
}

/* Function deletes a point at the current mouse position, if there is one. */
void removePoint() {
  /* Go through the list of points */
  for (PVector p : points) {
    /* Check whether mouse is over current point, and if so, remove it. */
    if (overPoint(p.x, p.y)) {
      points.remove(p);
      break;
    }
  }
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
