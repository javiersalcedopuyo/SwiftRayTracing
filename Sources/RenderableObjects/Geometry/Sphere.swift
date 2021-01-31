import Math

public class Sphere : Intersectionable
{
    public var position: Vec3
    public var material: Material

    var radius: Double

    public init()
    {
        self.position = Vec3.zero()
        self.radius   = 1.0
        self.material = Lambertian(albedo: Vec3.random(min: 0.0, max: 1.0) )
    }

    public init(pos: Vec3, rad: Double)
    {
        self.position = pos
        self.radius   = rad
        self.material = Lambertian(albedo: Vec3.random(min: 0.0, max: 1.0) )
    }

    public init(pos: Vec3, rad: Double, mat: Material)
    {
        self.position = pos
        self.radius   = rad
        self.material = mat
    }

    public func hit(ray  iRay:     Ray,
                    minD iMinDist: Double,
                    maxD iMaxDist: Double)
    -> HitRecord?
    {
        let oc  = iRay.origin - self.position
        let distRayToCenter2 = oc.norm2()
        let radius2 = self.radius * self.radius

        if distRayToCenter2 <= radius2
        { // The ray comes from inside the ~house~ sphere!
            let d           = self.radius - distRayToCenter2.squareRoot()

            if d < iMinDist { return nil }

            let p           = iRay.at(d)
            let n           = -self.getNormal(at: p)
            let isInnerFace = true

            return HitRecord(n, p, d, isInnerFace, self.material)
        }

        // NOTE: Since ray directions are normalized:
        //          a = iRay.direction.dot( iRay.direction ) == 1.0
        let b = oc.dot(iRay.direction)
        let c = distRayToCenter2 - radius2

        let discriminant = b*b - c;

        if discriminant < 0.0 { return nil }

        let d = -b - discriminant.squareRoot()

        if d < iMinDist || d > iMaxDist { return nil }

        let p           = iRay.at(d)
        var n           = self.getNormal(at: p)
        var isInnerFace = false

        if iRay.direction.dot(n) > 0.0
        {
            n = -n
            isInnerFace = true
        }

        return HitRecord(n, p, d, isInnerFace, self.material)
    }

    public func getNormal(at iPosition: Vec3) -> Vec3
    {
        return (iPosition - self.position).normalized()
    }
}