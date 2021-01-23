import XCTest
import struct Utils.Pixel8
import var RayTracing.SKY_COLOR_1
@testable import class RayTracing.RayTracer

final class RayTracerTests: XCTestCase
{
    let COLOR_EPSILON: Int8 = 3 // ~ 1%
    let SKY_COLOR = Pixel8(fromVec3: SKY_COLOR_1)

    func comparePixel8s(a: Pixel8, b: Pixel8, accuracy: Int8) -> Bool
    {
        let r = abs(Int(a.r) - Int(b.r))
        let g = abs(Int(a.g) - Int(b.g))
        let b = abs(Int(a.b) - Int(b.b))

        return r<=accuracy && g<=accuracy && b<=accuracy
    }

    func testEmptyRenderCreatesImageOfCorrectColor()
    {
        let rt    = RayTracer(w:101, h:100)
        let image = rt.render()
        let pixel = image.at(col: 50, row: 0)

        XCTAssert(comparePixel8s(a: pixel, b: SKY_COLOR, accuracy: COLOR_EPSILON),
                  "\(pixel) != \(SKY_COLOR) with accuracy \(COLOR_EPSILON)")
    }
}