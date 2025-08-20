import SwiftUI
import OpenAPIURLSession

struct CarrierListView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    @EnvironmentObject var carrierViewModel: CarrierViewModel

    var body: some View {
        VStack {
            Text("\(stationsViewModel.selectedFromStation?.title ?? "Откуда") → \(stationsViewModel.selectedToStation?.title ?? "Куда")")
                .font(.system(size: 24))
                .bold()
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(carrierViewModel.filteredSegments, id: \.self) { segment in
                        if let carrier = segment.thread?.carrier {
                            NavigationLink(destination: TransportDetailView(carrier: carrier)) {
                                CarrierItemView(segment: segment)
                                    .environmentObject(carrierViewModel)
                            }
                        } else {
//                            Text("Пусто")
//                                .onAppear() {
//                                    dump(segment)
//                                }
                        }
//                        else if let carrier = segment.details.first.thred { // блин, ребят я увас непонятнятный yaml разные модели возвращаются
//                            NavigationLink(destination: TransportDetailView(carrier: carrier)) {
//                                CarrierItemView(segment: segment)
//                                    .environmentObject(carrierViewModel)
//                            }
//                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .overlay {
            if carrierViewModel.filteredSegments.isEmpty {
                Text("Вариантов нет")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            }
            
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
                            if carrierViewModel.isFilterApplied {
                                Circle().fill(.redUniversal).frame(width: 8, height: 8)
                                    .offset(x: UIScreen.main.bounds.width / 5)
                            }
                        }
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal)
            .padding(.bottom, 24)
            .opacity(!carrierViewModel.segments.isEmpty ? 1 : 0)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.whiteDay)
        .task {
            if
                let from = stationsViewModel.selectedFromStation?.codes?.yandex_code,
                let to = stationsViewModel.selectedToStation?.codes?.yandex_code
                {
                    await carrierViewModel.loadRaces(
                        from: from,
                        to: to
                    )
                }
        }

    }
}
