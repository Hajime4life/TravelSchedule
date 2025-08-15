import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkClient {
    private let apiKey: String
    private let client: Client

    init(
        apiKey: String = Constants.apiKey,
        client: Client = Client( // не знаю где еще это делать
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    ) {
        self.apiKey = apiKey
        self.client = client
    }

    func getCopyrightInfo() async throws -> CopyrightResponse {
        let response = try await client.getCopyrightInfo(query: .init(apikey: apiKey))
        return try response.ok.body.json
    }

    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apiKey, code: code))
        return try response.ok.body.json
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(apikey: apiKey, lat: lat, lng: lng))
        return try response.ok.body.json
    }
    
    func getNearestStations(
        lat: Double,
        lng: Double,
        distance: Int
    ) async throws -> StationsResponse {
        let response = try await client.getNearestStations(
            query: .init(
                apikey: apiKey,
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try response.ok.body.json
    }
    
    func getSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(apikey: apiKey, station: station))
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "HH:mm"
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Дата \(dateString) не соответствует формату HH:mm")
        }
        
        return try decoder.decode(ScheduleResponse.self, from: try JSONEncoder().encode(response.ok.body.json))
    }
    
    func search(
        from: String,
        to: String,
        transfers: Bool = true
    ) async throws -> SegmentsResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        do {
            let response = try await client.getSchedualBetweenStations(query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                date: todayString,
                transfers: transfers
            ))
            return try response.ok.body.json
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.noInternet
        } catch {
            throw NetworkError.serverError
        }
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        do {
            let response = try await client.getAllStations(query: .init(apikey: apiKey, transportType: "train"))
            let responseBody = try response.ok.body.html
            let limit = 50 * 1024 * 1024
            let fullData = try await Data(collecting: responseBody, upTo: limit)
            let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
            return allStations
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.noInternet
        } catch {
            throw NetworkError.serverError
        }
    }
    
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(query: .init(apikey: apiKey, uid: uid))
        return try response.ok.body.json
    }
}
