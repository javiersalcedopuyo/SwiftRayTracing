import Utils
import Math

let SKY_COLOR_1 = Vec3(x: 0.0, y: 0.3, z: 1.0)

public class RayTracer
{
    public init() {}

    public func render() -> ImagePPM
    {
        ImagePPM(width: 800, height: 600, color: SKY_COLOR_1)
    }
}