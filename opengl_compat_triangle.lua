local ffi = require("ffi")
ffi.cdef([[
typedef struct GLFWwindow GLFWwindow;
typedef struct GLFWmonitor GLFWmonitor;

int glfwInit();
void glfwTerminate();
typedef void (* GLFWerrorfun)(int error_code, const char* description);
GLFWerrorfun glfwSetErrorCallback(GLFWerrorfun callback);
GLFWwindow* glfwCreateWindow(int width, int height, const char* title, GLFWmonitor* monitor, GLFWwindow* share);
void glfwPollEvents();
int glfwWindowShouldClose(GLFWwindow* window);
void glfwMakeContextCurrent(GLFWwindow* window);
void glfwSwapBuffers(GLFWwindow* window);
void glClear(unsigned int mask);
void glClearColor(float r, float g, float b, float a);
void glfwWindowHint(int hint, int value);
void glBegin(unsigned int primitive);
void glEnd();
void glVertex2f(float x, float y);
void glColor3f(float r, float g, float b);
]])
local metatable = {}
function metatable:__index(index)
	return rawget(self, 2)[rawget(self, 1)..index]
end

local glfw = setmetatable({"glfw", ffi.load("glfw")}, metatable)
local gl = setmetatable({"gl", ffi.load("GL")}, metatable)

local function errorCallback(errorCode, description)
	error(string.format("Error(%i): %s", errorCode, ffi.string(description)), 2)
end

local enum = {
	GL_COLOR_BUFFER_BIT = 0x00004000,
	GLFW_CONTEXT_VERSION_MAJOR = 0x00022002,
	GLFW_CONTEXT_VERSION_MINOR = 0x00022003,
	GLFW_TRANSPARENT_FRAMEBUFFER = 0x0002000A,
	GL_TRIANGLES = 0x0004,
	GLFW_SRGB_CAPABLE = 0x0002100E,
	GLFW_SAMPLES = 0x0002100D,
}

glfw.SetErrorCallback(errorCallback)
glfw.Init()


glfw.WindowHint(enum.GLFW_CONTEXT_VERSION_MAJOR, 3)
glfw.WindowHint(enum.GLFW_CONTEXT_VERSION_MINOR, 0)
glfw.WindowHint(enum.GLFW_TRANSPARENT_FRAMEBUFFER, 1)
glfw.WindowHint(enum.GLFW_SRGB_CAPABLE, 1)
glfw.WindowHint(enum.GLFW_SAMPLES, 8)

local window = glfw.CreateWindow(720, 480, "CODOTAKU", nil, nil)
glfw.MakeContextCurrent(window)


while glfw.WindowShouldClose(window) == 0 do
	gl.ClearColor(0, 0, 0, 0)
	gl.Clear(enum.GL_COLOR_BUFFER_BIT)

	gl.Begin(enum.GL_TRIANGLES)
	gl.Color3f(1, 0, 0)
	gl.Vertex2f(0, 0)
	gl.Color3f(0, 1, 0)
	gl.Vertex2f(1, 0)
	gl.Color3f(0, 0, 1)
	gl.Vertex2f(0, 1)
	gl.End()

	glfw.SwapBuffers(window)
	glfw.PollEvents()
end

glfw.Terminate()
