// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum SignUp {
    /// Créer un compte
    internal static let createAccountButton = L10n.tr("localizable", "signUp.CreateAccountButton")
    /// Email
    internal static let mail = L10n.tr("localizable", "signUp.mail")
    /// Mot de passe
    internal static let password = L10n.tr("localizable", "signUp.password")
    /// Confirmation de mot de passe
    internal static let passwordConfirmation = L10n.tr("localizable", "signUp.passwordConfirmation")
  }

  internal enum UserAuthentication {
    internal enum Button {
      /// Se connecter
      internal static let login = L10n.tr("localizable", "userAuthentication.button.login")
      /// Vous n'avez pas encore de compte ?
      /// Cliquez ici pour vous inscrire
      internal static let register = L10n.tr("localizable", "userAuthentication.button.register")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
