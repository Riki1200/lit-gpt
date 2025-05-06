//
//  TabView.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//

import SwiftUI
import SwiftData


struct MainTabbedView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedSideMenuTab) {
                HomeView(presentSideMenu: $presentSideMenu, navigateIndex: $selectedSideMenuTab)
                    .tag(0)
                ChatView(
                    model: Model(),
                    context: modelContext,
                    presentSideMenu: $presentSideMenu
                ).tag(1)
                


            }

        
            SideMenu(isShowing: $presentSideMenu,
                     content: AnyView(SideMenuView(
                            selectedSideMenuTab: $selectedSideMenuTab,
                            presentSideMenu: $presentSideMenu
                     )
                )
            )
        }
    }
}


enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case chat
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .chat:
            return "Chat"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home"
        case .chat:
            return "chat"

        }
    }
}
