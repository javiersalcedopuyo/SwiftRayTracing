import RenderableObjects
import Math

public struct SceneGenerator
{
    // 3 balls (diffuse red, glass green and metallic blue) + grey ground
    public static func rgb() -> Array<Intersectionable>
    {
        let groundMat   = Lambertian(albedo: GREY)
        let diffuseMat  = Lambertian(albedo: RED)
        let glassMat    = Dielectric(albedo: GREEN, refractionIdx: 1.5)
        let metallicMat = Metallic  (albedo: BLUE,  roughness:     0.5)

        var w = Array<Intersectionable>()
        w.reserveCapacity(4)

        w.append( Sphere(pos: Vec3(x:1.0,  y:0.0, z:1.5), rad: 0.5, mat: diffuseMat) )
        w.append( Sphere(pos: Vec3(x:0.0,  y:0.0, z:1.5), rad: 0.5, mat: glassMat) )
        w.append( Sphere(pos: Vec3(x:-1.0, y:0.0, z:1.5), rad: 0.5, mat: metallicMat) )
        // "Floor"
        w.append( Sphere(pos: Vec3(x:0.0, y:-100.5, z:2.0), rad: 100.0, mat: groundMat) )

        return w
    }

    // 3 big spheres (1 glass, 1 metallic and 1 diffuse)
    // 240 random smaller ones
    // grey ground
    public static func rand() -> Array<Intersectionable>
    {
        let groundMat = Lambertian(albedo: GREY)
        let materialA = Dielectric(albedo: WHITE, refractionIdx: 1.5)
        let materialB = Lambertian(albedo: Vec3(x:0.4, y:0.2, z:0.1))
        let materialC = Metallic(albedo: Vec3(x:0.7, y:0.6, z:0.5), roughness: 0.0)

        var w = Array<Intersectionable>()
        w.reserveCapacity(256) // Round up to the next power of 2

        w.append( Sphere(pos: Vec3(x:0, y:-1000, z:0), rad:1000, mat: groundMat) )

        for i in -8...8 {
            for ii in -8..<8
            {
                let center = Vec3(x: Double(i)  + 0.9 * Double.random(in: 0...1),
                                  y: 0.2,
                                  z: Double(ii) + 0.9 * Double.random(in: 0...1))

                if (center - Vec3(x:4.0, y:0.2, z:0.0)).norm() <= 0.9 { continue }

                let albedo: Vec3
                let newMat: Material

                let dice = Double.random(in: 0...1)

                if dice < 0.8 // Diffuse
                {
                    albedo = Vec3.random(min: 0.0, max: 1.0)
                    newMat = Lambertian(albedo: albedo)
                }
                else if dice < 0.95 // Metal
                {
                    let r  = Double.random(in: 0...0.5)
                    albedo = Vec3.random(min: 0.5, max: 1.0)
                    newMat = Metallic(albedo: albedo, roughness: r)
                }
                else // Glass
                {
                    albedo = WHITE
                    newMat = Dielectric(albedo: albedo, refractionIdx: 1.5)
                }
                w.append( Sphere(pos: center, rad: 0.2, mat: newMat) )
            }
        }

        w.append( Sphere(pos: Vec3(x:0, y:1, z:0), rad: 1.0, mat: materialA) )
        w.append( Sphere(pos: Vec3(x:-3, y:1, z:0), rad: 1.0, mat: materialB) )
        w.append( Sphere(pos: Vec3(x:3, y:1, z:0), rad: 1.0, mat: materialC) )

        return w
    }
}