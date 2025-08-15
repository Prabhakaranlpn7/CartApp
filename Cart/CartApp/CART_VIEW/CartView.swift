//
//  CartView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel: CartViewModel
    @EnvironmentObject private var cartService: CartService
    @State private var showThankYouAlert = false
    
    init() {
        self._viewModel = StateObject(wrappedValue: CartViewModel(cartService: CartService()))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if cartService.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("92 High Street, London")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button("Change") {
                            }
                            .font(.subheadline)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        
                        Divider()
                        
                        HStack {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Select all")
                                        .font(.subheadline)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.gray)
                            }
                            
                            Text("\(cartService.totalItems)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(cartService.cartItems) { item in
                                    CartItemView(
                                        item: item,
                                        onQuantityChange: { quantity in
                                            cartService.updateQuantity(for: item.product, quantity: quantity)
                                        },
                                        onRemove: {
                                            cartService.removeFromCart(item.product)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                        
                        Button(action: {
//                                cartService.clearCart()
                                showThankYouAlert = true
                            }) {
                                Text("Checkout (\(String(format: "£%.2f", cartService.totalPrice)))")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .alert(isPresented: $showThankYouAlert) {
                                Alert(
                                    title: Text("Thank You!"),
                                    message: Text("Your order has been placed successfully."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct CartItemView: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    @State private var isSelected = true
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: { isSelected.toggle() }) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .gray)
            }
            
            AsyncImage(url: URL(string: item.product.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                        .onAppear {
                            print("Loading image: \(item.product.image)")
                        }
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .onAppear {
                            print("Image loaded successfully: \(item.product.image)")
                        }
                    
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                        .onAppear {
                            print("Failed to load image: \(item.product.image)")
                        }
                    
                @unknown default:
                    EmptyView()
                        .onAppear {
                            print("Unknown state for image: \(item.product.image)")
                        }
                }
            }

            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(String(format: "£%.2f", item.product.price))
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    HStack(spacing: 12) {
                        Button(action: {
                            if item.quantity > 1 {
                                onQuantityChange(item.quantity - 1)
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.caption)
                                .frame(width: 28, height: 28)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                        .disabled(item.quantity <= 1)
                        
                        Text("\(item.quantity)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(minWidth: 20)
                        
                        Button(action: {
                            onQuantityChange(item.quantity + 1)
                        }) {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}


