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
int createPolygonBtnX, createPolygonBtnY;
int orthogonalSearchBtnX, orthogonalSearchBtnY;

/* Current number of used buttons */
int numOfBtns = 7;

/* Button dimensions */
int btnWidth = 150;
int btnHeight = 40;

/* Button color and mouseover highlight color */
color btnColor, btnHighlight;
/* Background color */
color bColor;
/* Gift wrapping, graham scan highlight color */
color giftWrappingColor, grahamScanColor;

/* Boolean variables specifying whether mouse is over said buttons or not */
boolean randomBtnOver = false;
boolean clearBtnOver = false;
boolean grahamScanBtnOver = false;
boolean giftWrappingBtnOver = false;
boolean sweepLineBtnOver = false;
boolean createPolygonBtnOver = false;

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

Polygon grahamScan = null;
Polygon giftWrap = null;
Polygon userCreatedPolygon = null;

ArrayList<Line> lines = null;

void setup() {
  size(1500, 900);
  
  points = new ArrayList<PVector>();
  
  /* Position of the random button */
  randomBtnX = 0;
  randomBtnY = 0;
  
  createPolygonBtnX = randomBtnX + btnWidth;
  createPolygonBtnY = randomBtnY;

  /* Position of the clear button */
  clearBtnX = createPolygonBtnX + btnWidth;
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
  giftWrappingColor = color(39, 249, 151);
  grahamScanColor = color(252, 196, 27);
  
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
    fill(giftWrappingColor);
  } else {
    fill(btnColor);
  }
  /* Draw gift wrapping button */
  rect(giftWrappingBtnX, giftWrappingBtnY, btnWidth, btnHeight);
  
  /* If mouse is over graham scan button, set color to highlight, otherwise use btnColor */
  if (grahamScanBtnOver) {
    fill(grahamScanColor);
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

  if (createPolygonBtnOver) {
    fill(btnHighlight);
  } else {
    fill(btnColor);
  }
  rect(createPolygonBtnX, createPolygonBtnY, btnWidth, btnHeight);
  
  /* Print button labels */
  fill(0);
  text("Random points", randomBtnX + 12, randomBtnY + 27);
  text("Create polygon", createPolygonBtnX + 14, createPolygonBtnY + 27);
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

    if (grahamScan != null) {
      grahamScan = grahamScan(points);
    }
    if (giftWrap != null) {
      giftWrap = giftWrapping(points);
    }
  }

  if (grahamScan != null) {
    stroke(grahamScanColor);
    strokeWeight(3);
    drawLines(grahamScan.getLines());
  }

  if (giftWrap != null) {
    stroke(giftWrappingColor);
    strokeWeight(3);
    drawLines(giftWrap.getLines());
  }

  if (userCreatedPolygon != null) {
    stroke(255);
    strokeWeight(3);
    drawLines(userCreatedPolygon.getLines());
  }
  
  /* Draw every point from the points list */
  stroke(255);
  for (PVector p : points) {
    fill(255);
    ellipse(p.x, p.y, pointDiameter, pointDiameter);
  }

  if (lines != null) {
    drawLines(lines);
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
  else if (createPolygonBtnOver) {
    createPolygon();
    grahamScan = null;
    giftWrap = null;
    lines = null;
  } 
  /* User presses button to clear the screen. */
  else if (clearBtnOver) {
    clearScreen();
  } 
  else if (grahamScanBtnOver) {
    grahamScan = grahamScan(points);
    giftWrap = null;
    userCreatedPolygon = null;
    lines = null;
  }
  else if (giftWrappingBtnOver) {
    giftWrap = giftWrapping(points);
    grahamScan = null;
    userCreatedPolygon = null;
    lines = null;
  }
  else if (sweepLineBtnOver) {
    if (grahamScan != null) {
      lines = sweepLine(grahamScan);
      points = deleteUnusedPoints(grahamScan.getPoints(), points);
    } else if (giftWrap != null) {
      lines = sweepLine(giftWrap);
      points = deleteUnusedPoints(giftWrap.getPoints(), points);
    } else if (userCreatedPolygon != null) {
      lines = sweepLine(userCreatedPolygon);
      points = deleteUnusedPoints(userCreatedPolygon.getPoints(), points);
    }
    grahamScan = null;
    giftWrap = null;
    userCreatedPolygon = null;
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
        points = addPoint(points);
      }
    } 
    /* If the right mouse button was clicked, delete the point at current coordinates, if there is one. */
    else if (mouseButton == RIGHT) {
      points = removePoint(points);
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

  /* Check create polygon button */
  if (overBtn(createPolygonBtnX, createPolygonBtnY, btnWidth, btnHeight)) {
    createPolygonBtnOver = true;
  } else {
    createPolygonBtnOver = false;
  }
}

/* Functions clears the screen by deleting all existing points. */
void clearScreen() {
  points.clear();
  grahamScan = null;
  giftWrap = null;
  userCreatedPolygon = null;
}

void createPolygon() {
  println("CREATING POLYGON");
  userCreatedPolygon = new Polygon(points);
}

/* Function generates new random points.
   The number of points generates is "randomPointsNum". */
void generateRandomPoints() {
  println("GENERATING RANDOM POINTS");
  float x, y;
  
  for (int i = 0; i < randomPointsNum; i++) {
    /* The bounds of randomization specified, so that the points generated will
       be centralized, in order to eliminate too wide of a dispersion. */
    x = random(pointDiameter + width/10, width*9/10 - pointDiameter);
    y = random(pointDiameter + btnHeight + height/12, height*11/12 - pointDiameter);
    
    points.add(new PVector(x, y));
  }
}
