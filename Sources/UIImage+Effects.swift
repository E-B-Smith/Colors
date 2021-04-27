/**
 @file          UIImage+Effects.swift
 @package       IsCute?
 @brief         UIImage extension for image manipulation and effects
 @author        Edward Smith
 @date          September 2020
 @copyright     -©- Copyright © 2020 Affirm, Inc. All rights reserved. -©-
*/

import UIKit

public enum ImageError: String, Error {
    case CantCreateContext = "Can't create image context"
    case CantCreateImage   = "Can't create image"
}

extension CGRect {
    public func centerOver(_ overRect: CGRect) -> CGRect {
        let origin = CGPoint(
            x: overRect.origin.x + ((overRect.size.width - self.size.width)/2.0),
            y: overRect.origin.y + ((overRect.size.height - self.size.height)/2.0)
        )
        return CGRect(
            origin: origin,
            size: CGSize(width: self.size.width, height: self.size.height)
        )
    }
}

extension UIImage {

    /**
     Returns a solid color image with the given rectangle size.

     - Parameters:
       - color:     The color for the image.
       - size:      The size of the image.
     - Returns:     Returns an image with a solid color of the given size.
    */
    public static func image(color: UIColor, size: CGSize) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageError.CantCreateContext
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageError.CantCreateImage
        }
        return image
    }

    /**
     Draws the passed image on top of the current image and returns the result.

     - Parameters:
       - image:     The image to draw on top of the receiver.
     - Returns:     Returns an image composed of the current image with the passed image on top.
    */
    public func union(_ image: UIImage) throws -> UIImage {
        let selfRect = CGRect(
            origin: .zero,
            size: CGSize(width: self.size.width, height: self.size.height)
        )
        var imageRect = CGRect(
            origin: .zero,
            size: CGSize(width: image.size.width, height: image.size.height)
        )
        imageRect = imageRect.centerOver(selfRect)

        UIGraphicsBeginImageContextWithOptions(selfRect.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        guard
            let selfImage = self.cgImage,
            let imageImage = image.cgImage,
            let context = UIGraphicsGetCurrentContext()
        else {
            throw ImageError.CantCreateImage
        }

        // Orient the image correctly --
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -selfRect.size.height)

        // Set the color --
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(selfRect)

        context.draw(selfImage, in: selfRect)
        context.draw(imageImage, in: imageRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageError.CantCreateImage
        }
        return newImage
    }

    public func ovalImage() throws -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        guard
            let context = UIGraphicsGetCurrentContext(),
            let imageImage = self.cgImage
        else {
            throw ImageError.CantCreateImage
        }
        // Orient the image correctly --
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)

        // Set the color --
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)

        // Draw the circle --
        context.setFillColor(UIColor.black.cgColor)
        context.fillEllipse(in: rect)

        // Draw the image --
        context.setBlendMode(.sourceIn)
        context.draw(imageImage, in: rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageError.CantCreateImage
        }
        return image
    }

    public func aspectFit(size: CGSize) throws -> UIImage {
        guard
            size.height > 0.0,
            size.width > 0.0,
            let cgimage = self.cgImage
        else {
            throw ImageError.CantCreateImage
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageError.CantCreateContext
        }
        // Orient the image correctly --
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)

        // Set the color --
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)

        // d.w / d.h  = s.w / s.h
        // d.h / d.w  = s.h / s.w
        var destRect = CGRect()
        if (size.width < size.height) {
            destRect.size.width  = size.width;
            destRect.size.height = self.size.height / self.size.width * destRect.size.width;
        } else {
            destRect.size.height = size.height;
            destRect.size.width  = self.size.width / self.size.height * destRect.size.height;
        }
        destRect = destRect.centerOver(rect)
        context.draw(cgimage, in: destRect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageError.CantCreateImage
        }
        return image;
    }

    public func aspectFill(size: CGSize) throws -> UIImage {
        guard
            size.height > 0.0,
            size.width > 0.0,
            let cgimage = self.cgImage
        else {
            throw ImageError.CantCreateImage
        }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            throw ImageError.CantCreateContext
        }
        // Orient the image correctly --
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)

        // Set the color --
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(rect)

        // d.w / d.h  = s.w / s.h
        // d.h / d.w  = s.h / s.w
        var destRect = CGRect()
        if (size.width > size.height) {
            destRect.size.width  = size.width;
            destRect.size.height = self.size.height / self.size.width * destRect.size.width;
        } else {
            destRect.size.height = size.height;
            destRect.size.width  = self.size.width / self.size.height * destRect.size.height;
        }
        destRect = destRect.centerOver(rect)
        context.draw(cgimage, in: destRect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            throw ImageError.CantCreateImage
        }
        return image;
    }

    #if true
    // Work in progress

    public func replace(colors: [(UIColor, UIColor)], tolerance: CGFloat) throws -> UIImage {
        if colors.isEmpty { return  self }

        // Set up our data:
        struct ColorReplacement {
            let fromHueMin: CGFloat
            let fromHueMax: CGFloat
            let toHue: CGFloat
        }

        var replacements = [ColorReplacement]()
        for c in colors {
            var fromHue: CGFloat = 0.0
            c.0.getHue(&fromHue, saturation: nil, brightness: nil, alpha: nil)
            var toHue: CGFloat = 0.0
            c.1.getHue(&toHue, saturation: nil, brightness: nil, alpha: nil)
            let r = ColorReplacement(
                fromHueMin: fromHue - tolerance,
                fromHueMax: fromHue + tolerance,
                toHue: toHue
            )
            replacements.append(r)
        }

        // Draw the image in the bitmap:
        let width: Int = Int(floor(self.size.width*self.scale))
        let height: Int = Int(floor(self.size.height*self.scale))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo =
            CGBitmapInfo.byteOrder32Little.rawValue |
            CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw ImageError.CantCreateContext
        }
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        context.flush()
        UIGraphicsPopContext()

        // Get the  pixels:
        guard let contextData = context.data else {
            throw ImageError.CantCreateContext
        }
        let pixels: UnsafeMutablePointer<UInt32> = contextData.bindMemory(
            to: UInt32.self,
            capacity: context.bytesPerRow * height /  4
        )
        // RowWidth: 8 bits * (4 RGBA components) = 32 bits / 8 bits per byte.
        let rowWidth: Int = context.bytesPerRow / 4

        // Find and replace the colors:
        for y in 0..<height {
            for x in 0..<width {
                let pixel = pixels[y * rowWidth + x]
                let hue = hueFromPixel(pixel)
                for r in replacements {
                    if hue >= r.fromHueMin && hue <= r.fromHueMax {
                        pixels[y * rowWidth + x] = 0xff0000ff // updatePixelHue(pixel, r.toHue)
                        break
                    }
                }
            }
        }
        guard let cgimage = context.makeImage() else {
            throw ImageError.CantCreateImage
        }
        return UIImage(cgImage: cgimage, scale: scale, orientation: .downMirrored)
    }
    #endif

}

@inline(__always)
func colorFromPixel(_ pixel: UInt32) -> UIColor {
    let a:CGFloat = CGFloat((pixel & 0xff000000) >> 24) / 255.0
    let r:CGFloat = CGFloat((pixel & 0x00ff0000) >> 16) / 255.0
    let g:CGFloat = CGFloat((pixel & 0x0000ff00) >>  8) / 255.0
    let b:CGFloat = CGFloat(pixel & 0x000000ff) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

@inline(__always)
func pixelFromColor(_ color: UIColor) -> UInt32 {
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)
    return
        ((UInt32(a * 255.0) & 0x000000ff) << 24) |
        ((UInt32(r * 255.0) & 0x000000ff) << 16) |
        ((UInt32(g * 255.0) & 0x000000ff) <<  8) |
         (UInt32(b * 255.0) & 0x000000ff)
}

@inline(__always)
func hueFromPixel(_ pixel: UInt32) -> CGFloat {
    var hue: CGFloat = 0.0
    let c = colorFromPixel(pixel)
    c.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
    return hue
}

@inline(__always)
func updatePixelHue(_ pixel: UInt32, _ hue: CGFloat) -> UInt32 {
    let c = colorFromPixel(pixel)
    var s: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    c.getHue(nil, saturation: &s, brightness: &b, alpha: &a)
    let c1 = UIColor(hue: hue, saturation: s, brightness: b, alpha: a)
    return pixelFromColor(c1)
}
