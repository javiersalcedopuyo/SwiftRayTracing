import Math
import Utils
import RayTracing

let rt = RayTracer(w:800, h:600)
let image = rt.render()
image.writeToFile(at: "Out/result.ppm")
print("Everything went OK :D")