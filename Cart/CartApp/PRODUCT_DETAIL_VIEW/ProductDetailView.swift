//
//  ProductDetailView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @StateObject private var viewModel: ProductDetailViewModel
    @EnvironmentObject private var cartService: CartService
    @EnvironmentObject private var favoritesService: FavoritesService
    @Environment(\.dismiss) private var dismiss
    
    init(product: Product) {
        self.product = product
        self._viewModel = StateObject(wrappedValue: ProductDetailViewModel(
            product: product,
            cartService: CartService(),
            favoritesService: FavoritesService()
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                TabView(selection: $viewModel.selectedImageIndex) {
                    ForEach(viewModel.productImages.indices, id: \.self) { index in
                        AsyncImage(url: URL(string: viewModel.productImages[index])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .overlay(ProgressView())
                        }
                        .frame(height: 300)
                        .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(viewModel.productTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
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
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.themePrimary)
                            Text(String(format: "%.1f", viewModel.productRating))
                                .fontWeight(.medium)
                            Text("\(viewModel.reviewCount) reviews")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.themePrimary)
                            Text("94%")
                                .fontWeight(.medium)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.right")
                                .foregroundColor(.gray)
                            Text("8")
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.subheadline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.productDescription)
                            .foregroundColor(.gray)
                        
                        Button("Read more") {
                        }
                        .foregroundColor(.themePrimary)
                    }
                    
                    HStack {
                        Text("Quantity:")
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if viewModel.quantity > 1 {
                                    viewModel.decrementQuantity()
                                    cartService.removeFromCart(product)
                                }
                            }) {
                                Image(systemName: "minus")
                                    .frame(width: 30, height: 30)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .disabled(viewModel.quantity <= 1)
                            
                            Text("\(viewModel.quantity)")
                                .font(.headline)
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                viewModel.incrementQuantity()
                                cartService.addToCart(product)
                            }) {
                                Image(systemName: "plus")
                                    .frame(width: 30, height: 30)
                                    .background(Color.themePrimary)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }

                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                if viewModel.showingAddToCartSuccess {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.themePrimary)
                        Text("Added to cart successfully!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                VStack(spacing: 12) {
                    Button(action: { cartService.addToCart(product, quantity: viewModel.quantity) }) {
                        Text("Add to cart")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.themePrimary)
                            .cornerRadius(12)
                    }
                    
                    Text("Delivery on 26 October")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: -2)
            }
        }
    }
}
