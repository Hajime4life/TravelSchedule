import SwiftUI
import OpenAPIURLSession

struct TransportDetailView: View {
    let carrier: Components.Schemas.Carrier
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let logoURLString = carrier.logo,
               let url = URL(string: logoURLString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 104)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 104)
            }
            
            Text(carrier.title ?? "")
                .font(.system(size: 24))
                .bold()
            
            if let email = carrier.email {
                Text("E-mail")
                    .padding(.top)
                
                Link(email, destination: URL(string: email)!)
                    .foregroundColor(.blueUniversal)
                    .font(.system(size: 12))
            }
            
            
            if let phone = carrier.phone {
                Text("Телефон")
                    .padding(.top)
                
                Link(phone, destination: URL(string: "tel:\(phone)")!)
                    .foregroundColor(.blueUniversal)
                    .font(.system(size: 12))
            }
            
            Spacer()
        }
        .navigationTitle("Информация о перевозчике")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}
