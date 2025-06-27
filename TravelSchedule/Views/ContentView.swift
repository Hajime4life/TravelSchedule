import SwiftUI
import OpenAPIURLSession
import OpenAPIRuntime

struct ContentView: View {
    
    // TODO: Удалить после ревью (это для тестов)
    let apiKey = "ВАШ_КЛЮЧ" // Замените на реальный ключ

    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear() {
            test()
        }
    }
    
    func test() {
        
        Task {
            do {
                
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let carrierService = CarrierService(apiKey: apiKey, client: client)
                let copyrightService = CopyrightService(apiKey: apiKey, client: client)
                let nearestSettlementService = NearestSettlementService(apiKey: apiKey, client: client)
                let nearestStationsService = NearestStationsService(apiKey: apiKey, client: client)
                let scheduleService = ScheduleService(apiKey: apiKey, client: client)
                let searchService = SearchService(apiKey: apiKey, client: client)
                let stationsListService = StationsListService(apiKey: apiKey, client: client)
                let threadService = ThreadService(apiKey: apiKey, client: client)
                
//                let r1 = try await carrierService.getCarrierInfo(code: "12345")
//                print("Carrier Info: \(r1)")
//                
                let r2 = try await copyrightService.getCopyrightInfo()
//                print("Copyright Info: \(r2)")
//                
                let r3 = try await nearestSettlementService.getNearestCity(lat: 55.7558, lng: 37.6173)
//                print("Nearest City: \(r3)")
                
                let r4 = try await nearestStationsService.getNearestStations(lat: 55.7558, lng: 37.6173, distance: 10)
//                print("Nearest Stations: \(r4)")
                
//                let r5 = try await scheduleService.getSchedule(station: "s9602371")
//                print("Schedule: \(r5)")
//                
//                let r6 = try await searchService.search(from: "s9602371", to: "s9602528")
//                print("Search: \(r6)")
//                
//                let r7 = try await stationsListService.getAllStations() // TODO: Тут API не возвращает в JSON
//                print("All Stations: \(r7)")
//                
//                let r8 = try await threadService.getRouteStations(uid: "some-uuid-here")
//                print("Route Stations: \(r8)")
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
