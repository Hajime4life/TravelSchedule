import SwiftUI
import OpenAPIURLSession

struct CarrierListView: View {
    let fromStation: Components.Schemas.Station
    let toStation: Components.Schemas.Station
    
    private var searchService: SearchService
    @State private var isFiltered: Bool = false
    @State private var segments: [Components.Schemas.Segment] = []
    @State private var errorMessage: String?
    
    init(fromStation: Components.Schemas.Station, toStation: Components.Schemas.Station) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.searchService = SearchService(
            apiKey: apiKey,
            client: Client(
                serverURL: try! Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        )
    }
    
    var body: some View {
        VStack {
            Text("\(fromStation.title ?? "Откуда") → \(toStation.title ?? "Куда")")
                .font(.system(size: 24))
                .bold()
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(segments, id: \.self) { segment in
                        NavigationLink(destination: TransportDetailView()) {
                            CarrierItemView(segment: segment)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .overlay {
            if segments.isEmpty, errorMessage == nil {
                Text("Вариантов нет")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            } else if let error = errorMessage {
                Text(error)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        }
        .overlay {
            NavigationLink(destination: FilterView()) {
                Text("Уточнить время")
                    .font(.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blueUniversal.cornerRadius(16))
                    .foregroundColor(.whiteUniversal)
                    .overlay(
                        Group {
                            if isFiltered {
                                Circle().fill(.redUniversal).frame(width: 8, height: 8)
                                    .offset(x: UIScreen.main.bounds.width / 5)
                            }
                        }
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .onAppear {
            print("From station: \(fromStation.codes?.yandex_code ?? "N/A")")
            print("To station: \(toStation.codes?.yandex_code ?? "N/A")")
            loadRaces()
        }
    }
    
    private func loadRaces() {
        Task {
            do {
                let response = try await searchService.search(
                    from: fromStation.codes?.yandex_code ?? "",
                    to: toStation.codes?.yandex_code ?? ""
                )
                segments = response.segments ?? []
                errorMessage = nil
            } catch {
                errorMessage = "Ошибка загрузки рейсов: \(error.localizedDescription)"
                segments = []
            }
        }
    }
}

struct CarrierItemView: View {
    let segment: Components.Schemas.Segment
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image("mock_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .cornerRadius(12)
                    .frame(maxHeight: .infinity, alignment: .center)
                VStack(alignment: .leading) {
                    Text(segment.thread?.carrier?.title ?? "Перевозчик")
                        .font(.system(size: 20))
                    //if segment.tickets_info?.has_transfers == true { TODO: Посмотреть
                        Text("С пересадкой")
                            .foregroundColor(.redUniversal)
                            .lineSpacing(0.4)
                    //}
                }
                .frame(maxWidth: .infinity)
                Text(formattedDate(segment.departure))
                    .font(.system(size: 12))
            }
            
            HStack {
                Text(formattedTime(segment.departure))
                    .font(.system(size: 17))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.grayUniversal)
                Text(formattedDuration(segment.duration))
                    .font(.system(size: 12))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.grayUniversal)
                Text(formattedTime(segment.arrival))
                    .font(.system(size: 17))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.lightGray.cornerRadius(24))
        .padding(.horizontal)
    }
    
    private func formattedDate(_ dateString: String?) -> String {
        guard let dateString, let date = ISO8601DateFormatter().date(from: dateString) else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
    
    private func formattedTime(_ dateString: String?) -> String {
        guard let dateString, let date = ISO8601DateFormatter().date(from: dateString) else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private func formattedDuration(_ duration: Int?) -> String {
        guard let duration = duration else { return "N/A" }
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        if hours == 0 {
            return "\(minutes) мин"
        }
        return "\(hours) ч \(minutes) мин"
    }
}

#Preview {
    CarrierListView(
        fromStation: Components.Schemas.Station(
            title: "Москва (Ярославский вокзал)",
            codes: .init(yandex_code: "s2000006")
        ),
        toStation: Components.Schemas.Station(
            title: "Санкт Петербург (Балтийский вокзал)",
            codes: .init(yandex_code: "s2004004")
        )
    )
}
