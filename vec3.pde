
class vec3 {
  
  private mat3 transform;
  
  private float[] e = new float[3];
  private boolean clone_mode = false;
  
  public static final int X = 0;
  public static final int Y = 1;
  public static final int Z = 2;
  
  public vec3 getTarget() {
    return clone_mode?new vec3(this):this;
  }
  
  public vec3(float x, float y, float z) {
    set(x,y,z);
  }
  
  public vec3(vec3 v) {
    set(v);
  }
  
  public vec3() {}
  
  public vec3 clone(boolean value) {
    clone_mode = value;
    return this;
  }
  
  public void set(float x, float y, float z) {
    e[0] = x;
    e[1] = y;
    e[2] = z;
  }
  
  public void set(vec3 b) {
    set(b.e[0],b.e[1],b.e[2]);
  }
  
  public vec3 add(float...b){vec3 a=getTarget();for(int i=0;i<3;i++){a.e[i]+=b[i];}return a;}
  public vec3 sub(float...b){vec3 a=getTarget();for(int i=0;i<3;i++){a.e[i]-=b[i];}return a;}
  public vec3 mul(float...b){vec3 a=getTarget();for(int i=0;i<3;i++){a.e[i]*=b[i];}return a;}
  public vec3 div(float...b){vec3 a=getTarget();for(int i=0;i<3;i++){a.e[i]/=b[i];}return a;}
  
  public vec3 add(vec3 b){return add(b.e[0],b.e[1],b.e[2]);}
  public vec3 sub(vec3 b){return sub(b.e[0],b.e[1],b.e[2]);}
  public vec3 mul(vec3 b){return mul(b.e[0],b.e[1],b.e[2]);}
  public vec3 div(vec3 b){return div(b.e[0],b.e[1],b.e[2]);}
  
  public vec3 mul(float s){return mul(s,s,s);}
  public vec3 div(float s){return div(s,s,s);}
  
  public void setTransform(
      float x0, float y0, float z0,
      float x1, float y1, float z1,
      float x2, float y2, float z2) {
    if(transform==null) {
      transform = new mat3(x0,y0,z0,x1,y1,z1,x2,y2,z2);
    }
    transform.set(x0,y0,z0,x1,y1,z1,x2,y2,z2);
  }
  
  public void applyTransform() {
    mul(transform);
  }
  
  public void applyTransform(vec3 v) {
    mul(v.transform);
  }
  
  public vec3 mul(mat3 m) {
    vec3 a = new vec3();
    for(int i=0;i<3;i++) {
    for(int j=0;j<3;j++) {
      a.e[i] += e[j]*m.e[i].e[j];
    }
    }
    if(!clone_mode) {
      set(a);
      a = this;
    }
    return a;
  }
  
  public vec3 rotateX(float t) {
    vec3 a = getTarget();
    if(t!=0) {
      float ca = cos(t);
      float sa = sin(t);
      setTransform(1,0,0,0,ca,sa,0,-sa,ca);
      applyTransform();
    }
    return a;
  }
  
  public vec3 rotateY(float t) {
    vec3 a = getTarget();
    if(t!=0) {
      float ca = cos(t);
      float sa = sin(t);
      setTransform(ca,0,-sa,0,1,0,sa,0,ca);
      applyTransform();
    }
    return a;
  }
  
  public vec3 rotateZ(float t) {
    vec3 a = getTarget();
    if(t!=0) {
      float ca = cos(t);
      float sa = sin(t);
      setTransform(ca,sa,0,-sa,ca,0,0,0,1);
      applyTransform();
    }
    return a;
  }
  
  public PVector toPVector() {
    return new PVector(e[0],e[1],e[2]);
  }
  
}
