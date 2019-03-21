
Camera camera;
boolean[] input = new boolean[256];

float turn_x;
float turn_y;

float gravity = 5.0;
float spin = 0.0;

int iterations = 256;

void setup() {
  
  size(840,640,P3D);
  //fullScreen(P3D);
  noSmooth();
  ((PGraphicsOpenGL)g).textureSampling(POINT);
  
  camera = new Camera();
  camera.setDimensions(width,height);
  camera.useShader("raymarch.glsl");
  
  camera.getShader().set("sphereRadius",5.0);
  camera.getShader().set("sphereOrigin",0.0,0.0,25.0);
  /*
  camera.getShader().set("ringInnerRadius",14.0);
  camera.getShader().set("ringOuterRadius",36.0);
  */
  camera.getShader().set("blackHoleGravity",gravity);
  camera.getShader().set("blackHoleSpin",spin);
  
  camera.getShader().set("skymap",loadImage("sky.jpg"));
  
  camera.position.e[2] = -100.0;
}

void keyPressed() { input[keyCode]=true; }
void keyReleased() { input[keyCode]=false; }

void draw() {
  
  //camera.getShader().set("time",(float)frameCount);
  
  {
    float walk_speed = 1.2;
    float turn_speed = 0.005;
    
    float turn_x_target = 0;
    float turn_y_target = 0;
    if(mousePressed) {
      if(mouseButton==RIGHT) {
        turn_x_target = (mouseX-pmouseX)*turn_speed;
        turn_y_target = (mouseY-pmouseY)*turn_speed;
      } else {
        gravity = 10.0*(int)(100.0*mouseX/width);
        spin = 1.0*(int)(100.0*mouseY/height);
        camera.getShader().set("blackHoleGravity",gravity);
        camera.getShader().set("blackHoleSpin",spin);
      }
    }
    turn_x += (turn_x_target-turn_x)*0.2;
    turn_y += (turn_y_target-turn_y)*0.2;
    
    if(input['w'-32]) { camera.walk( walk_speed); }
    if(input['s'-32]) { camera.walk(-walk_speed); }
    if(input['d'-32]) { camera.strafe( walk_speed); }
    if(input['a'-32]) { camera.strafe(-walk_speed); }
    if(input[32]) { camera.push(0, walk_speed,0); }
    if(input[16]) { camera.push(0,-walk_speed,0); }
    camera.turnX(turn_x);
    camera.turnY(turn_y);
  }
  
  {
    float angle = frameCount/30.0;
    float range = 50.0;
    camera.getShader().set("sphereOrigin",
      range*cos(angle),
      0.0,
      range*sin(angle));
  }
  
  camera.getShader().set("iterations",iterations);
  if(frameRate<50) {
    if(iterations>16) {
      iterations -= 4;
    }
  } else {
    if(iterations<2048) {
      iterations += 4;
    }
  }
  
  //camera.getShader().set("velocity",camera.velocity.clone(true).mul(1e-4).toPVector());
  camera.render();
  camera.move();
  //tint(255,192);
  image(camera.getCanvas(),0,0);
  
  resetShader();
  
  pushMatrix();
  translate(width-50,height-50);
  camera.drawGumball(20);
  popMatrix();
  
  textAlign(LEFT,TOP);
  fill(255);
  textSize(24);
  text("iter: "+iterations,4,4);
  
  surface.setTitle("FPS: "+frameRate);
}
