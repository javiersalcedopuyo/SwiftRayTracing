import struct Math.Vec3
import struct Math.Ray

public protocol Material : AnyObject
{
    var albedo: Vec3 {get set}

    func scatter(ray iRay: Ray,
                 hit iHit: HitRecord,
                 attenuation iAttenuation: inout Vec3)
    -> Ray?
}