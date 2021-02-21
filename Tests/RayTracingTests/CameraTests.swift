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
        cam.moveTo( translation )

        XCTAssertEqual( cam.lower_left_corner, llc + translation )
    }

    func testRayToUVCenter()
    {
        let cam = Camera(w:128, h:128)
        let u = 0.5
        let v = 0.5

        let ray = cam.getRay(u:u, v:v)

        XCTAssertEqual(ray.direction, cam.forward)
    }

    func testRayToLowLeftCorner()
    {
        let cam = Camera(w:128, h:128)
        let u = 0.0
        let v = 0.0

        let ray = cam.getRay(u:u, v:v)

        XCTAssert(ray.direction.dot(cam.right)   < 0.0, "Ray going RIGHT!")
        XCTAssert(ray.direction.dot(cam.up)      < 0.0, "Ray going UP!")
        XCTAssert(ray.direction.dot(cam.forward) > 0.0, "Ray going BACK!")
    }

    func testLookDown45deg()
    {
        let cam = Camera(w:8, h: 8)
        let target = Vec3(x:0.0, y:-1.0, z:1.0).normalized()

        let prevRight = cam.right
        let prevUp    = cam.up

        cam.lookAt(target)

        XCTAssertEqual(cam.up.dot(prevUp), sin(deg2rad(45.0)), accuracy: 0.001)
        XCTAssert(compareVec3WithAccuracy(cam.right, prevRight, accuracy: 0.001),
                  "\(cam.right) != \(prevRight) with accuracy 0.001")
        XCTAssert(compareVec3WithAccuracy(cam.forward, target, accuracy: 0.001),
                  "\(cam.forward) != \(target) with accuracy 0.001")
    }

    // FIXME: The issue comes when the forward is the same as WORLD_UP, resulting
    //        on a right vector of 0,0,0
    //        This probably could be fixed by actually rotating the camera instead
    //func testLookUp()
    //{
    //    let cam = Camera(w:8, h: 8)
    //    let target = Vec3(x:0.0, y:1.0, z:0.0)

    //    let prevRight   = cam.right
    //    let prevUp      = cam.up
    //    let prevForward = cam.forward

    //    cam.lookAt(target)

    //    XCTAssert(compareVec3WithAccuracy(cam.right, prevRight, accuracy: 0.001),
    //              "\(cam.right) != \(prevRight) with accuracy 0.001")
    //    XCTAssert(compareVec3WithAccuracy(cam.forward, prevUp, accuracy: 0.001),
    //              "\(cam.forward) != \(prevUp) with accuracy 0.001")
    //    XCTAssert(compareVec3WithAccuracy(cam.up, -prevForward, accuracy: 0.001),
    //              "\(cam.up) != \(-prevForward) with accuracy 0.001")
    //    XCTAssertEqual(cam.up, -prevForward)
    //}
}