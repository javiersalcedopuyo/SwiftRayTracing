import XCTest
import Math
@testable import class RayTracing.Camera

final class CameraTests: XCTestCase
{
    func testInitialLoweLeftCornerPosition()
    {
        let cam = Camera(w:128, h:128)

        XCTAssert( cam.lower_left_corner.x < 0, "Lower Left Corner is on the right!")
        XCTAssert( cam.lower_left_corner.y < 0, "Lower Left Corner is over the camera!")
        XCTAssert( cam.lower_left_corner.z > 0, "Lower Left Corner is behind the camera!" )
    }

    func testUpdateLowerLeftCorner()
    {
        let cam = Camera(w:128, h:128)
        let llc = cam.lower_left_corner

        let translation = Vec3(x:0.0, y:20.0, z:400.0)
        cam.move_to( translation )

        XCTAssertEqual( cam.lower_left_corner, llc + translation )
    }

    func testRayToUVCenter()
    {
        let cam = Camera(w:128, h:128)
        let u = 0.5
        let v = 0.5

        let ray = cam.get_ray(u:u, v:v)

        XCTAssertEqual(ray.direction.x, 0.0, "Ray not centered on X!")
        XCTAssertEqual(ray.direction.y, 0.0, "Ray not centered on Y!")
        XCTAssertEqual(ray.direction.z, 1.0, "Ray going BACK!")
    }

    func testRayToLowLeftCorner()
    {
        let cam = Camera(w:128, h:128)
        let u = 0.0
        let v = 0.0

        let ray = cam.get_ray(u:u, v:v)

        XCTAssert(ray.direction.x < 0.0, "Ray going RIGHT!")
        XCTAssert(ray.direction.y < 0.0, "Ray going UP!")
        XCTAssert(ray.direction.z > 0.0, "Ray going BACK!")
    }
}