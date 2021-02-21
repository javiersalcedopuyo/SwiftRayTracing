import Foundation // For trigonometric functions

public let RED   = Vec3(x:1.0, y:0.0, z:0.0)
public let GREEN = Vec3(x:0.0, y:1.0, z:0.0)
public let BLUE  = Vec3(x:0.0, y:0.0, z:1.0)
public let WHITE = Vec3(x:1.0, y:1.0, z:1.0)
public let GREY  = Vec3(x:0.5, y:0.5, z:0.5)
public let BLACK = Vec3(x:0.0, y:0.0, z:0.0)

public struct Vec3 : Equatable
{
    public var x: Double
    public var y: Double
    public var z: Double

    let EPSILON = 1e-8

    // Initializers
    public init(x: Double, y: Double, z: Double)
    {
        self.x = x
        self.y = y
        self.z = z
    }

    public static func random(min: Double, max: Double) -> Vec3
    {
        Vec3(x: Double.random(in: min...max),
             y: Double.random(in: min...max),
             z: Double.random(in: min...max))
    }

    public static func randomUnit() -> Vec3
    {
        let a = Double.random(in: 0.0...1.0) * TAU
        let z = -1.0 + Double.random(in: 0.0...1.0) * 2.0
        let r = (1.0 - z*z).squareRoot()

        return Vec3(x: r*cos(a), y: r*sin(a), z:z);
    }

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

    public static func *(left: Self, right: Self) -> Self
    {
        Vec3(x: left.x * right.x,
             y: left.y * right.y,
             z: left.z * right.z)
    }

    public static func *=(left: inout Self, right: Double)
    {
        left.x *= right
        left.y *= right
        left.z *= right
    }

    public static func *=(left: inout Self, right: Self)
    {
        left.x *= right.x
        left.y *= right.y
        left.z *= right.z
    }

    public static func +=(left: inout Self, right: Self)
    {
        left.x += right.x
        left.y += right.y
        left.z += right.z
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

    public static func normalToColor(_ n: Vec3) -> Vec3
    {
        // We assume the normal is already a unit vector
        let r = n.x + 1.0
        let g = n.y + 1.0
        let b = n.z + 1.0

        return Vec3(x:r, y:g, z:b) * 0.5
    }

    mutating public func clamp(min minVal: Double, max maxVal: Double)
    {
        self.x = min( max(self.x, minVal), maxVal )
        self.y = min( max(self.y, minVal), maxVal )
        self.z = min( max(self.z, minVal), maxVal )
    }

    public func squareRoot() -> Self
    {
        let x = self.x.squareRoot()
        let y = self.y.squareRoot()
        let z = self.z.squareRoot()

        return Vec3(x:x, y:y, z:z)
    }

    public func isNearZero() -> Bool
    {
        return abs(self.x) < EPSILON || abs(self.y) < EPSILON || abs(self.z) < EPSILON
    }

    public func reflect(normal: Vec3) -> Vec3
    {
        return self - normal * self.dot(normal) * 2;
    }

    // n: Surface normal
    // eta: Refraction index of the first medium over the second's (ni/nr)
    public func refract(normal: Vec3, eta: Double) -> Vec3
    {
        let cosTheta    = -self.dot(normal)
        let rOrthogonal = (self + normal * cosTheta) * eta
        let rParallel   = normal * -abs(1.0 - rOrthogonal.norm2()).squareRoot()

        return rOrthogonal + rParallel
    }
}
