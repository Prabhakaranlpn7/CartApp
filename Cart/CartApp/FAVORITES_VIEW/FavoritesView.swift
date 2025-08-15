//
//  FavoritesView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesService: FavoritesService
    @StateObject private var homeViewModel = HomeViewModel()
    
    var favoriteProducts: [Product] {
        homeViewModel.products.filter { product in
            favoritesService.favoriteProducts.contains(product.id)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if favoriteProducts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No favorites yet")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Products you favorite will appear here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(favoriteProducts) { product in
                                ProductCardView(product: product) {
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                if homeViewModel.products.isEmpty {
                    homeViewModel.loadProducts()
                }
            }
        }
    }
}
