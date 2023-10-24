//
//  ExamplesListView.swift
//  ClerkExample
//
//  Created by Mike Pitre on 10/6/23.
//

#if canImport(UIKit)

import SwiftUI
import Clerk
import ClerkUI

struct ExamplesListView: View {
    @EnvironmentObject private var clerk: Clerk
        
    var body: some View {
        NavigationStack {
            List {
                Section("Components") {
                    Button {
                        clerk.presentedAuthStep = .signInCreate
                    } label: {
                        Text("Sign In")
                    }
                    
                    Button {
                        clerk.presentedAuthStep = .signUpCreate
                    } label: {
                        Text("Sign Up")
                    }
                }
                
                #if DEBUG
                Section("Settings") {
                    Button {
                        Task { try? await clerk.client.get() }
                    } label: {
                        Text("Get Client")
                    }
                    
                    Button {
                        Task { try? await clerk.client.destroy() }
                    } label: {
                        Text("Delete Client")
                    }

                    Button {
                        Clerk.deleteRefreshToken()
                    } label: {
                        Text("Delete Refresh Token")
                    }
                }
                #endif
            }
            .navigationTitle("Clerk Examples")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    UserButton()
                }
            }
        }
    }
}

#Preview {
    ExamplesListView()
        .environmentObject(Clerk.mock)
}

#endif


