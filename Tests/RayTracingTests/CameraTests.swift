import XCTest
import Math
@testable import class RayTracing.Camera

final class CameraTests: XCTestCase
{
    func testUpdateLowerLeftCorner()
    {
        let cam = Camera(w:128, h:128)
        let llc = cam.lower_left_corner

        let translation = Vec3.one() / 1.0
        let asdf = Vec3.zero();
        let new_pos = translation + asdf
        cam.move_to( new_pos )

        XCTAssertEqual( cam.lower_left_corner, llc + translation )
    }
}