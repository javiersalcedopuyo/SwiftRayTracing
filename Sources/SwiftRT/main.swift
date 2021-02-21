import Foundation

import Math
import Utils
import RayTracing
import RenderableObjects

let rt = RayTracer(w:800, h:600)

rt.cam.moveTo( Vec3(x:-1.5, y:0.5, z:0.25) )
rt.cam.lookAt( Vec3(x:0.0, y:0.0, z:1.5) )

let groundMat   = Lambertian(albedo: GREY)
let diffuseMat  = Lambertian(albedo: RED)
let glassMat    = Dielectric(albedo: GREEN, refractionIdx: 1.5)
let metallicMat = Metallic  (albedo: BLUE,  roughness:     0.5)

rt.addObject( Sphere(pos: Vec3(x:1.0,  y:0.0, z:1.5), rad: 0.5, mat: diffuseMat) )
rt.addObject( Sphere(pos: Vec3(x:0.0,  y:0.0, z:1.5), rad: 0.5, mat: glassMat) )
rt.addObject( Sphere(pos: Vec3(x:-1.0, y:0.0, z:1.5), rad: 0.5, mat: metallicMat) )
// "Floor"
rt.addObject( Sphere(pos: Vec3(x:0.0, y:-100.5, z:2.0), rad: 100.0, mat: groundMat) )

let start = Date()
print("Render started!")
let image = rt.render()
print("Rendered finished in", start.timeIntervalSinceNow * -1000.0, "ms")

image.writeToFile(at: "Out/result.ppm")