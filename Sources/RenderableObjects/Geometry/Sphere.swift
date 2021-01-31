import Math

public class Sphere : Intersectionable
{
    public var position:    Vec3

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

    public func hit(ray  iRay:     inout Ray,
                    minD iMinDist: Double,
                    maxD iMaxDist: Double)
    -> HitRecord?
    {
        let oc  = iRay.origin - self.position
        let oc2 = oc.norm2()

        if oc2 < self.radius
        { // The ray originates from inside the sphere
            let d = self.radius - oc2.squareRoot()
            let n = -self.getNormal(at: iRay.at(d))
            return HitRecord(n, d, true)
        }

        // NOTE: Since ray directions are normalized, a = iRay.direction.norm2() == 1.0
        let b = oc.dot(iRay.direction)
        let c = oc2 - self.radius * self.radius

        let discriminant = b*b - c;

        if discriminant < 0.0 { return nil }

        let d = -b - discriminant.squareRoot()

        if d < iMinDist || d > iMaxDist { return nil }

        var n           = self.getNormal(at: iRay.at(d))
        var isInnerFace = false

        if iRay.direction.dot(n) > 0.0
        {
            n = -n
            isInnerFace = true
        }

        return HitRecord(n, d, isInnerFace)
    }

    public func getNormal(at iPosition: Vec3) -> Vec3
    {
        return (iPosition - self.position).normalized()
    }
}