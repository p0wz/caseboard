import SwiftUI

public struct CaseboardAppView: View {
    public init() {}

    public var body: some View {
        CaseboardRootView()
    }
}

#if os(iOS)
@main
struct CaseboardApp: App {
    var body: some Scene {
        WindowGroup {
            CaseboardRootView()
        }
    }
}
#endif
