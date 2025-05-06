//
//  Extension.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//
import Foundation
import SwiftUI


extension String {
    func cleanedLLMOutput() -> String {
        self.replacingOccurrences(of: "<\\|im_start\\|>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "<\\|im_end\\|>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "<\\|assistant\\|>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "<\\|user\\|>", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}



extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
