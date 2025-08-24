#  App Navigation

```swift

// Your app routes
enum TestNavigationRoute: NavigationRoute, CaseIterable {
    
    case settings
    case profile
    
    var id: String {
        switch self {
        case .settings: return "core.settings"
        case .profile: return "core.profile"
        }
    }
    
    var destination: some View {
        switch self {
        case .settings: return Text("Settings destination")
        case .profile: return Text("Profile destination")
        }
    }
}

// create a routing engine
// this is likely the central instance in your app root 
// which you will use to register your routes

var routing = NavigationRouting()

// create a testRouter per app as needed
var testRouter = NavigationRouter<TestNavigationRoute, AnyView>(name: "testing")

// add routes with all cases 
testRouter.addAll(from: TestNavigationRoute.self)

// or use the builder approach to add individually
let testRouter = testRouter
    .add(TestNavigationRoute.settings)
    .add(TestNavigationRoute.profile)


// register testRouter on routing engine
try routing.register(testRouter)

```

