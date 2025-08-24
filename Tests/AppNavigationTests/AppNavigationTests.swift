import Testing
import SwiftUI
@testable import AppNavigation



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


@Suite("Navigation View Model Tests")
@MainActor
struct NavigationViewModelTests {
    
    var viewModel = NavigationViewModelFactory.create()
    
    @Test("Initial path is empty")
    func testInitialPathIsEmpty() async throws {
        #expect(viewModel.path.isEmpty)
    }

    @Test("Navigate to route appends to path")
    func testNavigateToAppendsToPath() async throws {
        let route = AnyNavigationRoute(TestNavigationRoute.profile, domain: "testing")
        viewModel.navigateTo(route)
        #expect(!viewModel.path.isEmpty)
    }

    @Test("Go back removes from path")
    func testGoBackRemovesFromPath() async throws {
        let route = AnyNavigationRoute(TestNavigationRoute.profile, domain: "testing")
        viewModel.navigateTo(route)
        viewModel.goBack()
        #expect(viewModel.path.isEmpty)
    }

//    @Test("Save and restore session")
//    func testSaveAndRestoreSession() async throws {
//        @MainActor class InMemoryVM: LegacyNavigationViewModel {
//            static var savedData: Data?
//            override class func writeSerializedData(_ data: Data) { savedData = data }
//            override class func readSerializedData() -> Data? { savedData }
//        }
//        let route = TestRoute(id: "persist")
//        let vm = InMemoryVM()
//        await MainActor.run { vm.navigateTo(route) }
//        await MainActor.run { vm.saveSession() }
//        let restored = InMemoryVM()
//        await MainActor.run { restored.restoreSession() }
//        #expect(!restored.path.isEmpty)
//    }
}
