//
//  HomeView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var selectedCategory: String?
    
    // Static Data
    let deliveryAddress = "92 High Street, London"
    let discountPercentage = 50
    let flashSaleTime = "02:59:23"
    
    let categories = [
        Category(name: "Phones", icon: "iphone"),
        Category(name: "Consoles", icon: "gamecontroller"),
        Category(name: "Laptops", icon: "laptopcomputer"),
        Category(name: "Cameras", icon: "camera"),
        Category(name: "Audio", icon: "headphones")
    ]
    
    var filteredProducts: [Product] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category.localizedCaseInsensitiveContains(category) }
        }
        
        return filtered
    }
    
    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }
    
    func loadProducts() {
        let cachedProducts = repository.getCachedProducts()
        if !cachedProducts.isEmpty {
            self.products = cachedProducts
        }
        
        isLoading = true
        errorMessage = nil
        
        repository.fetchProducts()
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] products in
                    self?.products = products
                }
            )
            .store(in: &cancellables)
    }
    
    func selectCategory(_ category: String?) {
        selectedCategory = category
    }
    
    func retryLoading() {
        loadProducts()
    }
}
