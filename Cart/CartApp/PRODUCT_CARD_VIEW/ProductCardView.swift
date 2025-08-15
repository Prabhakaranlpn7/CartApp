//
//  ProductCardView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    let onTap: () -> Void
    @EnvironmentObject private var cartService: CartService
    @EnvironmentObject private var favoritesService: FavoritesService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .topTrailing) {
                Button(action: onTap) {
                    AsyncImage(url: URL(string: product.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .overlay(ProgressView())
                    }
                    .frame(height: 120)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    if favoritesService.isFavorite(product) {
                        favoritesService.toggleFavorite(product)
                        cartService.removeFromCart(product)
                    } else {
                        favoritesService.toggleFavorite(product)
                        cartService.addToCart(product)
                    }
                }) {
                    Image(systemName: favoritesService.isFavorite(product) ? "heart.fill" : "heart")
                        .foregroundColor(favoritesService.isFavorite(product) ? .red : .gray)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(String(format: "£%.2f", product.price))
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", product.rating.rate))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: { cartService.addToCart(product) }) {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.themePrimary)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
