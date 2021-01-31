import Utils
import Math
import Geometry

let SKY_COLOR_1 = Vec3(x: 0.0, y: 0.3, z: 1.0)

typealias ImageSize = (w: UInt, h: UInt)

public class RayTracer
{
    public let cam: Camera

    let imgSize: ImageSize
    var world: Array<Intersectionable>

    public init(w: UInt, h:UInt)
    {
        self.imgSize.w = w
        self.imgSize.h = h
        self.cam       = Camera(w:w, h:h)
        self.world     = Array<Intersectionable>()
    }

    public func addObject(_ input: Intersectionable)
    {
        self.world.append(input)
    }

    public func render() -> ImagePPM
    {
        let img = ImagePPM(width: self.imgSize.w, height: self.imgSize.h)

        for x in 0..<self.imgSize.w
        {
            let u   = Double(x) / Double(self.imgSize.w-1)
            for y in 0..<self.imgSize.h
            {
                let v     = Double(y) / Double(self.imgSize.h-1)
                var ray   = self.cam.get_ray(u:u, v:v)
                let color = send_ray(&ray, minD: 0.0, maxD:10.0)

                // NOTE: The image's top row has the higher Y position in world space!
                img.set(col: x, row: self.imgSize.h-1-y, color: color)
            }
        }
        return img
    }

    func sample_skybox(ray iRay: Ray) -> Vec3
    {
        let t = 0.5 * (iRay.direction.y + 1.0);
        return Vec3.lerp(from: Vec3.one(), to: SKY_COLOR_1, t:t)
    }

    func send_ray(_ iRay: inout Ray, minD iMinDist: Double, maxD iMaxDist: Double) -> Vec3
    {
        var hit: HitRecord?
        var closestSoFar = iMaxDist

        for obj in self.world
        {
            if let h = obj.hit(ray: &iRay, minD: iMinDist, maxD: closestSoFar)
            {
                hit = h
                closestSoFar = hit!.distance
            }
        }

        if hit == nil
        {
            return sample_skybox(ray: iRay)
        }

        let r = hit!.normal.x + 1.0
        let g = hit!.normal.y + 1.0
        let b = hit!.normal.z + 1.0

        return Vec3(x:r, y:g, z:b) * 0.5
    }
}