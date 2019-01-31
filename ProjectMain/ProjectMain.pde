import java.util.*;

/*
Declaration of global variables
*/

/* Buttons coordinates */
int btnY = 0;
int randomBtnX = 0;
int clearBtnX;
int grahamScanBtnX;
int giftWrappingBtnX;
int sweepLineBtnX;
int createPolygonBtnX;
int kdTreeBtnX;
int delaunayTriangulationBtnX;
int voronoiDiagramBtnX;

/* Current number of used buttons */
int numOfBtns = 9;

/* Button dimensions */
int btnWidth = 167;
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
boolean kdTreeBtnOver = false;
boolean delaunayTriangulationBtnOver = false;
boolean voronoiDiagramBtnOver = false;

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
ArrayList<ActiveEdge> delaunayTriangulation = null;

void setup() {
  size(1504, 900);
  
  points = new ArrayList<PVector>();
  
  createPolygonBtnX = randomBtnX + btnWidth;
  clearBtnX = createPolygonBtnX + btnWidth;
  giftWrappingBtnX = clearBtnX + btnWidth;
  grahamScanBtnX = giftWrappingBtnX + btnWidth;
  sweepLineBtnX = grahamScanBtnX + btnWidth;
  kdTreeBtnX = sweepLineBtnX + btnWidth;
  delaunayTriangulationBtnX = kdTreeBtnX + btnWidth;
  voronoiDiagramBtnX = delaunayTriangulationBtnX + btnWidth;
  
  bColor = color(0, 26, 51);
  btnColor = color(242);
  btnHighlight = color(150);
  giftWrappingColor = color(39, 249, 151);
  grahamScanColor = color(252, 196, 27);
  
  font = createFont("Arial", 18);
  textFont(font); 
}

void drawButton(color highlight, boolean isOverBtn, int btnX) {
  if (isOverBtn) {
    fill(highlight);
  } else {
    fill(btnColor);
  }
  rect(btnX, btnY, btnWidth, btnHeight);
}

void draw() {
  /* Call of update function to reset the values of BtnOver variables */
  update();
  background(bColor);
  
  stroke(0);
  strokeWeight(1);
  fill(0);
  rect(0, 0, width, btnHeight);

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
  
  /* Draw the lines */
  if (lines != null) {
    stroke(255);
    strokeWeight(3);
    drawLines(lines);
  }

  /* Draw every point from the points list */
  stroke(255);
  for (PVector p : points) {
    fill(255);
    ellipse(p.x, p.y, pointDiameter, pointDiameter);
  }
  
  drawButton(btnHighlight, randomBtnOver, randomBtnX);
  drawButton(btnHighlight, clearBtnOver, clearBtnX);
  drawButton(giftWrappingColor, giftWrappingBtnOver, giftWrappingBtnX);
  drawButton(grahamScanColor, grahamScanBtnOver, grahamScanBtnX);
  drawButton(btnHighlight, sweepLineBtnOver, sweepLineBtnX);
  drawButton(btnHighlight, createPolygonBtnOver, createPolygonBtnX);
  drawButton(btnHighlight, kdTreeBtnOver, kdTreeBtnX);
  drawButton(btnHighlight, delaunayTriangulationBtnOver, delaunayTriangulationBtnX);
  drawButton(btnHighlight, voronoiDiagramBtnOver, voronoiDiagramBtnX);
  
  /* Print button labels */
  fill(0);
  text("Random points", randomBtnX + 23, btnY + 27);
  text("Create polygon", createPolygonBtnX + 23, btnY + 27);
  text("Clear", clearBtnX + 59, btnY + 27);
  text("Gift wrapping", giftWrappingBtnX + 31, btnY + 27);
  text("Graham scan", grahamScanBtnX + 28, btnY + 27);
  text("Sweep line", sweepLineBtnX + 40, btnY + 27);
  text("k-D Tree", kdTreeBtnX + 48, btnY + 27);
  text("Delaunay triang.", delaunayTriangulationBtnX + 20, btnY + 27);
  text("Voronoi diagrams", voronoiDiagramBtnX + 12, btnY + 27);
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
    delaunayTriangulation = null;
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
    delaunayTriangulation = null;
  }
  else if (giftWrappingBtnOver) {
    giftWrap = giftWrapping(points);
    grahamScan = null;
    userCreatedPolygon = null;
    lines = null;
    delaunayTriangulation = null;
  }
  else if (kdTreeBtnOver) {
    lines = kdTree(points);
    grahamScan = null;
    giftWrap = null;
    userCreatedPolygon = null;
    delaunayTriangulation = null;
  }
  else if (delaunayTriangulationBtnOver) {
    delaunayTriangulation = delaunay(points);
    lines = getDelaunayLines(delaunayTriangulation);
  }
  else if (voronoiDiagramBtnOver && delaunayTriangulation != null) {
    lines.addAll(voronoi(delaunayTriangulation));
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
    delaunayTriangulation = null;
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
  if (overBtn(randomBtnX, btnY, btnWidth, btnHeight)) {
    randomBtnOver = true;
  } else {
    randomBtnOver = false;
  }
  
  /* Check clear button */
  if (overBtn(clearBtnX, btnY, btnWidth, btnHeight)) {
    clearBtnOver = true;
  } else {
    clearBtnOver = false;
  }
  
  /* Check graham scan button */
  if (overBtn(grahamScanBtnX, btnY, btnWidth, btnHeight)) {
    grahamScanBtnOver = true;
  } else {
    grahamScanBtnOver = false;
  }
  
  /* Check gift wrapping button */
  if (overBtn(giftWrappingBtnX, btnY, btnWidth, btnHeight)) {
    giftWrappingBtnOver = true;
  } else {
    giftWrappingBtnOver = false;
  }

  /* Check sweep line button */
  if (overBtn(sweepLineBtnX, btnY, btnWidth, btnHeight)) {
    sweepLineBtnOver = true;
  } else {
    sweepLineBtnOver = false;
  }

  /* Check create polygon button */
  if (overBtn(createPolygonBtnX, btnY, btnWidth, btnHeight)) {
    createPolygonBtnOver = true;
  } else {
    createPolygonBtnOver = false;
  }

  /* Check create polygon button */
  if (overBtn(kdTreeBtnX, btnY, btnWidth, btnHeight)) {
    kdTreeBtnOver = true;
  } else {
    kdTreeBtnOver = false;
  }

  if (overBtn(delaunayTriangulationBtnX, btnY, btnWidth, btnHeight)) {
    delaunayTriangulationBtnOver = true;
  } else {
    delaunayTriangulationBtnOver = false;
  }

  if (overBtn(voronoiDiagramBtnX, btnY, btnWidth, btnHeight)) {
    voronoiDiagramBtnOver = true;
  } else {
    voronoiDiagramBtnOver = false;
  }
}

/* Functions clears the screen by deleting all existing points. */
void clearScreen() {
  points.clear();
  grahamScan = null;
  giftWrap = null;
  userCreatedPolygon = null;
  lines = null;
  delaunayTriangulation = null;
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
