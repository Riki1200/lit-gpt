//
//  SideMenu.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//

import SwiftUI
import SwiftData

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
