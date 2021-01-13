public struct Vec3 : Equatable
{
    var x: Double
    var y: Double
    var z: Double

    // Initializers
    static func zero() -> Vec3 { Vec3(x: 0.0, y: 0.0, z: 0.0) }
    static func one()  -> Vec3 { Vec3(x: 1.0, y: 1.0, z: 1.0) }

    // Operators
    public static func ==(left: Vec3, right: Vec3) -> Bool
    {
        left.x == right.x &&
        left.y == right.y &&
        left.z == right.z
    }

    static prefix func -(right: Vec3) -> Vec3
    {
        Vec3(x: -right.x,
             y: -right.y,
             z: -right.z)
    }

    static func /(left: Vec3, right: Double) -> Vec3
    {
        Vec3(x: left.x / right,
             y: left.y / right,
             z: left.z / right)
    }

    func dot(_ v: Vec3) -> Double
    {
        self.x * v.x + self.y * v.y + self.z * v.z
    }

    func cross(_ v: Vec3) -> Vec3
    {
        Vec3(x: self.y * v.z - self.z * v.y,
             y: self.z * v.x - self.x * v.z,
             z: self.x * v.y - self.y * v.x)
    }

    func norm2()      -> Double { self.dot(self) }
    func norm()       -> Double { self.norm2().squareRoot() }
    func normalized() -> Vec3   { self / self.norm() }
}
