public class Line {
  private float fromX;
  private float fromY;
  private float toX;
  private float toY;
  
  public Line (float fromX, float fromY, float toX, float toY) {
    this.fromX = fromX;
    this.fromY = fromY;
    this.toX = toX;
    this.toY = toY;
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
}