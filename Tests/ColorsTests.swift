//
//  ColorsTests.swift
//  ColorsTests
//
//  Created by Edward Smith on 4/25/21.
//

import XCTest
@testable import Colors

class ColorsTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    // MARK: -

    let kTestColor = UIColor(red: 0.49, green: 0.00, blue: 0.33, alpha: 1.0)
    let kTestColorPixel:  UInt32 = 0xff7f0054
    let kMask: UInt32 = 0xfcfcfcfc

    func RGBA(_ color: UIColor) -> [CGFloat] {
        var r, b, g, a: CGFloat
        r = 0; b = 0; g = 0; a = 0;
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [r, g, b, a]
    }

    func assertColorsEqual(_ a: UIColor, _ b: UIColor, file: StaticString = #file, line: UInt = #line) {
        let aa = RGBA(a)
        let ab = RGBA(b)
        for idx in 0..<4 {
            XCTAssertEqual(aa[idx], ab[idx], accuracy: 0.01, file: file, line: line)
        }
    }

    // MARK: -

    func testColorFromPixel() {
        let color = colorFromPixel(kTestColorPixel)
        assertColorsEqual(color, kTestColor)
    }

    func testPixelFromColor() {
        let pixel = pixelFromColor(kTestColor)
        XCTAssertEqual((pixel & kMask) ^ (kTestColorPixel & kMask), 0)
    }

    func testPixelExtraction() throws {
        let size = CGSize(width: 10, height: 10)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo =
            CGBitmapInfo.byteOrder32Little.rawValue |
            CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw ImageError.CantCreateContext
        }
        UIGraphicsPushContext(context)
        context.setFillColor(kTestColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        context.flush()
        UIGraphicsPopContext()

        // Get the  pixels:
        guard let contextData = context.data else {
            throw ImageError.CantCreateContext
        }
        let pixels: UnsafeMutablePointer<UInt32> = contextData.bindMemory(
            to: UInt32.self,
            capacity: context.bytesPerRow * Int(size.height) /  4
        )
        let rowWidth: Int = context.bytesPerRow / 4

        let pixel = pixels[1*rowWidth + 1]
        let ps = String(format: "0x%08x", pixel)
        let ts = String(format: "0x%08x", kTestColorPixel)
        print("pixel: \(ps) kTestColorPixel: \(ts)")
        XCTAssertEqual((pixel & kMask) ^ (kTestColorPixel & kMask), 0)
    }

    func testConversionRoundTrip() {
        let pixel = pixelFromColor(kTestColor)
        let color = colorFromPixel(pixel)
        assertColorsEqual(color, kTestColor)
    }
}
