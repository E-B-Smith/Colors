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

/*
    Work in progress

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
        let size = self.size
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: Int(8),
            bytesPerRow: Int(0),
            space: colorSpace,
            bitmapInfo: UInt32(CGImageAlphaInfo.last.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        ) else {
            throw ImageError.CantCreateContext
        }
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        context.flush()
        UIGraphicsPopContext()

        // Find and replace the colors:
        let pixels = [UInt32]() //= context.data
        let rowWidth: Int = context.bytesPerRow / 4 // 8 bits * (4 RGBA components) = 32 bits / 8 bits per byte.

        for y in 0..<Int(size.height) {
            var p = pixels[y * rowWidth]
            for x in 0..<Int(size.width) {
                let hue = hueFromLong(p)
            }
        }

        guard let cgimage = context.makeImage() else {
            throw ImageError.CantCreateImage
        }
        return UIImage(cgImage: cgimage)
    }
*/

}
