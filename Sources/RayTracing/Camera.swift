import Math

class Camera
{
    public private(set) var position:          Vec3
    public private(set) var lower_left_corner: Vec3 // World space

    public let up:      Vec3
    public let right:   Vec3
    public let forward: Vec3

    let width:     UInt
    let height:    UInt
    let focal_len: Double

    public init(w: UInt, h: UInt)
    {
        self.width     = w
        self.height    = h
        self.focal_len = 1.0

        self.position          = Vec3.zero()
        self.lower_left_corner = Vec3.zero()

        self.up      = Vec3(x:0.0, y:1.0, z:0.0)
        self.right   = Vec3(x:1.0, y:0.0, z:0.0)
        self.forward = Vec3(x:0.0, y:1.0, z:-1.0)

        self.update_lower_left_corner()
    }

    public func move_to(_ inNewPos: Vec3)
    {
        self.position = inNewPos;
        self.update_lower_left_corner()
    }

    public func get_ray(u: Double, v: Double) -> Ray
    {
        let hrz = self.right * Double(self.width)
        let vrt = self.up * Double(self.height)

        let pixel_pos = self.lower_left_corner + hrz*u + vrt*v

        return Ray(origin: self.position, direction: pixel_pos - self.position)
    }

    func update_lower_left_corner()
    {
        let hrz = self.right * Double(self.width)
        let vrt = self.up * Double(self.height)
        let dpt = self.forward * Double(self.focal_len)
        self.lower_left_corner = self.position - hrz*0.5 - vrt*0.5 + dpt
    }
}