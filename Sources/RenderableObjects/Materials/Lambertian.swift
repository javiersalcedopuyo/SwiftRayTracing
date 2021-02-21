import Math

public class Lambertian : Material
{
    public var albedo: Vec3

    public init()             { self.albedo = Vec3.one() }
    public init(albedo: Vec3) { self.albedo = albedo }

    public func scatter(ray iRay: Ray,
                        hit iHit: HitRecord,
                        attenuation ioAttenuation: inout Vec3)
    -> Ray?
    {
        var scatterDir = iHit.normal + Vec3.randomUnit()
        if scatterDir.isNearZero()
        {
            scatterDir = iHit.normal
        }

        ioAttenuation  = self.albedo
        return Ray(origin: iHit.position, direction: scatterDir)
    }
}