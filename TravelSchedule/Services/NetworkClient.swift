import Foundation

actor NetworkClient {
    private let apiKey: String = Constants.apiKey
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

}
