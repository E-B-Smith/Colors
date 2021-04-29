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

    /**
     Returns a rectangle the same size as the receiver that is centered over the passed rectangle.

     - Parameters:
       - overRect:      The rectangle to center over.
     - Returns:         A rectangle the same size as the receiver centered over the passed rectangle.
    */
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

    /**
     Creates a new image replacing the colors in the receiver image with the new colors.

     - Parameters:
       - colors:    An array of colors to replace. The first color in the tuple is the "from" color, the color
                    to replace. The second color in the tuple is the "to" color, the color to use as a replacement.
       - tolerance: The tolerance to use when matching the "from" color. This is a percentage, 0.0 to 1.0.
     - Returns:     Returns an image with the color replacements.
    */
    public func replace(colors: [(UIColor, UIColor)], tolerance: CGFloat) throws -> UIImage {
        if colors.isEmpty { return  self }
        let tolerance = max(min(tolerance, 1.0), 0.0)

        // Set up our data:
        struct ColorReplacement {
            let fromColor: [CGFloat]
            let toColor: UInt32
        }

        var replacements = [ColorReplacement]()
        for c in colors {
            var a,r,g,b: CGFloat
            a = 0; r = 0; g = 0; b = 0;
            c.0.getRed(&r, green: &g, blue: &b, alpha: &a)
            let replacement = ColorReplacement(
                fromColor: [a*255,r*255,g*255,b*255],
                toColor: pixelFromColor(c.1)
            )
            replacements.append(replacement)
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
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -CGFloat(height))
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
        // RowWidth in pixels: 8 bits * (4 RGBA components) = 32 bits / 8 bits per byte.
        let rowWidth: Int = context.bytesPerRow / 4

        // Find and replace the colors:
        for y in 0..<height {
            let row = y*rowWidth
            for x in 0..<width {
                let pixel = pixels[row + x]
                for r in replacements {
                    if distance(pixel, r.fromColor) <= tolerance {
                        pixels[row + x] = r.toColor
                        break
                    }
                }
            }
        }
        guard let cgimage = context.makeImage() else {
            throw ImageError.CantCreateImage
        }
        return UIImage(cgImage: cgimage, scale: scale, orientation: .up)
    }
}

@inline(__always)
func distance(_ pixel: UInt32, _ color: [CGFloat]) -> CGFloat {
    var pixel = pixel
    var d: Double =  0
    for idx in (1...3).reversed() {
        let v = CGFloat(pixel & 0x000000ff) - color[idx]
        d += Double(v*v)
        pixel >>= 8
    }
    return CGFloat(d / (255*255*3))
}

@inline(__always)
func colorFromPixel(_ pixel: UInt32) -> UIColor {
    let a:CGFloat = CGFloat((pixel & 0xff000000) >> 24) / 255.0
    let r:CGFloat = CGFloat((pixel & 0x00ff0000) >> 16) / 255.0
    let g:CGFloat = CGFloat((pixel & 0x0000ff00) >>  8) / 255.0
    let b:CGFloat = CGFloat( pixel & 0x000000ff) / 255.0
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
