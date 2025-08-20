import SwiftUI
import OpenAPIURLSession
import Combine
import Foundation

final class CarrierViewModel: ObservableObject {
    @Published var segments: [TripSegmentModel] = []
    @Published var filteredSegments: [TripSegmentModel] = []
    @Published var isFilterApplied: Bool = false
    @Published var selectedTimeIntervals: Set<String> = []
    @Published var showTransferRaces: Bool? = nil
    @Published var error: NetworkError?
    
    private let searchService: SearchService = SearchService()
    
    func loadRaces(from: String, to: String) async {
        guard !from.isEmpty, !to.isEmpty else {
            await MainActor.run {
                self.segments = []
                self.filteredSegments = []
                self.error = nil
            }
            return
        }
        
        defer {
            Task {
                await self.applyFilters()
            }
        }
        
        do {
            let response = try await searchService.search(
                from: from,
                to: to,
                transfers: showTransferRaces ?? true
            )
            await MainActor.run {
                self.segments = response.segments ?? []
                self.error = nil
            }
        } catch NetworkError.noInternet {
            await MainActor.run {
                self.error = .noInternet
                self.segments = []
                self.filteredSegments = []
            }
        } catch NetworkError.serverError {
            await MainActor.run {
                self.error = .serverError
                self.segments = []
                self.filteredSegments = []
            }
        } catch {
            await MainActor.run {
                self.error = .serverError
                self.segments = []
                self.filteredSegments = []
            }
        }
    }
    
    func applyFilters() async {
        filteredSegments = segments.filter { segment in
            if let showTransfers = showTransferRaces {
                if !showTransfers && (segment.has_transfers ?? false) {
                    return false
                }
            }
            
            
            if selectedTimeIntervals.isEmpty {
                return true
            }
            guard segment.thread?.carrier != nil else { return false }
            guard let departure = segment.departure else { return false }
            let formatter = ISO8601DateFormatter()
            guard let date = formatter.date(from: departure),
                  let hour = Calendar.current.dateComponents([.hour], from: date).hour else { return false }
            
            for interval in selectedTimeIntervals {
                switch interval {
                case "Утро 06:00 - 12:00":
                    if hour >= 6 && hour < 12 { return true }
                case "День 12:00 - 18:00":
                    if hour >= 12 && hour < 18 { return true }
                case "Вечер 18:00 - 00:00":
                    if hour >= 18 || hour < 0 { return true }
                case "Ночь 00:00 - 06:00":
                    if hour >= 0 && hour < 6 { return true }
                default:
                    break
                }
            }
            return false
        }
        
       
        isFilterApplied = !selectedTimeIntervals.isEmpty || showTransferRaces != nil
        
    }
    
    func clearError() {
        error = nil
    }
    
    func resetFilters() {
        selectedTimeIntervals.removeAll()
        showTransferRaces = nil
        filteredSegments = segments
        isFilterApplied = false
    }
    
    // Форматирование даты отправления
    func formatDepartureDate(startDate: String?) -> String {
        guard let startDate = startDate else {
            return "N/A"
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: startDate) else {
            return "N/A"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }
    
    // Форматирование времени отправления
    func formatDepartureTime(departure: String?) -> String {
        guard let departure = departure else {
            return "N/A"
        }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: departure) else {
            return "N/A"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }
    
    // Форматирование времени прибытия
    func formatArrivalTime(arrival: String?) -> String {
        guard let arrival = arrival else {
            return "N/A"
        }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: arrival) else {
            return "N/A"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: date)
    }
    
    // Форматирование длительности
    func formatDuration(duration: Int?) -> String {
        guard let duration = duration else {
            return "N/A"
        }
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        if hours == 0 {
            return "\(minutes) мин"
        }
        if minutes == 0 {
            return "\(hours) часов"
        }
        return "\(hours) ч \(minutes) мин"
    }
    
    // Форматирование даты прибытия
    func formatArrivalDate(startDate: String?, departure: String?, duration: Int?) -> String {
        guard let startDate = startDate, let departure = departure, let duration = duration else {
            return "N/A"
        }
        let formatter = ISO8601DateFormatter()
        guard let departureDate = formatter.date(from: departure) else {
            return "N/A"
        }
        
        let arrivalDate = departureDate.addingTimeInterval(TimeInterval(duration))
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        return outputFormatter.string(from: arrivalDate)
    }
}
