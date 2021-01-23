import Utils
import Math

let SKY_COLOR_1 = Vec3(x: 0.0, y: 0.3, z: 1.0)

public class RayTracer
{
    let cam: Camera

    public init(w: UInt, h:UInt)
    {
        self.cam = Camera(w:w, h:h)
    }

    public func render() -> ImagePPM
    {
        let img = ImagePPM(width: self.cam.width, height: self.cam.height)

        for x in 0..<img.width
        {
            let u   = Double(x) / Double(img.width-1)
            for y in 0..<img.height
            {
                let v   = Double(img.height-y) / Double(img.height-1)
                let ray = self.cam.get_ray(u:u, v:v)

                img.set(col: x, row: y, color: send_ray(ray))
            }
        }
        return img
    }

    func sample_skybox(ray iRay: Ray) -> Vec3
    {
        let t = 0.5 * (iRay.direction[1] + 1.0);
        return Vec3.lerp(Vec3.one()*0.75, SKY_COLOR_1, t:t)
    }

    func send_ray(_ iRay: Ray) -> Vec3
    {
        return sample_skybox(ray: iRay)
    }
}