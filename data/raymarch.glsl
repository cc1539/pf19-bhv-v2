uniform vec3 position;
uniform mat4 rotation;

uniform vec2 canvasSize;

uniform float sphereRadius;
uniform vec3 sphereOrigin;

uniform float ringInnerRadius;
uniform float ringOuterRadius;

uniform float blackHoleGravity;
uniform float blackHoleSpin;

uniform float time;
uniform int iterations;

uniform sampler2D skymap;

const float PI = 3.1415926535897932384626433832795;

void main() {
	
	float scale = min(canvasSize.x,canvasSize.y);
	
	vec2 uv = (gl_FragCoord.xy*2.0-canvasSize)/scale;
	
	vec3 ref = vec3(0.0);
	
	vec3 ray = position
		+rotation[0].xyz*uv.x
		+rotation[1].xyz*uv.y;
	vec3 dir = rotation[2].xyz
		+rotation[0].xyz*uv.x*0.5
		+rotation[1].xyz*uv.y*0.5;
	
	dir = normalize(dir);
	
	float total_dst = 0.0;
	bool hit = false;
	vec3 color = vec3(0.0);
	
	for(int i=0;i<iterations;i++) {
		
		float dst2 = dot(ray,ray);
		
		float dst = sqrt(dst2); // distance from black hole, which is at the origin
		float gravity = blackHoleGravity/dst2;
		
		if(gravity>1.0) {
			hit = true;
			color = vec3(0.0);
			break;
		}
		
		dir = normalize(dir-normalize(ray+vec3(ray.z,0,-ray.x)*blackHoleSpin)*gravity);
		dst *= 0.5;
		
		
		if(dst>1024.0) {
			break;
		}
		
		vec3 ref = dir*dst;
		
		// determine if this new movement ray hits the sphere at (0,0,5);
		vec3 offset = ray-sphereOrigin;
		float a = dot(ref,ref);
		float b = 2*dot(offset,ref);
		float c = dot(offset,offset)-sphereRadius*sphereRadius;
		float det = b*b-4.0*a*c;
		if(det>0) {
			float t = (-b-sqrt(det))/(2.0*a);
			if(t>=0 && t<1) {
				hit = true;
				ray += ref*t;
				color = normalize(ray-sphereOrigin)/2.0+vec3(0.5);
				break;
			}
		}
		
		/*
		// determine if this new movement ray hits the disk
		if((ray.y<0.0)!=(ray.y+ref.y<0.0)) {
			float t = -ray.y/ref.y;
			if(t>=0 && t<1) {
				vec3 pos = ray+ref*t;
				float ring_dst = sqrt(dot(pos.xz,pos.xz));
				if(ring_dst>ringInnerRadius && ring_dst<ringOuterRadius) {
					hit = true;
					ray = pos;
					float angle = atan(pos.z/pos.x);
					float coord = angle/(2.0*PI)+0.5;
					float brightness = sin(coord*PI*200.0/ring_dst+time*0.5);
					color = vec3(1.0,0.5,0.0)*brightness;
					break;
				}
			}
		}
		*/
		
		ray += ref;
		total_dst += dst;
	}
	
	if(hit) {
		gl_FragColor = vec4(color,1.0);
	} else {
		float theta = atan(dir.y/dir.x);
		float phi = acos(dir.z);
		vec2 coord = vec2(theta/(2.0*PI)+0.5,phi/PI);
		gl_FragColor = texture(skymap,coord);
	}
	
}
