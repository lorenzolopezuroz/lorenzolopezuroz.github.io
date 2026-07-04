#version 300 es
precision highp float;

uniform vec2 uResolution;
uniform float uTime;

out vec4 fragColor;

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution;
  vec3 color = 0.5 + 0.5 * cos(uTime + uv.xyx * 6.0 + vec3(0.0, 2.0, 4.0));
  fragColor = vec4(color, 1.0);
}