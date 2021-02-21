import XCTest
@testable import Math

final class Vec3Tests: XCTestCase
{
    func testOrthogonalDotProduct()
    {
        let a = Vec3( x:2.0, y:0.0, z:0.0 )
        let b = Vec3( x:0.0, y:3.0, z:0.0 )

        XCTAssertEqual( a.dot(b), 0.0 )
    }

    func testParallelDotProduct()
    {
        let a = Vec3( x:1.0, y:2.0, z:3.0 )
        let b = Vec3( x:2.0, y:4.0, z:6.0 )

        let normsProduct = a.norm() * b.norm()

        XCTAssertEqual( a.dot(b), normsProduct )
    }

    func testCrossProduct()
    {
        let x = Vec3( x:1.0, y:0.0, z:0.0 )
        let y = Vec3( x:0.0, y:1.0, z:0.0 )
        let z = Vec3( x:0.0, y:0.0, z:1.0 )

        XCTAssertEqual( x.cross(y), z )
    }

    func testInvCrossProduct()
    {
        let x = Vec3( x:1.0, y:0.0, z:0.0 )
        let y = Vec3( x:0.0, y:1.0, z:0.0 )
        let z = Vec3( x:0.0, y:0.0, z:1.0 )

        XCTAssertEqual( y.cross(x), -z )
    }

    func testNorm()
    {
        let a = Vec3( x:1.0, y:0.0, z:0.0 )

        XCTAssertEqual( a.norm(), 1.0 )
    }

    func testNormalized()
    {
        let a = Vec3( x:1.0, y:2.0, z:3.0 )
        let n = a.normalized()

        XCTAssertEqual( n.norm(), 1.0 )
    }

    func testNormalizedZero()
    {
        let a = Vec3.zero()
        XCTAssertEqual(a.normalized(), Vec3.zero())
    }

    func testReflect()
    {
        let v = Vec3.random(min: 0.0, max: 1.0)
        let n = Vec3.randomUnit()
        let r = v.reflect(normal: n)

        XCTAssertEqual(r.dot(n), -v.dot(n), accuracy: 0.001)
    }
}
