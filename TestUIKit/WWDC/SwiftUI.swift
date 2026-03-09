//
//  SwiftUI.swift
//  TestUIKit
//
//  Created by Duck Sern on 22/2/26.
//

import SwiftUI
import Combine

/// View in SwiftUI is lightweight, extract subviews has no runtime overhead
/// View define its dependencies
/// SwiftUI allocate for `State` property
/// Animation is inturrptable
///
/// Use `Group` for multiple Previews
/// Imprative: Build a result by sending explicit command
/// Declarative: Build a result by describe what you want and let someone figure out how to make it for you
///
/// Container syntax: `@ViewBuilder` allow write declarative code in closure
/// Swift compiler turn closure into a another closure with return value
/// Modifer: create a new view from existing view
/// By default SwiftUI fade in out when add or remove view
/// Push condition into modifer => Help SwiftUI detect change and provide better animation
/// If statement when need add or remove different view
/// `ForEach` only add content to container view
/// `Form` same like VStack has sections
/// `Enviroment` inherit from parent => can override in a subtree => use in preview for more
/// `Preference` data flow upward view tree
///  @Binding
///  - Read or write without ownership
///  - Derive from State
///
///  BindableObject need provide a publisher, when property change => send value, SwiftUI subscribe to this publisher => update UI when receive by syntax `@ObjectBinding`
///
///  Layout process
///  - Parent propoeses size for children
///  - Child chooses its own size, parent has to respect result, can not force
///  - Parent places child in parent's coordinate space
///  - SwiftUI rounds coordinates to nearest pixel
///
///  Using background to see view's bounds
///
///  If dev mark image as resizeable either in code or asset, otherwise image has fixed size
///  Frame is not a constraint in swiftUI it just a view, it just propose fixed size to child
///
///  HStack
///  - Minus spacing from propose width
///  - Divide space with children count
///  - Propose from least flexible child ( priority => `layoutPriority` modifer ) min = 0 => with result subtract to width => divide again ( loop to above step )
///  - Take available space minus minum space of lower priority view => propose for higher priority then so on
///  - Default value for last text base line = bottom of view
///  - Custom base line => use `.alignmentGuide` modifer
///
///  Define custom alignment
extension VerticalAlignment {
    private enum MidStarAndTitle: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.bottom]
        }
    }
    
    static let midStarAndTitle = VerticalAlignment(MidStarAndTitle.self)
}

// Align XXX text to centerY align with Toast text
struct AvocadoView: View {
    var body: some View {
        HStack(alignment: .midStarAndTitle) {
            VStack {
                Text("XXXXXX")
                    .alignmentGuide(.midStarAndTitle) { d in d[.bottom] / 2 }
                Text("5 stars")
                
            }
            .font(.caption)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Toast").font(.title)
                        .alignmentGuide(.midStarAndTitle) { d in d[.bottom] / 2 }
                    Spacer()
                }
                Text("Ingendients: xxxx")
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .background(Color.green)
        
        
    }
}

#Preview {
    AvocadoView()
}

/// Conic gradient
/// Custom shape
///
struct WedgeShap: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        return p
    }
    
//    var animatableData: EmptyAnimatableData
}

struct ScaleAndFade: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        return content
            .scaleEffect(isActive ? 0.1 : 1)
            .opacity(isActive ? 0 : 1)
    }
}

let scaleAndFade = AnyTransition.modifier(active: ScaleAndFade(isActive: true), identity: ScaleAndFade(isActive: false))

/// `drawingGroup` flatten SwiftUI view in single UIView => render in Metal

//_UIHostingView(rootView: <#T##View#>)

/// UIViewRepresentableContext
/// init -> makeCoordinator -> makeView -> updateView ( loop updateView ) -> dismantle
/// use Coordinator as reference type to implement target/action, delegate as bridge between SwiftUI View and UIKit ( why?: SwiftUI View is struct => create many time, coordinator is class and perfect for target action, when SwiftUI View recreate => selector is remove)
///
/// NSItemProvider: tranfer data between process
/// `focusable` => SwiftUIView can gain focus, has closure to update UI
///
