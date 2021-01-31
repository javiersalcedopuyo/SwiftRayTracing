public let TAU = Double.pi * 2.0

public func randomPointInUnitSphere() -> Vec3
{
    while true
    {
        let p = Vec3.random(min: -1.0, max: 1.0)
        if p.norm2() > 1.0 { continue }
        return p
    }
}