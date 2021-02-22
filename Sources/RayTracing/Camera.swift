import Math

typealias Dimensions = (w: Double, h: Double)

let WORLD_UP = Vec3(x:0.0, y:1.0, z:0.0)

public class Camera
{
    public private(set) var position:          Vec3
    public private(set) var up:                Vec3
    public private(set) var right:             Vec3
    public private(set) var forward:           Vec3

    var lowerLeftCorner: Vec3 // World space
    var focusDistance:   Double

    let viewport:        Dimensions
    let focalLen:        Double
    let lensRadius:      Double

    public init(w: UInt, h: UInt, aperture: Double)
    {
        let aspectRatio = Double(w) / Double(h)

        self.viewport.h = 2.0
        self.viewport.w = 2.0 * aspectRatio
        self.focalLen   = 1.0

        self.position        = Vec3.zero()
        self.lowerLeftCorner = Vec3.zero()

        self.up      = Vec3(x:0.0, y:1.0, z:0.0)
        self.right   = Vec3(x:-1.0, y:0.0, z:0.0)
        self.forward = Vec3(x:0.0, y:0.0, z:1.0)

        self.lensRadius    = aperture * 0.5
        self.focusDistance = 1.0

        self.updateLowerLeftCorner()
    }

    public func moveTo(_ inNewPos: Vec3)
    {
        self.position = inNewPos;
        self.updateLowerLeftCorner()
    }

    public func lookAt(_ iTarget: Vec3)
    {
        let lookDir        = (iTarget - self.position).normalized()

        self.forward       = lookDir
        self.right         = lookDir.cross(WORLD_UP).normalized()
        self.up            = self.right.cross(lookDir)
        self.focusDistance = (iTarget - self.position).norm()

        self.updateLowerLeftCorner()
    }

    public func getRay(u: Double, v: Double) -> Ray
    {
        let hrz       = self.right * self.viewport.w * self.focusDistance
        let vrt       = self.up    * self.viewport.h * self.focusDistance

        let pixel_pos = self.lowerLeftCorner + hrz*u + vrt*v

        let randDir   = randomPointInUnitDisk() * self.lensRadius
        let offset    = self.right * randDir.x + self.up * randDir.y
        let origin    = self.position + offset

        return Ray(origin: origin, direction: pixel_pos - origin)
    }

    func updateLowerLeftCorner()
    {
        let hrz = self.right   * self.viewport.w * self.focusDistance
        let vrt = self.up      * self.viewport.h * self.focusDistance
        let dpt = self.forward * self.focalLen   * self.focusDistance

        self.lowerLeftCorner = self.position - hrz*0.5 - vrt*0.5 + dpt
    }
}