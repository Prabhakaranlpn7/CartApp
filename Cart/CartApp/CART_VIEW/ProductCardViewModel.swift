//
//  ProductCartViewModel.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

class CartViewModel: ObservableObject {
    let cartService: any CartServiceProtocol
    
    init(cartService: any CartServiceProtocol) {
        self.cartService = cartService
    }
    
    var cartItems: [CartItem] {
        cartService.cartItems
    }
    
    var totalPrice: String {
        String(format: "£%.2f", cartService.totalPrice)
    }
    
    var isEmpty: Bool {
        cartService.cartItems.isEmpty
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        cartService.updateQuantity(for: product, quantity: quantity)
    }
    
    func removeItem(_ product: Product) {
        cartService.removeFromCart(product)
    }
    
    func clearCart() {
        cartService.clearCart()
    }
    
    func checkout() {
        print("Checkout initiated for total: \(totalPrice)")
        clearCart()
    }
}
