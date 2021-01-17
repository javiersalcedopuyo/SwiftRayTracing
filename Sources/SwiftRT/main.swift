import Math
import Utils
import RayTracing

let rt = RayTracer()
let image = rt.render()
image.writeToFile(at: "Out/result.ppm")
print("Everything went OK :D")