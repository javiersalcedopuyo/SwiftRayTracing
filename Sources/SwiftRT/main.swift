import Foundation

import Math
import Utils
import RayTracing
import RenderableObjects

let rt = RayTracer(w:800, h:600)

let metallicMat = Metallic(albedo: Vec3.random(min: 0.0, max: 1.0),
                           roughness: Double.random(in: 0...1))

rt.addObject( Sphere(pos: Vec3(x:0.0, y:0.0, z:1.0), rad: 0.5, mat: metallicMat) )
rt.addObject( Sphere(pos: Vec3(x:0.0, y:-100.5, z:1.0), rad: 100.0) )

let start = Date()
print("Render started!")
let image = rt.render()
print("Rendered finished in", start.timeIntervalSinceNow * -1000.0, "ms")

image.writeToFile(at: "Out/result.ppm")