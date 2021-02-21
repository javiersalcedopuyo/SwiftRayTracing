import Foundation
import Math

public func schlickApprox(cosine: Double, refractionIdx: Double) -> Double
{
    var r0 = (1.0 - refractionIdx) / (1.0 + refractionIdx)
    r0 = r0*r0
    return r0 + (1.0 - r0) * pow(1.0 - cosine, 5)
}

public class Dielectric : Material
{
    public var albedo:        Vec3
    public var refractionIdx: Double
    // TODO: roughness?

    public init()             { self.albedo = Vec3.one(); self.refractionIdx = 1.0 }
    public init(albedo: Vec3) { self.albedo = albedo;     self.refractionIdx = 1.0 }
    public init(albedo: Vec3, refractionIdx: Double)
    {
        self.albedo        = albedo
        self.refractionIdx = refractionIdx
    }

    public func scatter(ray iRay: Ray,
                        hit iHit: HitRecord,
                        attenuation ioAttenuation: inout Vec3)
    -> Ray?
    {
        let eta = iHit.isInnerFace ? self.refractionIdx
                                   : 1.0 / self.refractionIdx

        let candidate   = -iRay.direction.dot(iHit.normal)
        let cosTheta    = min(candidate, 1.0)
        let sinTheta    = (1.0 - cosTheta*cosTheta).squareRoot()

        let reflectProb = schlickApprox(cosine: cosTheta, refractionIdx: eta)

        ioAttenuation   = self.albedo

        if eta * sinTheta > 1.0 || Double.random(in: 0...1) < reflectProb
        {
            // The ray didn't get into the surface! Reflect it.
            let resultingRayDir = iRay.direction.reflect(normal: iHit.normal)
            if resultingRayDir.dot(iHit.normal) <= 0 { return nil }

            return Ray(origin: iHit.position, direction: resultingRayDir)
        }

        let resultingRayDir = iRay.direction.refract(normal: iHit.normal, eta: eta)
        return Ray(origin: iHit.position, direction: resultingRayDir)
    }
}