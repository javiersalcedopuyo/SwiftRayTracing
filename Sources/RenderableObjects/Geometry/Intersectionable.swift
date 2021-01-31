import struct Math.Vec3
import struct Math.Ray

public typealias HitRecord = (normal:      Vec3,
                              position:    Vec3,
                              distance:    Double,
                              isInnerFace: Bool,
                              material:    Material)

public protocol Intersectionable : AnyObject
{
    var position: Vec3 {get set}
    var material: Material {get set}

    func hit(ray iRay: Ray, minD iMinDist: Double, maxD iMaxDist: Double) -> HitRecord?
    func getNormal(at iPosition: Vec3) -> Vec3
}