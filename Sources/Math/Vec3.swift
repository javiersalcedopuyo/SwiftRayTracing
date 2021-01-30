public struct Vec3 : Equatable
{
    public var x: Double
    public var y: Double
    public var z: Double

    public init(x: Double, y: Double, z: Double)
    {
        self.x = x
        self.y = y
        self.z = z
    }
    // Initializers
    public static func zero() -> Vec3 { Vec3(x: 0.0, y: 0.0, z: 0.0) }
    public static func one()  -> Vec3 { Vec3(x: 1.0, y: 1.0, z: 1.0) }

    // Operators
    public subscript(index: UInt) -> Double
    {
        get
        {
            assert(index < 3, "ERROR: Tried to access Vec3 out of bounds")
            switch index
            {
                case 0:  return self.x
                case 1:  return self.y
                case 2:  return self.z
                default: return self.x
            }
        }
        set(newVal)
        {
            assert(index < 3, "ERROR: Tried to access Vec3 out of bounds")
            switch index
            {
                case 0:  self.x = newVal
                case 1:  self.y = newVal
                case 2:  self.z = newVal
                default: self.x = newVal
            }

        }
    }

    public static func ==(left: Vec3, right: Vec3) -> Bool
    {
        left.x == right.x &&
        left.y == right.y &&
        left.z == right.z
    }

    public static prefix func -(right: Vec3) -> Self
    {
        Vec3(x: -right.x,
             y: -right.y,
             z: -right.z)
    }

    public static func +(left: Vec3, right: Vec3) -> Self
    {
        Vec3(x: left.x + right.x,
             y: left.y + right.y,
             z: left.z + right.z)
    }

    public static func -(left: Vec3, right: Vec3) -> Self
    {
        Vec3(x: left.x - right.x,
             y: left.y - right.y,
             z: left.z - right.z)
    }

    public static func /(left: Self, right: Double) -> Self
    {
        Vec3(x: left.x / right,
             y: left.y / right,
             z: left.z / right)
    }

    public static func *(left: Self, right: Double) -> Self
    {
        Vec3(x: left.x * right,
             y: left.y * right,
             z: left.z * right)
    }

    public func dot(_ v: Vec3) -> Double
    {
        self.x * v.x + self.y * v.y + self.z * v.z
    }

    public func cross(_ v: Vec3) -> Vec3
    {
        Vec3(x: self.y * v.z - self.z * v.y,
             y: self.z * v.x - self.x * v.z,
             z: self.x * v.y - self.y * v.x)
    }

    public func norm2() -> Double { self.dot(self) }
    public func norm()  -> Double { self.norm2().squareRoot() }

    public func normalized() -> Vec3
    {
        let n = self.norm()
        return n != 0 ? self / n
                      : Vec3.zero()
    }

    // Methods
    public static func lerp(from a: Vec3, to b: Vec3, t: Double) -> Vec3
    {
        if      t >= 1.0 { return b }
        else if t <= 0.0 { return a }
        else             { return a * (1.0-t) + b * t }
    }
}
