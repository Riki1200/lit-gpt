//
//  ContentView.swift
//  TapGPT
//
//  Created by Romeo Betances on 12/4/25.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    
    @Binding var presentSideMenu: Bool
    @Binding var navigateIndex: Int
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image(systemName: "rectangle.portrait.lefthalf.filled")
                        .resizable()
                
                        .frame(width: 20, height: 20)
                }
                Spacer()
            }
            
            Spacer()
            Text("Welcome to local AI chat app")
            Button {
                navigateIndex = 1
            } label: {
                Text("Start chat with GPT")
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct SideMenu: View {
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    
                    .background(.clear)
                    .transition(edgeTransition)
                  
            }
        }
       
        .animation(.easeInOut, value: isShowing)
    }
}


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

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext


    var body: some View {
      
        MainTabbedView(modelContext: modelContext)
        
    }

  
}

struct SideMenuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        HStack {
            ZStack{
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color(.secondarySystemBackground)
                )
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
            HStack{
                
                Spacer()
                Image(systemName: "text.bubble.badge.clock.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                Spacer()
            }
            
            Text("LitGPT")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
    
        }
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
              
                    
                    ZStack{
                        Image(imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .primary : .secondary)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            isSelected
            ? Color.accentColor.opacity(0.2)
            : Color.clear
        )
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
