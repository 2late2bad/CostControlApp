//
//  HeaderView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import SwiftUI

struct HeaderView: View {
    
    let allIncomes: Int
    @EnvironmentObject var general: GeneralEnvironment
    
    var body: some View {
        VStack {
            HStack {
                Text("Текущий баланс")
                    .fontDesign(.serif)
                Spacer()
                Text("\(general.getBalance(allIncomes)) RUB.")
                    .bold()
            }
            .padding()
            
            Text("Доходы")
                .font(.title)
                .bold()
        }
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView(allIncomes: 1000)
//    }
//}
