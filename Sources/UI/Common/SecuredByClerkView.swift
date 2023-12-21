//
//  SecuredByClerkView.swift
//
//
//  Created by Mike Pitre on 11/29/23.
//

#if canImport(UIKit)

import SwiftUI

struct SecuredByClerkView: View {
    @Environment(\.clerkTheme) private var clerkTheme
    
    var body: some View {
        HStack(spacing: 4) {
            Text("Secured by ")
                .font(.footnote)
                .foregroundStyle(clerkTheme.colors.gray500)
            HStack(spacing: 0) {
                Image("clerk-logomark-gray", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                Image("clerk-name-gray", bundle: .module)
            }
            .font(.subheadline)
        }
    }
}

#Preview {
    SecuredByClerkView()
}

#endif
