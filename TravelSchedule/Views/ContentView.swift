import SwiftUI
import OpenAPIURLSession
import OpenAPIRuntime

struct ContentView: View {
    
    // TODO: Удалить после ревью (это для тестов)
    let apiKey = "9995803a-ea85-45dd-8f60-d8ae279985d8" // Замените на реальный ключ

    
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
                
                try await carrierService.getCarrierInfo(code: "680") // ok
                try await copyrightService.getCopyrightInfo() // ok
                try await nearestSettlementService.getNearestCity(lat: 55.7558, lng: 37.6173) // ok
                try await nearestStationsService.getNearestStations(lat: 55.7558, lng: 37.6173, distance: 10) // ok
                try await searchService.search(from: "s9808848", to: "s9630756") // ok
                try await stationsListService.getAllStations() // ok
                try await scheduleService.getSchedule(station: "s9628059") // ТУТ ЧТО-ТО СЛОЖНО, дата приходит null
                try await threadService.getRouteStations(uid: "some-uuid-here") // Я НЕ ПОНИМАЮ ГДЕ ВЗЯТЬ UID
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
