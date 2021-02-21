import Math

public class Metallic : Material
{
    public var albedo: Vec3
    public var roughness: Double

    public init()             { self.albedo = Vec3.one(); self.roughness = 0.0 }
    public init(albedo: Vec3) { self.albedo = albedo;     self.roughness = 0.0 }
    public init(albedo: Vec3, roughness: Double)
    {
        self.albedo    = albedo
        self.roughness = roughness
    }

    public func scatter(ray iRay: Ray,
                        hit iHit: HitRecord,
                        attenuation ioAttenuation: inout Vec3)
    -> Ray?
    {
        var reflected = iRay.direction.reflect( normal: iHit.normal )
        ioAttenuation = self.albedo

        if reflected.dot(iHit.normal) <= 0 { return nil }

        reflected += Vec3.randomUnit() * self.roughness

        return Ray(origin: iHit.position, direction: reflected)
    }
}