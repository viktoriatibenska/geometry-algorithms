public class Line {
  private float fromX;
  private float fromY;
  private float toX;
  private float toY;
  private color clr = -1;
  
  public Line (float fromX, float fromY, float toX, float toY) {
    this.fromX = fromX;
    this.fromY = fromY;
    this.toX = toX;
    this.toY = toY;
  }
  public Line (float fromX, float fromY, float toX, float toY, color clr) {
    this.fromX = fromX;
    this.fromY = fromY;
    this.toX = toX;
    this.toY = toY;
    this.clr = clr;
  }

  public float getFromX(){
    return this.fromX;
  }
  public void setFromX(float value){
    this.fromX = value;
  }

  public float getFromY(){
    return this.fromY;
  }
  public void setFromY(float value){
    this.fromY = value;
  }

  public float getToX(){
    return this.toX;
  }
  public void setToX(float value){
    this.toX = value;
  }

  public float getToY(){
    return this.toY;
  }
  public void setToY(float value){
    this.toY = value;
  }

  public color getColor() {
    return this.clr;
  }
  public void setColor(color clr) {
    this.clr = clr;
  }
}
