
class mat3 {
  
  private vec3[] e = new vec3[3];
  private boolean clone_mode = false;
  
  public mat3 getTarget() {
    return clone_mode?new mat3(this):this;
  }
  
  public mat3(
      float x0, float y0, float z0,
      float x1, float y1, float z1,
      float x2, float y2, float z2) {
    init();
    set(x0,y0,z0,x1,y1,z1,x2,y2,z2);
  }
  
  public mat3(mat3 v) {
    init();
    set(v);
  }
  
  public mat3(vec3 x, vec3 y, vec3 z) {
    init();
    set(x,y,z);
  }
  
  public void set(
      float x0, float y0, float z0,
      float x1, float y1, float z1,
      float x2, float y2, float z2) {
    e[0].set(x0,y0,z0);
    e[1].set(x1,y1,z1);
    e[2].set(x2,y2,z2);
  }
  
  public void set(vec3 x, vec3 y, vec3 z) {
    e[0].set(x);
    e[1].set(y);
    e[2].set(z);
  }
  
  public void set(mat3 v) {
    set(v.e[0],v.e[1],v.e[2]);
  }
  
  private void init() {
    e[0] = new vec3();
    e[1] = new vec3();
    e[2] = new vec3();
  }
  
  public mat3() {
    init();
    identity();
  }
  
  public mat3 clone(boolean value) {
    clone_mode = value;
    e[0].clone(value);
    e[1].clone(value);
    e[2].clone(value);
    return this;
  }
  
  public void identity() {
    e[0].set(1,0,0);
    e[1].set(0,1,0);
    e[2].set(0,0,1);
  }
  
  public mat3 add(float...b){mat3 a=getTarget();for(int i=0;i<9;i+=3){a.e[i/3].add(b[i+0],b[i+1],b[i+2]);}return a;}
  public mat3 sub(float...b){mat3 a=getTarget();for(int i=0;i<9;i+=3){a.e[i/3].sub(b[i+0],b[i+1],b[i+2]);}return a;}
  public mat3 mul(float...b){mat3 a=getTarget();for(int i=0;i<9;i+=3){a.e[i/3].mul(b[i+0],b[i+1],b[i+2]);}return a;}
  public mat3 div(float...b){mat3 a=getTarget();for(int i=0;i<9;i+=3){a.e[i/3].div(b[i+0],b[i+1],b[i+2]);}return a;}
  
  public mat3 add(vec3...b){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].add(b[i]);}return a;}
  public mat3 sub(vec3...b){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].sub(b[i]);}return a;}
  public mat3 mul(vec3...b){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].mul(b[i]);}return a;}
  public mat3 div(vec3...b){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].div(b[i]);}return a;}
  
  public mat3 add(mat3 b){return add(b.e[0],b.e[1],b.e[2]);}
  public mat3 sub(mat3 b){return sub(b.e[0],b.e[1],b.e[2]);}
  public mat3 mul(mat3 b){return mul(b.e[0],b.e[1],b.e[2]);}
  public mat3 div(mat3 b){return div(b.e[0],b.e[1],b.e[2]);}
  
  public mat3 mul(float s){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].mul(s);}return a;}
  public mat3 div(float s){mat3 a=getTarget();for(int i=0;i<3;i++){a.e[i].div(s);}return a;}
  
  public mat3 rotateX(float t) {
    mat3 a = getTarget();
    if(t!=0) {
      a.e[0].rotateX(t);
      a.e[1].applyTransform(a.e[0]);
      a.e[2].applyTransform(a.e[0]);
    }
    return a;
  }
  
  public mat3 rotateY(float t) {
    mat3 a = getTarget();
    if(t!=0) {
      a.e[0].rotateY(t);
      a.e[1].applyTransform(a.e[0]);
      a.e[2].applyTransform(a.e[0]);
    }
    return a;
  }
  
  public mat3 rotateZ(float t) {
    mat3 a = getTarget();
    if(t!=0) {
      a.e[0].rotateZ(t);
      a.e[1].applyTransform(a.e[0]);
      a.e[2].applyTransform(a.e[0]);
    }
    return a;
  }
  
  public mat3 transpose() {
    mat3 a = getTarget();
    a.set(
      e[0].e[0],e[1].e[0],e[2].e[0],
      e[0].e[1],e[1].e[1],e[2].e[1],
      e[0].e[2],e[1].e[2],e[2].e[2]);
    return a;
  }
  
  public PMatrix3D toPMatrix3D() {
    return new PMatrix3D(
      e[0].e[0],e[0].e[1],e[0].e[2],0,
      e[1].e[0],e[1].e[1],e[1].e[2],0,
      e[2].e[0],e[2].e[1],e[2].e[2],0,
      0,0,0,1
    );
  }
 
}
