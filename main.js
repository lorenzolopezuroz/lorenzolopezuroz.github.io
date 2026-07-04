import { loadTextFile, createProgram } from './utils/gl_utils.js';

const DEFAULT_VERTEX_SOURCE = `#version 300 es
    void main() {
        vec2 pos = vec2(
            (gl_VertexID == 2) ?  3.0 : -1.0,
            (gl_VertexID == 1) ?  3.0 : -1.0
        );
        gl_Position = vec4(pos, 0.0, 1.0);
    }
`

export async function initShader(canvasId, vertexUrl, fragmentUrl) {
    const canvas = document.getElementById(canvasId);
    const gl = canvas.getContext('webgl2');
    if (!gl) throw new Error("WebGL2 non supporté");

    const vertexSource = vertexUrl ? await loadTextFile(vertexUrl) : DEFAULT_VERTEX_SOURCE;
    const fragmentSource = await loadTextFile(fragmentUrl);

    const program = createProgram(gl, vertexSource, fragmentSource);
    gl.useProgram(program);

    const uResolution = gl.getUniformLocation(program, 'uResolution');
    const uMouse = gl.getUniformLocation(program, 'uMouse');
    const uTime = gl.getUniformLocation(program, 'uTime');

    const vao = gl.createVertexArray();
    gl.bindVertexArray(vao);

    function resize() {
        const dpr = window.devicePixelRatio || 1;
        canvas.width = canvas.clientWidth * dpr;
        canvas.height = canvas.clientHeight * dpr;
        gl.viewport(0, 0, canvas.width, canvas.height);
    }
    window.addEventListener('resize', resize);
    resize();

    let mouseX = 0;
    let mouseY = 0;
    canvas.addEventListener('mousemove', (event) => {
        const rect = canvas.getBoundingClientRect();
        const dpr = window.devicePixelRatio || 1;
        mouseX = (event.clientX - rect.left) * dpr;
        mouseY = (rect.height - (event.clientY - rect.top)) * dpr;
    });

    function render(timeMs) {
        gl.uniform2f(uResolution, canvas.width, canvas.height);
        gl.uniform2f(uMouse, mouseX, mouseY);
        gl.uniform1f(uTime, timeMs * 0.001);
        gl.drawArrays(gl.TRIANGLES, 0, 3);
        requestAnimationFrame(render);
    }
    requestAnimationFrame(render);
}