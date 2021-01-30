import Foundation

import Math
import Utils
import RayTracing
import Geometry

let rt = RayTracer(w:800, h:600)

let start = Date()
print("Render started!")
let image = rt.render()
print("Rendered finished in", start.timeIntervalSinceNow * -1000.0, "ms")

image.writeToFile(at: "Out/result.ppm")