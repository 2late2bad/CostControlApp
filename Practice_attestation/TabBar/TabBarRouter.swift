//
//  TabBarRouter.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 11.04.2023.
//

import UIKit

enum Screen {
    case Income
    case Schedule
    case Expenses
}


final class TabBarRouter: ObservableObject {
    
    @Published var screen: Screen = .Income
    
    func change(to screen: Screen) {
        self.screen = screen
    }
    
}
