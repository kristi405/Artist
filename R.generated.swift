//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.segue` struct is generated, and contains static references to 3 view controllers.
  struct segue {
    /// This struct is generated for `EventVC`, and contains static references to 2 segues.
    struct eventVC {
      /// Segue identifier `showMap`.
      static let showMap: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, EventVC, MapEvents> = Rswift.StoryboardSegueIdentifier(identifier: "showMap")
      /// Segue identifier `showWeb`.
      static let showWeb: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, EventVC, WebViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showWeb")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `showMap`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showMap(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, EventVC, MapEvents>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.eventVC.showMap, segue: segue)
      }
      #endif

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `showWeb`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showWeb(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, EventVC, WebViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.eventVC.showWeb, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    /// This struct is generated for `FavoriteArtist`, and contains static references to 1 segues.
    struct favoriteArtist {
      /// Segue identifier `showEvent`.
      static let showEvent: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, FavoriteArtist, EventVC> = Rswift.StoryboardSegueIdentifier(identifier: "showEvent")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `showEvent`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showEvent(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, FavoriteArtist, EventVC>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.favoriteArtist.showEvent, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    /// This struct is generated for `SearchViewController`, and contains static references to 1 segues.
    struct searchViewController {
      /// Segue identifier `showWebView`.
      static let showWebView: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, SearchViewController, WebViewController> = Rswift.StoryboardSegueIdentifier(identifier: "showWebView")

      #if os(iOS) || os(tvOS)
      /// Optionally returns a typed version of segue `showWebView`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showWebView(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, SearchViewController, WebViewController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.searchViewController.showWebView, segue: segue)
      }
      #endif

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 2 colors.
  struct color {
    /// Color `BackgroundColor`.
    static let backgroundColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "BackgroundColor")
    /// Color `Color`.
    static let color = Rswift.ColorResource(bundle: R.hostingBundle, name: "Color")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "BackgroundColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func backgroundColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.backgroundColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Color", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func color(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.color, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "BackgroundColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func backgroundColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.backgroundColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Color", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func color(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.color.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 10 images.
  struct image {
    /// Image `cancel`.
    static let cancel = Rswift.ImageResource(bundle: R.hostingBundle, name: "cancel")
    /// Image `goOver`.
    static let goOver = Rswift.ImageResource(bundle: R.hostingBundle, name: "goOver")
    /// Image `heart`.
    static let heart = Rswift.ImageResource(bundle: R.hostingBundle, name: "heart")
    /// Image `pinMap-1`.
    static let pinMap1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "pinMap-1")
    /// Image `redHeart1`.
    static let redHeart1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "redHeart1")
    /// Image `redHeart`.
    static let redHeart = Rswift.ImageResource(bundle: R.hostingBundle, name: "redHeart")
    /// Image `route`.
    static let route = Rswift.ImageResource(bundle: R.hostingBundle, name: "route")
    /// Image `search`.
    static let search = Rswift.ImageResource(bundle: R.hostingBundle, name: "search")
    /// Image `update`.
    static let update = Rswift.ImageResource(bundle: R.hostingBundle, name: "update")
    /// Image `whHeart`.
    static let whHeart = Rswift.ImageResource(bundle: R.hostingBundle, name: "whHeart")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "cancel", bundle: ..., traitCollection: ...)`
    static func cancel(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cancel, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "goOver", bundle: ..., traitCollection: ...)`
    static func goOver(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.goOver, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "heart", bundle: ..., traitCollection: ...)`
    static func heart(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.heart, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "pinMap-1", bundle: ..., traitCollection: ...)`
    static func pinMap1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.pinMap1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "redHeart", bundle: ..., traitCollection: ...)`
    static func redHeart(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.redHeart, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "redHeart1", bundle: ..., traitCollection: ...)`
    static func redHeart1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.redHeart1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "route", bundle: ..., traitCollection: ...)`
    static func route(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.route, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "search", bundle: ..., traitCollection: ...)`
    static func search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.search, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "update", bundle: ..., traitCollection: ...)`
    static func update(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.update, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "whHeart", bundle: ..., traitCollection: ...)`
    static func whHeart(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.whHeart, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `FavoriteCell`.
    static let favoriteCell: Rswift.ReuseIdentifier<FavoriteCell> = Rswift.ReuseIdentifier(identifier: "FavoriteCell")
    /// Reuse identifier `cell`.
    static let cell: Rswift.ReuseIdentifier<EventCell> = Rswift.ReuseIdentifier(identifier: "cell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController

      let bundle = R.hostingBundle
      let eventVC = StoryboardViewControllerResource<EventVC>(identifier: "EventVC")
      let name = "Main"

      func eventVC(_: Void = ()) -> EventVC? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: eventVC)
      }

      static func validate() throws {
        if UIKit.UIImage(named: "heart", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'heart' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "pinMap-1", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'pinMap-1' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "route", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'route' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "search", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'search' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "BackgroundColor", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'BackgroundColor' is used in storyboard 'Main', but couldn't be loaded.") }
        }
        if _R.storyboard.main().eventVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'eventVC' could not be loaded from storyboard 'Main' as 'EventVC'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
