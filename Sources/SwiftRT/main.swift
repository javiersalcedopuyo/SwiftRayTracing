import Foundation

import Math
import Utils
import RayTracing
import RenderableObjects

let rt = RayTracer(w:800, h:600)

//rt.cam.moveTo( Vec3(x:-1.5, y:0.5, z:0.25) )
//rt.cam.lookAt( Vec3(x:0.0, y:0.0, z:1.5) )
//rt.setWorld( SceneGenerator.rgb() )

rt.cam.moveTo( Vec3(x:5, y:1.5, z:2.5))
rt.cam.lookAt( Vec3.zero() )
rt.cam.updateFocusDistance(new: 10.0)
print("Camera set")

rt.setWorld( SceneGenerator.rand() )
print("World created")

let start = Date()
print("Render started!")
let image = rt.render()
print("Rendered finished in", start.timeIntervalSinceNow * -1, "s")

image.writeToFile(at: "Out/result.ppm")