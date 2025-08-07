import SwiftUI

struct FilterView: View {
    @EnvironmentObject var carrierViewModel: CarrierViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .bold()
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            FilterTimeItem(timeString: "Утро 06:00 - 12:00", isChecked: carrierViewModel.selectedTimeIntervals.contains("Утро 06:00 - 12:00")) { isSelected in
                if isSelected {
                    carrierViewModel.selectedTimeIntervals.insert("Утро 06:00 - 12:00")
                } else {
                    carrierViewModel.selectedTimeIntervals.remove("Утро 06:00 - 12:00")
                }
            }
            FilterTimeItem(timeString: "День 12:00 - 18:00", isChecked: carrierViewModel.selectedTimeIntervals.contains("День 12:00 - 18:00")) { isSelected in
                if isSelected {
                    carrierViewModel.selectedTimeIntervals.insert("День 12:00 - 18:00")
                } else {
                    carrierViewModel.selectedTimeIntervals.remove("День 12:00 - 18:00")
                }
            }
            FilterTimeItem(timeString: "Вечер 18:00 - 00:00", isChecked: carrierViewModel.selectedTimeIntervals.contains("Вечер 18:00 - 00:00")) { isSelected in
                if isSelected {
                    carrierViewModel.selectedTimeIntervals.insert("Вечер 18:00 - 00:00")
                } else {
                    carrierViewModel.selectedTimeIntervals.remove("Вечер 18:00 - 00:00")
                }
            }
            FilterTimeItem(timeString: "Ночь 00:00 - 06:00", isChecked: carrierViewModel.selectedTimeIntervals.contains("Ночь 00:00 - 06:00")) { isSelected in
                if isSelected {
                    carrierViewModel.selectedTimeIntervals.insert("Ночь 00:00 - 06:00")
                } else {
                    carrierViewModel.selectedTimeIntervals.remove("Ночь 00:00 - 06:00")
                }
            }
            
            Text("Показывать варианты с пересадками")
                .bold()
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            HStack {
                Text("Да")
                Spacer()
                RadioButton(isSelected: carrierViewModel.showTransferRaces == true) {
                    carrierViewModel.showTransferRaces = carrierViewModel.showTransferRaces == true ? nil : true
                }
            }
            .padding([.horizontal, .top])
            
            HStack {
                Text("Нет")
                Spacer()
                RadioButton(isSelected: carrierViewModel.showTransferRaces == false) {
                    carrierViewModel.showTransferRaces = carrierViewModel.showTransferRaces == false ? nil : false
                }
            }
            .padding([.horizontal, .top])
            
            Spacer()
        }
        .overlay {
            Button(action: {
                carrierViewModel.applyFilters()
                dismiss()
            }) {
                Text("Применить")
                    .font(.system(size: 17))
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.blueUniversal.cornerRadius(16))
                    .padding(.horizontal)
                    .foregroundColor(.whiteUniversal)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 24)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Сбросить") {
                    carrierViewModel.resetFilters()
                }
                .disabled(!carrierViewModel.isFilterApplied)
            }
        }
    }
}

struct FilterTimeItem: View {
    let timeString: String
    let isChecked: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack {
            Text(timeString)
            Spacer()
            Toggle("Включить опцию", isOn: Binding(
                get: { isChecked },
                set: { onToggle($0) }
            ))
            .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}



#Preview {
    FilterView()
        .environmentObject(CarrierViewModel())
}
