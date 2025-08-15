//
//  ContentView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var cartService = CartService()
    @StateObject private var favoritesService = FavoritesService()
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.navigationPath) {
                HomeView()
                    .navigationDestination(for: Product.self) { product in
                        ProductDetailView(product: product)
                    }
            }
            .tabItem {
                Image(systemName: AppCoordinator.TabType.home.icon)
                Text(AppCoordinator.TabType.home.rawValue)
            }
            .tag(AppCoordinator.TabType.home)
            
            CatalogView()
                .tabItem {
                    Image(systemName: AppCoordinator.TabType.catalog.icon)
                    Text(AppCoordinator.TabType.catalog.rawValue)
                }
                .tag(AppCoordinator.TabType.catalog)
            
            CartView()
                .tabItem {
                    Image(systemName: AppCoordinator.TabType.cart.icon)
                    Text(AppCoordinator.TabType.cart.rawValue)
                }
                .badge(cartService.totalItems > 0 ? cartService.totalItems : 0)
                .tag(AppCoordinator.TabType.cart)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: AppCoordinator.TabType.favorites.icon)
                    Text(AppCoordinator.TabType.favorites.rawValue)
                }
                .tag(AppCoordinator.TabType.favorites)
            
            ProfileView()
                .tabItem {
                    Image(systemName: AppCoordinator.TabType.profile.icon)
                    Text(AppCoordinator.TabType.profile.rawValue)
                }
                .tag(AppCoordinator.TabType.profile)
        }
        .environmentObject(coordinator)
        .environmentObject(cartService)
        .environmentObject(favoritesService)
    }
}
