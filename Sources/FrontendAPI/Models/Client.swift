//
//  Client.swift
//
//
//  Created by Mike Pitre on 10/2/23.
//

import Foundation

/**
 The Client object keeps track of the authenticated sessions in the current device. The device can be a browser, a native application or any other medium that is usually the requesting part in a request/response architecture.
 The Client object also holds information about any sign in or sign up attempts that might be in progress, tracking the sign in or sign up progress.
 */
public struct Client: Decodable {
    
    init(
        signIn: SignIn = SignIn(),
        signUp: SignUp = SignUp(),
        sessions: [Session] = [],
        lastActiveSessionId: String? = nil
    ) {
        self.signIn = signIn
        self.signUp = signUp
        self.sessions = sessions
        self.lastActiveSessionId = lastActiveSessionId
    }
    
    internal(set) public var signIn: SignIn
    internal(set) public var signUp: SignUp
    internal(set) public var sessions: [Session]
    internal(set) public var lastActiveSessionId: String?
    
    enum CodingKeys: CodingKey {
        case signIn
        case signUp
        case sessions
        case lastActiveSessionId
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Client.CodingKeys> = try decoder.container(keyedBy: Client.CodingKeys.self)
        
        // SignUp and SignIn can have null values when returned from the server, but should never be nil on the client
        self.signIn = try container.decodeIfPresent(SignIn.self, forKey: Client.CodingKeys.signIn) ?? SignIn()
        self.signUp = try container.decodeIfPresent(SignUp.self, forKey: Client.CodingKeys.signUp) ?? SignUp()
        //
        self.sessions = try container.decode([Session].self, forKey: .sessions)
        self.lastActiveSessionId = try container.decodeIfPresent(String.self, forKey: .lastActiveSessionId)
    }
}

extension Client {
    
    public var lastActiveSession: Session? {
        sessions.first(where: { $0.id == lastActiveSessionId })
    }
    
}

extension Client {
    
    /// Retrieves the current client.
    @MainActor
    public func get() async throws {
        let request = APIEndpoint
            .v1
            .client
            .get
        
        Clerk.shared.client = try await Clerk.apiClient.send(request).value.response ?? Client()
    }
    
    /// Creates a new client for the current instance along with its cookie.
    @MainActor
    public func create() async throws {
        let request = APIEndpoint
            .v1
            .client
            .put
        
        Clerk.shared.client = try await Clerk.apiClient.send(request).value.response
    }
    
    /// Deletes the client. All sessions will be reset.
    @MainActor
    public func destroy() async throws {
        let request = APIEndpoint
            .v1
            .client
            .delete
        
        try await Clerk.apiClient.send(request)
        Clerk.shared.client = Client()
    }
    
}
