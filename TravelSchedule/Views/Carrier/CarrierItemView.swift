import SwiftUI
import OpenAPIURLSession

struct CarrierItemView: View {
    let segment: Components.Schemas.Segment
    @EnvironmentObject var viewModel: CarrierViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                if let logoURLString = segment.thread?.carrier?.logo,
                   let url = URL(string: logoURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 38, height: 38)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38, height: 38)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading) {
                    Text(segment.thread?.carrier?.title ?? "Перевозчик")
                        .font(.system(size: 20))
                    if false { // TODO: заглушка для has_transfers
                        Text("С пересадкой")
                            .foregroundColor(.redUniversal)
                            .lineSpacing(0.4)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text(viewModel.formatDepartureDate(startDate: segment.start_date))
                    .font(.system(size: 12))
            }
            
            HStack {
                Text(viewModel.formatDepartureTime(departure: segment.departure))
                    .font(.system(size: 17))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.grayUniversal)
                Text(viewModel.formatDuration(duration: segment.duration))
                    .font(.system(size: 12))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.grayUniversal)
                Text(viewModel.formatArrivalTime(arrival: segment.arrival))
                    .font(.system(size: 17))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.lightGray.cornerRadius(24))
        .padding(.horizontal)
    }
}
