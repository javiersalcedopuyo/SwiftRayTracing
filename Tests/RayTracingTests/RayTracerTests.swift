import XCTest
import struct Utils.Pixel8
import var RayTracing.SKY_COLOR_1
@testable import class RayTracing.RayTracer

final class RayTracerTests: XCTestCase
{
    func testEmptyRenderCreatesImageOfCorrectColor()
    {
        let rt = RayTracer()
        let image = rt.render()
        XCTAssertEqual(image[100, 100], Pixel8(fromVec3: SKY_COLOR_1))
    }
}