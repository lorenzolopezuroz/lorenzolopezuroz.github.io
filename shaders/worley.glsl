#version 300 es
precision highp float;

uniform vec2 uResolution;
uniform vec2 uMouse;
uniform float uTime;

out vec4 fragColor;

const float l = 8.0;


vec2 random2(vec2 st) {
    vec2 p = vec2(
        dot(st, vec2(127.1, 311.7)),
        dot(st, vec2(113.5, 271.9))
    );
    return fract(sin(p) * 43758.5453123);
}

vec2 seed_x(ivec2 cell) {
	return vec2(cell) + random2(vec2(cell));
}

float worley(vec2 x, vec2 well) {
	ivec2 x_cell = ivec2(floor(x));
	float d = sqrt(2.0);
	
	for (int i = 0; i < 9; i++) {
		ivec2 offset = ivec2(i % 3, i / 3) - 1;
		vec2 y = seed_x(x_cell + offset);
		d = min(d, distance(x, y) / l);
	}
	return d * l;
}

void main() {
    vec2 mouseUv = (uMouse / uResolution - 0.5) * uResolution / 1000.0 * l;
    vec2 p = (gl_FragCoord.xy / uResolution - 0.5) * uResolution / 1000.0 * l;
    
    float color = worley(p + mouseUv / 64.0, mouseUv);
    fragColor = vec4(vec3(color), 1.0);
}