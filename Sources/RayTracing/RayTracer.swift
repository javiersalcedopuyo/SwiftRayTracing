import Utils
import Math
import RenderableObjects

let SKY_COLOR_1    = Vec3(x: 0.0, y: 0.3, z: 1.0)
let MAX_DEPTH: Int = 50
let FAR            = 10.0
let SHADOW_BIAS    = 0.001

#if DEBUG
let MSAA_SAMPLES = 1
#else
let MSAA_SAMPLES = 64
#endif

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
            for y in 0..<self.imgSize.h
            {
                var color = Vec3.zero()
                for _ in 0..<MSAA_SAMPLES
                {
                    let offset = (MSAA_SAMPLES > 1) ? Double.random(in: 0.0...1.0)
                                                    : 0.0

                    let u     = (Double(x) + offset) / Double(self.imgSize.w-1)
                    let v     = (Double(y) + offset) / Double(self.imgSize.h-1)
                    var ray   = self.cam.getRay(u:u, v:v)

                    color += computeRay(&ray, minD: 0.0, maxD:10.0)
                }

                // Gamma2 correction
                color = (color * 1.0/Double(MSAA_SAMPLES)).squareRoot()

                // NOTE: The image's top row has the higher Y position in world space!
                img.set(col: x, row: self.imgSize.h-1-y, color: color)
            }
        }
        return img
    }

    func sampleSkybox(ray iRay: Ray) -> Vec3
    {
        let t = 0.5 * (iRay.direction.y + 1.0);
        return Vec3.lerp(from: Vec3.one(), to: SKY_COLOR_1, t:t)
    }

    func computeRay(_ iRay: inout Ray, minD iMinDist: Double, maxD iMaxDist: Double) -> Vec3
    {
        var ray: Ray? = iRay
        var depth  = MAX_DEPTH
        var result = Vec3.one()

        while depth > 0 && ray != nil
        {
            var closestHit: HitRecord? = nil
            var maxD = FAR

            for obj in world
            {
                let hit = obj.hit(ray: ray!, minD: SHADOW_BIAS, maxD: maxD)

                if hit == nil { continue }
                if closestHit == nil { closestHit = hit }

                if hit!.distance < closestHit!.distance { closestHit = hit }

                maxD = closestHit!.distance
            }

            if closestHit == nil { return result * sampleSkybox(ray: ray!) }

            var attenuation = Vec3.one()
            ray = closestHit!.material
                             .scatter(ray: ray!,
                                     hit: closestHit!,
                                     attenuation: &attenuation)

            if ray == nil { return result * sampleSkybox(ray: ray!) }

            result *= attenuation
            depth  -= 1
        }

        return Vec3.zero()
    }
}