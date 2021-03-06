import Foundation
import Math

public struct Pixel8 : Equatable
{
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8

    static func black() -> Pixel8 { Pixel8( r: 0,   g: 0,   b: 0   ) }
    static func white() -> Pixel8 { Pixel8( r: 255, g: 255, b: 255 ) }

    public init (r: UInt8, g: UInt8, b: UInt8)
    {
        self.r = r
        self.g = g
        self.b = b
    }

    public init (fromVec3 vec: Vec3)
    {
        self.r = UInt8(vec.x * 255.0)
        self.g = UInt8(vec.y * 255.0)
        self.b = UInt8(vec.z * 255.0)
    }

    subscript(index: Int) -> UInt8
    {
        // TODO: throws
        get
        {
            assert(index < 3, "ERROR: Index \(index) out of bounds")
            switch index
            {
                case 0:  return self.r
                case 1:  return self.g
                case 2:  return self.b
                default: return self.r
            }
        }
        set(newVal)
        {
            assert(index < 3, "ERROR: Index \(index) out of bounds")
            switch index
            {
                case 0:  self.r = newVal
                case 1:  self.g = newVal
                case 2:  self.b = newVal
                default: self.r = newVal
            }
        }
    }
}

public class ImagePPM
{
    public let width:  UInt
    public let height: UInt

    var pixels: Array<Pixel8>

    public init(width: UInt, height: UInt)
    {
        self.width  = width
        self.height = height
        self.pixels = Array<Pixel8>.init(repeating: Pixel8.black(),
                                         count:     Int(width * height))
    }

    public init(width: UInt, height: UInt, color: Vec3)
    {
        self.width  = width
        self.height = height
        self.pixels = Array<Pixel8>.init(repeating: Pixel8(fromVec3: color),
                                         count:     Int(width * height))
    }

    public init(width: UInt, height: UInt, data: Data)
    {
        // TODO: Throws
        assert(data.count == Int(width*height*3),
               "Declared (\(width*height*3)) and actual size (\(data.count)) differ")

        self.width  = width
        self.height = height
        self.pixels = Array<Pixel8>.init()

        self.pixels.reserveCapacity( Int(width*height) )

        var counter  = 0
        var tmpPixel = Pixel8.black()

        for byte in data
        {
            tmpPixel[counter] = byte
            if counter == 2 { self.pixels.append( tmpPixel ) }
            counter = (counter+1) % 3
        }
    }

    public static func fromFile(at iPath: String) -> ImagePPM?
    {
        guard let file = FileHandle( forReadingAtPath: iPath ) else { return nil }

        let rawData         = file.availableData
        let (width, height) = parseHeader(iData: rawData)

        // Get the EOL character (\n, 10 in ASCII)
        guard let startIdx  = rawData.firstIndex(of: 10) else { return nil }

        return ImagePPM(width:  width,
                        height: height,
                        data:   rawData[startIdx+1..<rawData.count])
    }

    public func at(col: UInt, row: UInt) -> Pixel8
    {
        assert(col<self.width,  "ERROR: X \(col) is out of bounds")
        assert(row<self.height, "ERROR: Y \(row) is out of bounds")

        let i = self.getIndex(x:col, y:row)
        return self.pixels[i]
    }

    public func set(col: UInt, row: UInt, color: Pixel8)
    {
        assert(col<self.width,  "ERROR: X \(col) is out of bounds")
        assert(row<self.height, "ERROR: Y \(row) is out of bounds")

        let i = self.getIndex(x:col, y:row)
        self.pixels[i] = color
    }

    public func set(col: UInt, row: UInt, color: Vec3)
    {
        assert(col<self.width,  "ERROR: X \(col) is out of bounds")
        assert(row<self.height, "ERROR: Y \(row) is out of bounds")

        let i = self.getIndex(x:col, y:row)
        self.pixels[i] = Pixel8(fromVec3: color)
    }

    static func parseHeader(iData: Data) -> (width: UInt, height: UInt)
    {
        // TODO: Throws
        assert(iData[0] == 80 && iData[1] == 54, // ASCII: 80=P, 6=6
               "ERROR: Unsupported type (input is not binary PPM)!")

        var result    = Array<UInt>(repeating: 0, count: 2)
        var resIdx    = 0
        var aux :UInt = 0

        for i in 3..<iData.count
        {
            let byte = iData[i]
            if byte == 32 // Space
            {
                result[resIdx] += aux
                aux = 0
                resIdx += 1
                if resIdx > 1 { break }
                continue
            }

            assert(byte>47 && byte<58, "ERROR: NaN, Expected image dimensions!")

            aux *= 10
            aux += UInt(byte) - 48
        }

        return (width: result[0], height: result[1])
    }

    func getIndex(x: UInt, y: UInt) -> Int
    {
        var result = Int( y * self.width + x )

        if result >= self.pixels.count
        {
            result = self.pixels.count - 1
        }
        return result
    }

    func getData() -> Data
    {
        var result = Data( repeating: 0x00, count: pixels.count * 3 )

        var i = 0
        for p in pixels
        {
            result[i+0] = p.r
            result[i+1] = p.g
            result[i+2] = p.b

            i+=3
            if i>=result.count { break }
        }
        return Data.init( result )
    }

    public func writeToFile(at iPath: String)
    {
        var d = "P6 \(self.width) \(self.height) 255\n".data( using: .utf8 )!
        d.append( self.getData() )

        FileManager.default.createFile( atPath: iPath, contents: d )
    }
}
