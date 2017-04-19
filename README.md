# DeeplinkNavigator

## Supported formats

`UUID`: "myapp://\<UUID:uuid\>/" ||  "myapp://123e4567-e89b-12d3-a456-426655440000"

`string`: "myapp://\<string:greeting\>/" or "myapp://greeting/" *default is string* ||  "myapp://hello world/"

`int`: "myapp://\<int:uid\>/" || "myapp://12345/"

`float`: "myapp://\<float:width\>/" || "myapp://480/"

`path`: "https://\<path:website\>/" || "https://www.google.com/"

`action`: "myapp://\<action:loadMoreContent\>/" || "myapp://action:userdetail/loadMoreContent/"

## How to use

Note: LHWURLConvertible is a protocol that URL and String conforms.
Note: Global constant Navigator is a shortcut for LHWURLNavigator.default.

#### 1. Mapping URL Patterns

```
Navigator.map("myapp://userdetail/\<int:uid\>", SomeViewController.self)
Navigator.map("myapp://userdetail/\<title\>", SomeViewController.self) // default is string
Navigator.map("myapp://userdetail/\<action:\_\>", SomeViewController.self) // _ means no placeholder for name

Navigator.map("myapp://alert") { url, values in
  print(url.queryParameters["title"])
  print(url.queryParameters["message"])
  return true
}
```

#### 2. Pushing, Presenting and Opening URLs

```
Navigator.push("myapp://userdetail/123")
Navigator.present("myapp://userdetail/54321", wrap: true)
Navigator.push("myapp://userdetail/action:loadMoreContent/")
Navigator.open("myapp://alert?title=Hello&message=World")
```

#### 3. Implementing LHWURLNavigable protocol

```
class TestViewController: UIViewController, LHWURLNavigable {
    var initialAction: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience required init?(url: LHWURLConvertible,
                               values: [String: Any],
                               queries: [URLQueryItem]?,
                               userInfo: [AnyHashable: Any]?) {
        self.init()
        if let action = values["action"] as? String {
            initialAction = action
        }
        print("Received action: \(String(describing: initialAction)), queries: \(String(describing: queries))")
    }
}
```

## Handle open app event

```
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
