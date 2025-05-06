//
//  SideMenuView.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//

import Foundation
import SwiftUI


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
