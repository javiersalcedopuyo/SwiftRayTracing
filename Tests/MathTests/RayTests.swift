import XCTest
@testable import Math

final class RayTests: XCTestCase
{
    let EPSILON = 0.00001

    func testNewDirectionIsNormalized()
    {
        let ray = Ray()
        XCTAssertEqual(ray.direction.norm2(), 1.0, accuracy:EPSILON)

        let ray2 = Ray(origin: Vec3.zero(), direction: Vec3.one())
        XCTAssertEqual(ray2.direction.norm2(), 1.0, accuracy:EPSILON)
    }
}