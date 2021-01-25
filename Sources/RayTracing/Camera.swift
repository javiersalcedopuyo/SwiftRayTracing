import Math

typealias Dimensions = (w: Double, h: Double)

class Camera
{
    public private(set) var position:          Vec3
    public private(set) var lower_left_corner: Vec3 // World space

    public let up:      Vec3
    public let right:   Vec3
    public let forward: Vec3

    let viewport: Dimensions
    let focalLen: Double

    public init(w: UInt, h: UInt)
    {
        let aspectRatio = Double(w) / Double(h)

        self.viewport.h = 2.0
        self.viewport.w = 2.0 * aspectRatio
        self.focalLen   = 1.0

        self.position          = Vec3.zero()
        self.lower_left_corner = Vec3.zero()

        self.up      = Vec3(x:0.0, y:1.0, z:0.0)
        self.right   = Vec3(x:1.0, y:0.0, z:0.0)
        self.forward = Vec3(x:0.0, y:0.0, z:-1.0)

        self.update_lower_left_corner()
    }

    public func move_to(_ inNewPos: Vec3)
    {
        self.position = inNewPos;
        self.update_lower_left_corner()
    }

    public func get_ray(u: Double, v: Double) -> Ray
    {
        let hrz = self.right * self.viewport.w
        let vrt = self.up    * self.viewport.h

        let pixel_pos = self.lower_left_corner + hrz*u + vrt*v

        return Ray(origin: self.position, direction: pixel_pos - self.position)
    }

    func update_lower_left_corner()
    {
        let hrz = self.right    * self.viewport.w
        let vrt = self.up       * self.viewport.h
        let dpt = -self.forward * self.focalLen

        self.lower_left_corner = self.position - hrz*0.5 - vrt*0.5 + dpt
    }
}