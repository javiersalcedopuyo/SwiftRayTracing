import XCTest
import struct Utils.Pixel8
@testable import class Utils.ImagePPM

final class ImagePPMTests: XCTestCase
{
    let testOutPath = "Out/test.ppm"

    override func tearDownWithError() throws
    {
        if FileManager.default.fileExists( atPath: testOutPath )
        {
            try FileManager.default.removeItem( atPath: testOutPath )
        }
    }

    //func testHeaderParsingP6Type()
    //{
    //    let data  = "P6 123 456 255\n".data( using: .utf8 )!
    //    XCTAssertNoThrow( ImagePPM.parseHeader( iData: data ) )
    //}

    //func testHeaderParsingWrongType()
    //{
    //    let data  = "P7 123 456 255\n".data( using: .utf8 )!
    //    XCTAssertThrowsError( ImagePPM.parseHeader( iData: data ) )
    //}

    func testHeaderParsingDimensions()
    {
        let data  = "P6 123 456 255\n".data( using: .utf8 )!
        let (w,h) = ImagePPM.parseHeader( iData: data )

        XCTAssertEqual(w, 123, "Expected width doesn't match with parsed")
        XCTAssertEqual(h, 456, "Expected height doesn't match with parsed")
    }

    func testWriteReadFile()
    {
        let img = ImagePPM( width: 256, height: 256 )
        img[128,128] = Pixel8.white()
        img.writeToFile( at: testOutPath )

        XCTAssert(FileManager.default.fileExists( atPath: testOutPath ),
                  "Image file wasn't created.")

        let img2 = ImagePPM.fromFile( at: testOutPath )

        XCTAssert( img2 != nil, "Image failed loading" )

        XCTAssertEqual(img2![128,128],
                       Pixel8.white(),
                       "Saved and loaded image has the wrong color")
    }
}
