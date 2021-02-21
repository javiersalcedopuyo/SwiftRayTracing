public let TAU = Double.pi * 2.0

public func rad2deg(_ r: Double) -> Double
{
    return r * 360.0 / TAU
}

public func deg2rad(_ d: Double) -> Double
{
    return d * TAU / 360.0
}

public func randomPointInUnitSphere() -> Vec3
{
    while true
    {
        let p = Vec3.random(min: -1.0, max: 1.0)
        if p.norm2() > 1.0 { continue }
        return p
    }
}

public func randomPointInUnitHemisphere(normal: Vec3) -> Vec3
{
    let result = randomPointInUnitSphere()
    return result.dot(normal) > 0.0 ? result : -result
}