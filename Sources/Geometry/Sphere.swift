import Math

public class Sphere : Intersectionable
{
    public var position: Vec3
    var radius:   Double

    public init()
    {
        self.position = Vec3.zero()
        self.radius   = 1.0
    }

    public init(pos: Vec3, rad: Double)
    {
        self.position = pos
        self.radius   = rad
    }

    public func hit(ray iRay: inout Ray,
                    minD iMinDist: Double,
                    maxD iMaxDist: Double)
    -> HitRecord?
    {
        let oc    = iRay.origin - self.position
        let a     = iRay.direction.norm2()
        let halfB = oc.dot(iRay.direction)
        let c     = oc.norm2() - self.radius * self.radius

        let discriminant = halfB * halfB - a * c;

        if discriminant < 0 { return nil }

        let d = (-halfB - discriminant.squareRoot()) / a
        if d < 0.0 { return nil }

        let n = self.getNormal(at: iRay.at(d))

        return HitRecord(n, d)
    }

    public func getNormal(at iPosition: Vec3) -> Vec3
    {
        return (iPosition - self.position).normalized()
    }
}