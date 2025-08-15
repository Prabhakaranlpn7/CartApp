//
//  BottomNavigationViewModel.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI


class BottomNavigationViewModel: ObservableObject {
    @Published var selectedTab: TabType = .home
    @Published var cartItemCount = 2
    
    enum TabType: String, CaseIterable {
        case home = "Home"
        case catalog = "Catalog"
        case cart = "Cart"
        case favorites = "Favorites"
        case profile = "Profile"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .catalog: return "rectangle.grid.2x2"
            case .cart: return "cart"
            case .favorites: return "heart"
            case .profile: return "person"
            }
        }
    }
    
    func selectTab(_ tab: TabType) {
        selectedTab = tab
    }
}
