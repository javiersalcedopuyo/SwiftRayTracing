import Math

typealias Dimensions = (w: Double, h: Double)

let WORLD_UP = Vec3(x:0.0, y:1.0, z:0.0)

public class Camera
{
    public private(set) var position:          Vec3
    public private(set) var up:                Vec3
    public private(set) var right:             Vec3
    public private(set) var forward:           Vec3

    var lower_left_corner: Vec3 // World space
    let viewport:          Dimensions
    let focalLen:          Double

    public init(w: UInt, h: UInt)
    {
        let aspectRatio = Double(w) / Double(h)

        self.viewport.h = 2.0
        self.viewport.w = 2.0 * aspectRatio
        self.focalLen   = 1.0

        self.position          = Vec3.zero()
        self.lower_left_corner = Vec3.zero()

        self.up      = Vec3(x:0.0, y:1.0, z:0.0)
        self.right   = Vec3(x:-1.0, y:0.0, z:0.0)
        self.forward = Vec3(x:0.0, y:0.0, z:1.0)

        self.updateLowerLeftCorner()
    }

    public func moveTo(_ inNewPos: Vec3)
    {
        self.position = inNewPos;
        self.updateLowerLeftCorner()
    }

    public func lookAt(_ iTarget: Vec3)
    {
        let lookDir  = (iTarget - self.position).normalized()

        self.forward = lookDir
        self.right   = lookDir.cross(WORLD_UP).normalized()
        self.up      = self.right.cross(lookDir)

        self.updateLowerLeftCorner()
    }

    public func getRay(u: Double, v: Double) -> Ray
    {
        let hrz = self.right * self.viewport.w
        let vrt = self.up    * self.viewport.h

        let pixel_pos = self.lower_left_corner + hrz*u + vrt*v

        return Ray(origin: self.position, direction: pixel_pos - self.position)
    }

    func updateLowerLeftCorner()
    {
        let hrz = self.right  * self.viewport.w
        let vrt = self.up      * self.viewport.h
        let dpt = self.forward * self.focalLen

        self.lower_left_corner = self.position - hrz*0.5 - vrt*0.5 + dpt
    }
}