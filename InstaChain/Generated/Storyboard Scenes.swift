// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Auth: StoryboardType {
    internal static let storyboardName = "Auth"

    internal static let forgotPasswordViewController = SceneType<InstaChain.ForgotPasswordViewController>(storyboard: Auth.self, identifier: "ForgotPasswordViewController")

    internal static let loginViewController = SceneType<InstaChain.LoginViewController>(storyboard: Auth.self, identifier: "LoginViewController")

    internal static let signupViewController = SceneType<InstaChain.SignupViewController>(storyboard: Auth.self, identifier: "SignupViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<InstaChain.HomeViewController>(storyboard: Main.self)

    internal static let editProfileViewController = SceneType<InstaChain.EditProfileViewController>(storyboard: Main.self, identifier: "EditProfileViewController")

    internal static let homeViewController = SceneType<InstaChain.HomeViewController>(storyboard: Main.self, identifier: "HomeViewController")

    internal static let postViewController = SceneType<InstaChain.PostViewController>(storyboard: Main.self, identifier: "PostViewController")

    internal static let profileViewController = SceneType<InstaChain.ProfileViewController>(storyboard: Main.self, identifier: "ProfileViewController")

    internal static let settingsViewController = SceneType<InstaChain.SettingsViewController>(storyboard: Main.self, identifier: "SettingsViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
