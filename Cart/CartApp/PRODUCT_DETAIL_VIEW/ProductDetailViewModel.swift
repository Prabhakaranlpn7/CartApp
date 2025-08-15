//
//  ProductDetailViewModel.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

class ProductDetailViewModel: ObservableObject {
    @Published var quantity: Int = 1
    @Published var selectedImageIndex = 0
    @Published var showingAddToCartSuccess = false
    
    let product: Product
    let cartService: any CartServiceProtocol
    let favoritesService: any FavoritesServiceProtocol
    
    init(product: Product, cartService: any CartServiceProtocol, favoritesService: any FavoritesServiceProtocol) {
        self.product = product
        self.cartService = cartService
        self.favoritesService = favoritesService
    }
    
    var productTitle: String { product.title }
    var productDescription: String { product.description }
    var productPrice: String { String(format: "£%.2f", product.price) }
    var productRating: Double { product.rating.rate }
    var reviewCount: Int { product.rating.count }
    var productImages: [String] { [product.image] }
    
    var isFavorite: Bool {
        favoritesService.isFavorite(product)
    }
    
    func toggleFavorite() {
        favoritesService.toggleFavorite(product)
    }
    
    func addToCart() {
        cartService.addToCart(product, quantity: quantity)
        showingAddToCartSuccess = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showingAddToCartSuccess = false
        }
    }
    
    func incrementQuantity() {
        quantity += 1
    }
    
    func decrementQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
}
