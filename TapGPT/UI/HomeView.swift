//
//  HomeView.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//


import SwiftUI

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
