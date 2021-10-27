// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum FieldValidation {
    internal enum Error {
      /// Must be the same as password
      internal static let confirmPassword = L10n.tr("Localizable", "FieldValidation.Error.ConfirmPassword")
      /// Shouldn't be empty
      internal static let empty = L10n.tr("Localizable", "FieldValidation.Error.Empty")
      /// Invalid email
      internal static let invalidEmail = L10n.tr("Localizable", "FieldValidation.Error.InvalidEmail")
      /// Should equal or more than 6 characters
      internal static let shortPassword = L10n.tr("Localizable", "FieldValidation.Error.ShortPassword")
    }
  }

  internal enum General {
    internal enum Action {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "General.Action.Cancel")
      /// OK
      internal static let ok = L10n.tr("Localizable", "General.Action.Ok")
    }
  }

  internal enum Post {
    internal enum Error {
      /// Invalid data
      internal static let encode = L10n.tr("Localizable", "Post.Error.Encode")
      /// Unable to fetch. Please try again later
      internal static let fetch = L10n.tr("Localizable", "Post.Error.Fetch")
      /// Invalid image. Please select a valid image
      internal static let image = L10n.tr("Localizable", "Post.Error.Image")
      /// Unable to post. Please try again later
      internal static let post = L10n.tr("Localizable", "Post.Error.Post")
      /// Unknown error occurred
      internal static let unknown = L10n.tr("Localizable", "Post.Error.Unknown")
      /// Unable to upload. Please try again later
      internal static let upload = L10n.tr("Localizable", "Post.Error.Upload")
    }
    internal enum Status {
      /// Posting...
      internal static let posting = L10n.tr("Localizable", "Post.Status.Posting")
      /// Uploading...
      internal static let uploading = L10n.tr("Localizable", "Post.Status.Uploading")
    }
  }

  internal enum Profile {
    internal enum Error {
      /// Unable to fetch profile. Please try again later
      internal static let fetch = L10n.tr("Localizable", "Profile.Error.Fetch")
      /// Profile doesn't exist
      internal static let noUser = L10n.tr("Localizable", "Profile.Error.NoUser")
    }
    internal enum Photo {
      /// Add Photo
      internal static let add = L10n.tr("Localizable", "Profile.Photo.Add")
      /// Change Photo
      internal static let change = L10n.tr("Localizable", "Profile.Photo.Change")
      /// Profile Photo
      internal static let title = L10n.tr("Localizable", "Profile.Photo.Title")
    }
    internal enum Update {
      internal enum Status {
        /// Updating...
        internal static let updating = L10n.tr("Localizable", "Profile.Update.Status.Updating")
        /// Uploading...
        internal static let uploading = L10n.tr("Localizable", "Profile.Update.Status.Uploading")
      }
    }
  }

  internal enum ResetPassword {
    /// Please check your mailbox for further instruction
    internal static let sentEmail = L10n.tr("Localizable", "ResetPassword.SentEmail")
  }

  internal enum SignUp {
    internal enum Error {
      /// Please accept terms to continue
      internal static let agreeTerms = L10n.tr("Localizable", "SignUp.Error.AgreeTerms")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
