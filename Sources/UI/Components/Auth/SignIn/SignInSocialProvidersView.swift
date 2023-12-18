//
//  SignInSocialProvidersView.swift
//
//
//  Created by Mike Pitre on 11/2/23.
//

#if canImport(UIKit)

import SwiftUI
import Clerk
import AuthenticationServices

struct SignInSocialProvidersView: View {
    @EnvironmentObject private var clerk: Clerk
    @State private var errorWrapper: ErrorWrapper?
    
    private var thirdPartyProviders: [OAuthProvider] {
        clerk.environment.userSettings.enabledThirdPartyProviders.sorted()
    }
    
    private var signIn: SignIn {
        clerk.client.signIn
    }
    
    var onSuccess:(() -> Void)?
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: .init(.flexible()), count: min(thirdPartyProviders.count, thirdPartyProviders.count <= 2 ? 1 : 6)),
            alignment: .leading,
            content: {
                ForEach(thirdPartyProviders, id: \.self) { provider in
                    AsyncButton {
                        await signIn(provider: provider)
                    } label: {
                        AuthProviderButton(
                            provider: provider,
                            style: thirdPartyProviders.count <= 2 ? .regular : .compact
                        )
                    }
                    .buttonStyle(ClerkSecondaryButtonStyle())
                }
            }
        )
        .clerkErrorPresenting($errorWrapper)
    }
    
    private func signIn(provider: OAuthProvider) async {
        KeyboardHelpers.dismissKeyboard()
        do {
            try await signIn.create(.oauth(provider: provider))
            try await signIn.startOAuth()
            onSuccess?()
        } catch {
            if case ASWebAuthenticationSessionError.canceledLogin = error {
                return
            }
            
            errorWrapper = ErrorWrapper(error: error)
            dump(error)
        }
    }
}

extension SignInSocialProvidersView {
    
    func onSuccess(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSuccess = action
        return copy
    }
    
}

#Preview {
    SignInSocialProvidersView()
        .padding()
        .environmentObject(Clerk.mock)
}

#endif
