import XCTest
import Math
@testable import class RenderableObjects.Sphere

final class SphereTests: XCTestCase
{
    func testMissRayIntersection()
    {
        let sphere = Sphere(pos: Vec3.zero(), rad: 0.1)
        let ray    = Ray(origin:    Vec3(x:0.0, y:0.0, z:-1.0),
                         direction: Vec3(x:0.0, y:1.0, z:0.0))

        let hit = sphere.hit(ray: ray, minD: 0.0, maxD: 10.0)

        XCTAssert(hit == nil, "ERROR: The ray hitted the spehere at \(ray.at(hit!.distance))")
    }

    func testRayMissesSphereBehindCamera()
    {
        let sphere = Sphere(pos: Vec3.zero(), rad: 0.1)
        let ray    = Ray(origin:    Vec3(x:0.0, y:0.0, z:1.0),
                         direction: Vec3(x:0.0, y:0.0, z:1.0))

        let hit = sphere.hit(ray: ray, minD: 0.0, maxD: 10.0)

        XCTAssert(hit == nil, "ERROR: The ray hitted the spehere at \(ray.at(hit!.distance))")
    }

    func testRayIntersection()
    {
        let sphere = Sphere(pos: Vec3.zero(), rad: 0.1)
        let ray    = Ray(origin:    Vec3(x:0.0, y:0.0, z:-1.0),
                         direction: Vec3(x:0.0, y:0.0, z:1.0))

        let hit = sphere.hit(ray: ray, minD: 0.0, maxD: 10.0)

        XCTAssert(hit != nil, "ERROR: The ray didn't hit the spehere.")
    }

    func testRayIntersectionDistance()
    {
        let sphere = Sphere(pos: Vec3.zero(), rad: 0.1)
        let ray    = Ray(origin:    Vec3(x:0.0, y:0.0, z:-1.0),
                         direction: Vec3(x:0.0, y:0.0, z:1.0))

        let hit = sphere.hit(ray: ray, minD: 0.0, maxD: 10.0)

        XCTAssert(hit != nil, "ERROR: The ray didn't hit the spehere.")
        XCTAssertEqual(hit!.distance, 0.9, accuracy: 0.0001)
    }

    func testRayIntersectionNormal()
    {
        let sphere = Sphere(pos: Vec3.zero(), rad: 0.1)
        let ray    = Ray(origin:    Vec3(x:0.0, y:0.0, z:-1.0),
                         direction: Vec3(x:0.0, y:0.0, z:1.0))

        let hit = sphere.hit(ray: ray, minD: 0.0, maxD: 10.0)
        XCTAssert(hit != nil, "ERROR: The ray didn't hit the spehere.")

        let expectedNormal = (ray.origin - sphere.position).normalized()

        XCTAssertEqual(hit!.normal, expectedNormal)
    }

    func testNormalIsUnitVector()
    {
        let s = Sphere(pos: Vec3.zero(), rad: 2.0)
        let n = s.getNormal(at: Vec3(x:2.0, y:0.0, z:0.0))

        XCTAssertEqual(n.norm2(), 1.0)
    }

    func testInnerNormal()
    {
        let s = Sphere(pos: Vec3.zero(), rad: 1.0)
        let r = Ray(origin: Vec3(x:0.1, y:0.0, z:0.0), direction: Vec3.one())

        let h = s.hit(ray: r, minD: 0.0, maxD: 2.0)

        XCTAssert(h != nil, "The ray didn't hit the sphere!")
        if h == nil { return }

        XCTAssert(h!.distance > 0.0, "It hitted behind! \(h!.distance)")

        XCTAssert(h!.isInnerFace, "The ray didn't hit the inside of the sphere!")
        XCTAssert(h!.normal.dot(r.direction) < 0.0, "The normal points outwards!")
    }
}