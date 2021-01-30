import struct Math.Vec3
import struct Math.Ray

public typealias HitRecord = (normal: Vec3, distance: Double, isInnerFace: Bool)

public protocol Intersectionable
{
    var position: Vec3 {get set}

    func hit(ray iRay: inout Ray, minD iMinDist: Double, maxD iMaxDist: Double) -> HitRecord?
    func getNormal(at iPosition: Vec3) -> Vec3
}