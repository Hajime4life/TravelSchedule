import SwiftUI

struct FilterView: View {
    @State private var showTransferRaces: Bool = false
    
    var body: some View {
        VStack {
            Text("Время отправления")
                .bold()
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            FilterTimeItem(timeString: "Утро 06:00 - 12:00")
            FilterTimeItem(timeString: "День 12:00 - 18:00")
            FilterTimeItem(timeString: "Вечер 18:00 - 00:00")
            FilterTimeItem(timeString: "Ночь 00:00 - 06:00")
            Text("Показывать варианты с пересадками")
                .bold()
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            HStack {
                Text("Да")
                Spacer()
                RadioButton(isSelected: showTransferRaces) {
                    showTransferRaces = true
                }
            }
            .padding([.horizontal, .top])
            
            HStack {
                Text("Нет")
                Spacer()
                RadioButton(isSelected: !showTransferRaces) {
                    showTransferRaces = false
                }
            }
            .padding([.horizontal, .top])
            Spacer()
        }
        .overlay{
            Button(action: {
                // TODO: Тут надо вернуть обратно
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
    }
}

struct FilterTimeItem: View {
    let timeString: String
    @State private var isChecked: Bool = false
    var body: some View {
        HStack {
            Text(timeString)
            Spacer()
            Toggle("Включить опцию", isOn: $isChecked)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
}


#Preview {
    FilterView()
}
