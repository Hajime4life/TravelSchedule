import Foundation

let apiKey = "9995803a-ea85-45dd-8f60-d8ae279985d8"

enum NetworkError: Error, Equatable {
    case noInternet
    case serverError
}
