// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#25272a"></span>
  /// Alpha: 100% <br/> (0x25272aff)
  internal static let tabBarBackdrop = ColorName(rgbaValue: 0x25272aff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#161819"></span>
  /// Alpha: 100% <br/> (0x161819ff)
  internal static let tabBarHighlightBackdrop = ColorName(rgbaValue: 0x161819ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  internal static let tabBarHighlightIcon = ColorName(rgbaValue: 0xffffffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#a5a5a5"></span>
  /// Alpha: 100% <br/> (0xa5a5a5ff)
  internal static let tabBarIcon = ColorName(rgbaValue: 0xa5a5a5ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#115688"></span>
  /// Alpha: 100% <br/> (0x115688ff)
  internal static let tabBarSpecialBackdrop = ColorName(rgbaValue: 0x115688ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#161819"></span>
  /// Alpha: 100% <br/> (0x161819ff)
  internal static let tabBarSpecialHighlightBackdrop = ColorName(rgbaValue: 0x161819ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  internal static let tabBarSpecialHighlightIcon = ColorName(rgbaValue: 0xffffffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  internal static let tabBarSpecialIcon = ColorName(rgbaValue: 0xffffffff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
