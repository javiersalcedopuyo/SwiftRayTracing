public struct Ray
{
    public let origin:    Vec3
    public let direction: Vec3

    public init()
    {
        self.origin    = Vec3.zero()
        self.direction = Vec3(x:0.0, y:0.0, z:1.0)
    }

    public init(origin: Vec3, direction: Vec3)
    {
        self.origin    = origin
        self.direction = direction.normalized()
    }

    public func at(_ t: Double) -> Vec3
    {
        return self.origin + self.direction * t
    }
}