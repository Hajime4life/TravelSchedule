import SwiftUI
import OpenAPIURLSession

struct CarrierListView: View {
    @EnvironmentObject var stationsViewModel: StationsViewModel
    @EnvironmentObject var navigation: NavigationViewModel
    @EnvironmentObject var carrierViewModel: CarrierViewModel
    @State private var isFiltered: Bool = false
    
    var body: some View {
        VStack {
            Text("\(stationsViewModel.selectedFromStation?.title ?? "Откуда") → \(stationsViewModel.selectedToStation?.title ?? "Куда")")
                .font(.system(size: 24))
                .bold()
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(carrierViewModel.segments, id: \.self) { segment in
                        if let carrier = segment.thread?.carrier {
                            NavigationLink(destination: TransportDetailView(carrier: carrier)) {
                                CarrierItemView(segment: segment)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .overlay {
            if carrierViewModel.segments.isEmpty {
                Text("Вариантов нет")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(.blackDay)
            }
            if !carrierViewModel.segments.isEmpty {
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
        }
        .onAppear {
            carrierViewModel.loadRaces(stationsViewModel: stationsViewModel)
        }
    }
}

#Preview {
    let st = StationsViewModel()
    let carrierViewModel = CarrierViewModel()
    CarrierListView()
        .environmentObject(st)
        .environmentObject(NavigationViewModel())
        .environmentObject(carrierViewModel)
        .onAppear {
            st.loadCities()
        }
}
