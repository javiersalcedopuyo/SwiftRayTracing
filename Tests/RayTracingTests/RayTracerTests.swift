import XCTest
import struct Utils.Pixel8
import Math
import var RayTracing.SKY_COLOR_1
@testable import class RayTracing.RayTracer

final class RayTracerTests: XCTestCase
{
    let COLOR_EPSILON: Int8 = 3 // ~ 1%

    func comparePixel8s(a: Pixel8, b: Pixel8, accuracy: Int8) -> Bool
    {
        let r = abs(Int(a.r) - Int(b.r))
        let g = abs(Int(a.g) - Int(b.g))
        let b = abs(Int(a.b) - Int(b.b))

        return r<=accuracy && g<=accuracy && b<=accuracy
    }

    func testEmptyRenderCreatesImageOfCorrectColor()
    {
        let rt    = RayTracer(w:64, h:64)
        let image = rt.render()
        let pixel = image.at(col: 32, row: 32)

        let EXPECTED_MIDDLE_COLOR = Pixel8(fromVec3: Vec3.lerp(from: Vec3.one(), to: SKY_COLOR_1, t: 0.5))

        XCTAssert(comparePixel8s(a: pixel, b: EXPECTED_MIDDLE_COLOR, accuracy: COLOR_EPSILON),
                  "\(pixel) != \(EXPECTED_MIDDLE_COLOR) with accuracy \(COLOR_EPSILON)")
    }

    // TODO: Implement whith materials
    //func testRenderRedBall()
    //func testRenderRedBallWithBlueBallOccluded
}