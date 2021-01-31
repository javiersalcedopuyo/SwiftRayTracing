import XCTest
import struct Utils.Pixel8
import class RenderableObjects.Sphere
import class RenderableObjects.Lambertian
import Math
import var RayTracing.SKY_COLOR_1
@testable import class RayTracing.RayTracer

final class RayTracerTests: XCTestCase
{
    let RED  = Vec3(x:1.0, y:0.0, z:0.0)
    let BLUE = Vec3(x:0.0, y:1.0, z:1.0)
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

    func testRenderRedBall()
    {
        let rt        = RayTracer(w:64, h:64)
        let redMat    = Lambertian(albedo: RED)
        let redSphere = Sphere(pos: Vec3(x:0.0, y:0.0, z:1.0), rad: 0.5, mat: redMat)

        rt.addObject(redSphere)

        let image = rt.render()
        let pixel = image.at(col: 32, row: 32)

        // The attenuation will make it less bright, but the red channel should
        // still be the only one
        XCTAssertNotEqual(pixel.r, 0)
        XCTAssertEqual(pixel.g, 0)
        XCTAssertEqual(pixel.b, 0)
    }

    func testRenderRedBallWithBlueBallOccluded()
    {
        let rt         = RayTracer(w:64, h:64)
        let redMat     = Lambertian(albedo: RED)
        let blueMat    = Lambertian(albedo: BLUE)
        let redSphere  = Sphere(pos: Vec3(x:0.0, y:0.0, z:1.0), rad: 0.5, mat: redMat)
        let blueSphere = Sphere(pos: Vec3(x:0.0, y:0.0, z:2.0), rad: 1.0, mat: blueMat)

        rt.addObject(redSphere)
        rt.addObject(blueSphere)

        let image = rt.render()
        let pixel = image.at(col: 32, row: 32)

        // The attenuation will make it less bright, but the red channel should
        // still be the only one
        XCTAssertNotEqual(pixel.r, 0)
        XCTAssertEqual(pixel.g, 0)
        XCTAssertEqual(pixel.b, 0)
    }
}