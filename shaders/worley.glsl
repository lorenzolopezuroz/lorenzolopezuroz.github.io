#version 300 es
precision highp float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

const float l = 8.0;

vec3 random3(vec3 st) {
    vec3 p = vec3(
        dot(st, vec3(127.1, 311.7, 74.7)),
        dot(st, vec3(269.5, 183.3, 246.1)),
        dot(st, vec3(113.5, 271.9, 124.6))
    );
    return fract(sin(p) * 43758.5453123);
}

vec3 seed(ivec3 cell) {
	return vec3(cell) + random3(vec3(cell));
}

float worley(vec3 x) {
	ivec3 x_cell = ivec3(floor(x));
	float d = sqrt(3.0);
	
	for (int i = 0; i < 27; i++) {
		ivec3 offset = ivec3(i % 3, (i / 3) % 3, i / 9) - 1;
		vec3 y = seed(x_cell + offset);
		d = min(d, distance(x, y) / l);
	}
	return d * l;
}

void main() {
    vec2 uv = gl_FragCoord.xy / uResolution * l;
    vec3 p = vec3(uv.x, uv.y, uTime);
    vec3 color = vec3(worley(p));
    fragColor = vec4(color, 1.0);
}