import XCTest
import Math
@testable import class RayTracing.Camera

final class CameraTests: XCTestCase
{
    func testInitialLoweLeftCornerPosition()
    {
        let cam = Camera(w:128, h:128) // Default position is (0,0,0)

        XCTAssert(cam.lower_left_corner.dot(cam.right)   < 0.0, "Lower Left Corner is on the right!")
        XCTAssert(cam.lower_left_corner.dot(cam.up)      < 0.0, "Lower Left Corner is over the camera!")
        XCTAssert(cam.lower_left_corner.dot(cam.forward) > 0.0, "Lower Left Corner is behind the camera!")
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

        XCTAssertEqual(ray.direction, cam.forward)
    }

    func testRayToLowLeftCorner()
    {
        let cam = Camera(w:128, h:128)
        let u = 0.0
        let v = 0.0

        let ray = cam.get_ray(u:u, v:v)

        XCTAssert(ray.direction.dot(cam.right)   < 0.0, "Ray going RIGHT!")
        XCTAssert(ray.direction.dot(cam.up)      < 0.0, "Ray going UP!")
        XCTAssert(ray.direction.dot(cam.forward) > 0.0, "Ray going BACK!")
    }
}