
class Camera {
  
  private mat3 matrix;
  private vec3 rotation;
  private vec3 position;
  private vec3 velocity;
  private boolean matrix_updated;
  
  private PGraphics canvas;
  private PShader renderer;
  
  public Camera() {
    matrix = new mat3();
    rotation = new vec3();
    position = new vec3();
    velocity = new vec3();
    matrix_updated = true;
  }
  
  private void updateMatrix() {
    if(!matrix_updated) {
      matrix.clone(false);
      matrix.identity();
      matrix.rotateZ(rotation.e[vec3.Z]);
      matrix.rotateX(rotation.e[vec3.X]);
      matrix.rotateY(rotation.e[vec3.Y]);
      matrix.clone(true);
    }
  }
  
  public void updateShader() {
    renderer.set("canvasSize",(float)canvas.width,(float)canvas.height);
  }
  
  public void useShader(String name) {
    renderer = loadShader(name);
    if(canvas!=null) {
      updateShader();
    }
  }
  
  public void setDimensions(int width, int height) {
    if(canvas==null || canvas.width!=width || canvas.height!=height) {
      canvas = createGraphics(width,height,P3D);
      if(renderer!=null) {
        updateShader();
      }
    }
  }
  
  public void walk  (float speed) { updateMatrix(); velocity.clone(false).add(matrix.e[vec3.Z].mul(speed)); }
  public void strafe(float speed) { updateMatrix(); velocity.clone(false).add(matrix.e[vec3.X].mul(speed)); }
  
  public void turnX(float angle) { matrix_updated = false; rotation.e[vec3.Y] -= angle; }
  public void turnY(float angle) { matrix_updated = false; rotation.e[vec3.X] -= angle; }
  public void turnZ(float angle) { matrix_updated = false; rotation.e[vec3.Z] += angle; }
  
  public void drawGumball(float l) {
    updateMatrix();
    stroke(255,64,64); line(0,0,matrix.e[0].e[0]*l,matrix.e[0].e[1]*l);
    stroke(64,255,64); line(0,0,matrix.e[1].e[0]*l,matrix.e[1].e[1]*l);
    stroke(64,64,255); line(0,0,matrix.e[2].e[0]*l,matrix.e[2].e[1]*l);
  }
  
  public vec3 getVelocity() {
    return velocity;
  }
  
  public void move() {
    position.clone(false).add(velocity);
    velocity.clone(false).mul(0.5);
  }
  
  public void render() {
    if(canvas!=null && renderer!=null) {
      renderer.set("position",position.toPVector());
      renderer.set("rotation",matrix.toPMatrix3D());
      canvas.beginDraw();
      canvas.filter(renderer);
      canvas.endDraw();
    }
  }
  
  public void push(float x, float y, float z) {
    velocity.add(x,y,z);
  }
  
  public PShader getShader() {
    return renderer;
  }
  
  public PGraphics getCanvas() {
    return canvas;
  }
  
}
