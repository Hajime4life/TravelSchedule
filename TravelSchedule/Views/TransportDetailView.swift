import SwiftUI

struct TransportDetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("mock_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 104)
            
            Text("ОАО «РЖД»")
                .font(.system(size: 24))
                .bold()
            
            Text("E-mail")
                .padding(.top)
            
            Link("i.lozgkina@yandex.ru", destination: URL(string: "mailto:i.lozgkina@yandex.ru")!)
                .foregroundColor(.blueUniversal)
                .font(.system(size: 12))
            
            Text("Телефон")
                .padding(.top)
            
            Link("+7 (904) 329-27-71", destination: URL(string: "tel:+79043292771")!)
                .foregroundColor(.blueUniversal)
                .font(.system(size: 12))
            
            Spacer()
        }
        .navigationTitle("Информация о перевозчике")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    TransportDetailView()
}
