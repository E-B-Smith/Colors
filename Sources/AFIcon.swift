//
//  AFIcon.swift
//  Colors
//
//  Created by Stephanie Lee on 4/28/21.
//

import Foundation
import UIKit

enum ColorScheme: Equatable {
    case grayscale
    case inverse
    case primary
    case destructive
    case custom(primary: UIColor, light: UIColor, dark: UIColor)

    var string: String {
        switch self {
        case .grayscale: return "grayscale"
        case .inverse: return "inverse"
        case .primary: return "primary"
        case .destructive: return "destructive"
        case .custom(_, _, _): return "custom"
        }
    }
}

enum ColorShade: CaseIterable {
    case primary
    case light
    case dark
}

enum AFIcon {
    static func named(_ name: String, scheme: ColorScheme) -> UIImage {
        let image = UIImage(named: name)!

        let updatedImage = replaceColors(for: image, scheme: scheme)
        return updatedImage
    }

    private static func replaceColors(for image: UIImage, scheme: ColorScheme) -> UIImage {
        // the default color scheme for an icon is .grayscale
        guard scheme != .grayscale else {
            return image
        }

        var colorMap: [(UIColor, UIColor)] = []

        for shade in ColorShade.allCases {
            let colorPair = (UIColor.color(for: .grayscale, type: shade), UIColor.color(for: scheme, type: shade))
            colorMap.append(colorPair)
        }

        if let modifiedImage = try? image.replace(colors: colorMap, tolerance: 0.017) {
            return modifiedImage
        } else {
            return image
        }
    }
}

extension UIColor {
    static func color(for scheme: ColorScheme, type: ColorShade) -> UIColor {
        var hexCode: String = ""
        switch (scheme, type) {
        case (.grayscale, .primary): hexCode = "909293"
        case (.grayscale, .light): hexCode = "D4D6D7"
        case (.grayscale, .dark): hexCode = "6D6E71"
        case (.inverse, .primary): hexCode = "D4D6D7"
        case (.inverse, .light): hexCode = "FFFFFF"
        case (.inverse, .dark): hexCode = "A4A6A7"
        case (.primary, .primary): hexCode = "4A4AF4"
        case (.primary, .light): hexCode = "A8A9FC"
        case (.primary, .dark): hexCode = "2F2FC1"
        case (.destructive, .primary): hexCode = "FF6D50"
        case (.destructive, .light): hexCode = "FEAA97"
        case (.destructive, .dark): hexCode = "D34333"
        case (.custom(let primary, _, _), .primary): return primary
        case (.custom(_, let light, _), .light): return light
        case (.custom(_, _, let dark), .dark): return dark
        }

        return UIColor(fromHex: hexCode)
    }

    convenience init(fromHex hexString: String) {
         let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
         var int = UInt64()
         Scanner(string: hex).scanHexInt64(&int)
         let a, r, g, b: UInt64
         switch hex.count {
         case 3: // RGB (12-bit)
             (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
         case 6: // RGB (24-bit)
             (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
         case 8: // ARGB (32-bit)
             (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
         default:
             (a, r, g, b) = (255, 0, 0, 0)
         }
         self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
     }
}
