import SwiftUI

struct ItemView: View {
    let title: String
    
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("ResicloGreen2"))
                    .frame(width: 150, height: 100)
                Image("garbage-bag")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            HStack{
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color("ResicloBrown"))
                    .fontWeight(.bold)
                
            }
            .frame(width: 150, height: 40)
        }
    }
}
