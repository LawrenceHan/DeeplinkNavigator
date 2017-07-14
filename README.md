DeeplinkNavigator
============

### Thanks for [devxoul](https://github.com/devxoul), this project is based & inspried on his effort.

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)

DeeplinkNavigator can be used for mapping URL patterns with 2 kind of types: `DeeplinkNavigable` and `DeeplinkOpenHandler`. `DeeplinkNavigable` is a protocol which has 2 sub-protocols: `StoryboardNavigable`, `InitNavigable` (default init method for viewController). `DeeplinkOpenHandler` is a closure which can be executed. Both an initializer and a closure receive an URL and placeholder values.

Getting Started
---------------

#### 1. Mapping URL Patterns

URL patterns can contain placeholders. Placeholders will be replaced with matching values from URLs. Use `<` and `>` to make placeholders. Placeholders can have types: `string`(default), `int`, `float`, and `path`.

Here's an example of mapping URL patterns with view controllers and a closure. View controllers should conform a protocol `DeeplinkNavigable` to be mapped with URL patterns. 

```swift
Navigator.map("myapp://user/<int:id>", UserViewController.self)
Navigator.map("myapp://post/<title>", PostViewController.self)

Navigator.map("myapp://alert") { url, values in
  print(url.queryParameters["title"])
  print(url.queryParameters["message"])
  return true
}
```

> **Note**: Global constant `Navigator` is a shortcut for `DeeplinkNavigator.default`.

#### 2. Pushing, Presenting and Opening URLs

DeeplinkNavigator can push and present view controllers and execute closures with URLs.

Provide the `from` parameter to `push()` to specify the `DeeplinkPushable` which the new view controller will be pushed. Similarly, provide the `from` parameter to `present()` to specify the `DeeplinkPresentable` which the new view controller will be presented. If the `nil` is passed, which is a default value, current application's top most view controller will be used to push or present view controllers.

`present()` takes an extra parameter: `wrap`. If `true` is specified, the new view controller will be wrapped with a `UINavigationController`. Default value is `false`.

```swift
Navigator.push("myapp://user/123")
Navigator.present("myapp://post/54321", wrap: true)

Navigator.open("myapp://alert?title=Hello&message=World")
```

#### 3. Implementing DeeplinkNavigable

View controllers should conform a protocol `DeeplinkNavigable` to be mapped with URLs. A protocol `DeeplinkNavigable` defines 2 initialization protocols: `StoryboardNavigable`, `InitNavigable` with parameter `navigation` which contains `url`, `values`, `mappingContext` and `navigationContext` as properties.

Property `url` is an URL that is passed from `DeeplinkNavigator.push()` and `DeeplinkNavigator.present()`. Parameter `values` is a dictionary that contains URL placeholder keys and values. Parameter `mappingContext` is a context passed from a `map()` function. Parameter `navigationContext` is a dictionary which contains extra values passed from `push()` or `present()`.

```swift
final class StoryboardViewController: UIViewController {
}

extension StoryboardViewController: StoryboardNavigable {
    static func viewControllerFromStoryBoard(navigation: DeeplinkNavigation) -> UIViewController? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: String(describing: self))
        return vc
    }
}

final class XibViewController: UIViewController {
}

extension XibViewController: InitNavigable {
    convenience init?(navigation: DeeplinkNavigation) {
        self.init()
    }
}

final class InitViewController: UIViewController {
}

extension InitViewController: InitNavigable {
    convenience init?(navigation: DeeplinkNavigation) {
        self.init()
    }
}
```

Installation
------------

- [CocoaPods](https://cocoapods.org):

    ```ruby
    pod 'DeeplinkNavigator'
    ```

- [Carthage](https://github.com/Carthage/Carthage):

    ```
    github "LawrenceHan/DeeplinkNavigator"
    ```

Tips and Tricks
---------------

#### Where to Map URLs

I'd prefer using separated URL map file.

```swift
struct NavigationMap {

  static func initialize() {
    Navigator.map("myapp://user/<int:id>", UserViewController.self)
    Navigator.map("myapp://post/<title>", PostViewController.self)

    Navigator.map("myapp://alert") { url, values in
      print(url.queryParameters["title"])
      print(url.queryParameters["message"])
      self.someUtilityMethod()
      return true
    }
  }

  private static func someUtilityMethod() {
    print("This method is really useful")
  }

}
```

Then call `initialize()` at `AppDelegate`'s `application:didFinishLaunchingWithOptions:`.

```swift
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    // Navigator
    URLNavigationMap.initialize()
    
    // Do something else...
  }
}
```


#### Passing UIView to `push()` or `present()`

>
Sometime you having a mutiple windows hierarchy situation, you can pass a UIView object
and let DeeplinkNavigator to find the right `UINavigationController` or `UIViewController`
for you.

```swift
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        Navigator.push("myapp://test", from: cell, animated: true)
    }
```


#### Using `pushOrPopTo` extenstion

>
You want to push a viewController, but you also want to pop to that viewController if it
exist already.

```swift
Navigator.popTo("myapp://user")
Navigator.pushOrPopTo("myapp://user/10")
```


#### Implementing AppDelegate Launch Option URL

It's available to open your app with URLs if custom schemes are registered. In order to navigate to view controllers with URLs, you'll have to implement `application:didFinishLaunchingWithOptions:` method.

```swift
func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
) -> Bool {
  // ...
  if let url = launchOptions?[.url] as? URL {
    if let opened = Navigator.open(url)
    if !opened {
      Navigator.push(url)
    }
  }
  return true
}

```


#### Implementing AppDelegate Open URL Method

You'll might want to implement custom URL open handler. Here's an example of using DeeplinkNavigator with other URL open handlers.

```swift
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
  // If you're using Facebook SDK
  let fb = FBSDKApplicationDelegate.sharedInstance()
  if fb.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
    return true
  }

  // DeeplinkNavigator Handler
  if Navigator.open(url) {
    return true
  }

  // DeeplinkNavigator View Controller
  if Navigator.present(url, wrap: true) != nil {
    return true
  }

  return false
}
```


#### Setting Default Scheme

Set `scheme` property on `DeeplinkNavigator` instance to get rid of schemes in every URLs.

```swift
Navigator.scheme = "myapp"
Navigator.map("/user/<int:id>", UserViewController.self)
Navigator.push("/user/10")
```

This is totally equivalent to:

```swift
Navigator.map("myapp://user/<int:id>", UserViewController.self)
Navigator.push("myapp://user/10")
```

Setting `scheme` property will not affect other URLs that already have schemes.

```swift
Navigator.scheme = "myapp"
Navigator.map("/user/<int:id>", UserViewController.self) // `myapp://user/<int:id>`
Navigator.map("http://<path>", MyWebViewController.self) // `http://<path>`
```


#### Passing Context when Mapping

```swift
let context = Foo()
Navigator.map("myapp://user/10", UserViewController.self, context: context)
```


#### Passing Extra Values when Pushing or Presenting

```swift
let context: [AnyHashable: Any] = [
  "fromViewController": self
]
Navigator.push("myapp://user/10", context: context)
Navigator.present("myapp://user/10", context: context)
```


License
-------

DeeplinkNavigator is under MIT license. See the [LICENSE](LICENSE) file for more info.
