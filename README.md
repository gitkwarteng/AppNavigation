#  App Navigation
This is a simple package to help perform programatic navigation in your app.

## Basic Implementation 

Defining your routes with destination

All cases in destination must return the same type, so wrap your views with `AnyView`

```swift

// Your app routes
enum TestNavigationRoute: NavigationRoute {
    
    case settings
    case profile
    case detailProfile(
    
    var id: String {
        switch self {
        case .settings: return "test.settings"
        case .profile: return "test.profile"
        case .detail
        }
    }
    
    var destination: some View {
        switch self {
        case .settings: return AnyView(Text("Settings destination"))
        case .profile: return AnyView(Text("Profile destination"))
        }
    }
}
```

## Complex routes with data

For routes with data you can use any data of choice. 
But if you are like me who sometimes need to pass binding to some state properties 
from the calling site and also perform some matchedGeometry animations, there's
a helper struct to help bundle all together.

```swift

// Define struct to be used inside your view
struct EditProfileConfig:ViewConfig {
    
    var isEditing:Bool = false
    var isScrolling: Bool = false

}

// Instantiate config in your view 
@State var config:EditProfileConfig = .init()


// Define your route with data.
enum TestNavigationRoute: NavigationRoute {
    
    typealias ProfileEditData = NavigationData<Profile, EditProfileConfig>
    
    ...
    case detailProfile(Profile) // route with regular data
    case editProfile(ProfileEditData) // route with complex data
    
    var id: String {
        switch self {
        ...
        case .detailProfile: return "test.profile.detail"
        case .editProfile: return "test.profile.edit"
        }
    }
    
    var destination: some View {
        switch self {
        ...
        case .detailProfile(let profile): return AnyView(ProfileDetailView(profile:profile))
        case .editProfile(let data): return AnyView(EditProfileView(profile:data.value, config:data.config, namespace:data.namespace))
        }
    }
}
```

If you don't want to associate value, config and namespace with your routes,
You can use other convenience methods to associate variations.
- `NavigationDataValue` will give you only data
- `NavigationDataWithConfig` gives you data with a config
- `NavigationDataWithNamespace` gives you data with namespace.

## Performing navigation

To perform navigation from your views, we have to options

1. `navigateTo` environment variable
You can access this from the environment and pass to it an instance of `AnyNavigationRoute`.

```swift

// Get environment variable
@Environment(\.navigateTo) var navigateTo

// use the environment variable with an instance of AnyNavigationRoute
// AR is a typealias to AnyNavigationRoute
navigateTo(AR(TestNavigationRoute.settings))

```
2. Use `NavigationLink(value:label)` to push view

```swift

    NavigationLink(
        value: AR(TestRoutes.profile)
    ) {
        ProfileListItemView()
    }

```

3. Finally, use `AppNavigationView(content:)` to host your views and perform navigation.

```swift
    AppNavigationView {
        ContentView()
    }
```

`AppNavigationView` injects the `navigateTo(_)` into the environment of the ContentView to be accessible in child views.
If you want to add navigation title to your view, the modifier should either be applied to the `ContentView` or  a sub view in `ContentView`.

You can also use the `goBack` enviroment variable to pop a view off the navigation stack. 
