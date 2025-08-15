//
//  Common_Model.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI
import Foundation
import Combine

import SwiftUI
import Foundation
import Combine


struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Rating: Codable, Hashable {
    let rate: Double
    let count: Int
}

struct CartItem: Identifiable, Hashable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        product.price * Double(quantity)
    }
}

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
}

struct CategoryResponse: Codable {
    let categories: [MealCategory]
}

struct MealCategory: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

// MARK: - Network Layer
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to process server response"
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchProducts() -> AnyPublisher<[Product], NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func fetchProducts() -> AnyPublisher<[Product], NetworkError> {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoryResponse.self, decoder: decoder)
            .map { response in
                response.categories.enumerated().map { index, category in
                    Product(
                        id: Int(category.idCategory) ?? index + 1,
                        title: category.strCategory,
                        price: Double.random(in: 5...30), // Fake price
                        description: category.strCategoryDescription,
                        category: category.strCategory,
                        image: category.strCategoryThumb,
                        rating: Rating(rate: Double.random(in: 3...5), count: Int.random(in: 50...500))
                    )
                }
            }
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return NetworkError.networkFailure(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol ProductRepositoryProtocol {
    func fetchProducts() -> AnyPublisher<[Product], NetworkError>
    func getCachedProducts() -> [Product]
    func cacheProducts(_ products: [Product])
}

class ProductRepository: ProductRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private var cachedProducts: [Product] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchProducts() -> AnyPublisher<[Product], NetworkError> {
        return networkService.fetchProducts()
            .handleEvents(receiveOutput: { [weak self] products in
                self?.cacheProducts(products)
            })
            .eraseToAnyPublisher()
    }
    
    func getCachedProducts() -> [Product] {
        return cachedProducts
    }
    
    func cacheProducts(_ products: [Product]) {
        cachedProducts = products
    }
}

// MARK: - Cart Service
protocol CartServiceProtocol: ObservableObject {
    var cartItems: [CartItem] { get }
    var totalItems: Int { get }
    var totalPrice: Double { get }
    
    func addToCart(_ product: Product, quantity: Int)
    func removeFromCart(_ product: Product)
    func updateQuantity(for product: Product, quantity: Int)
    func clearCart()
}

class CartService: CartServiceProtocol {
    @Published var cartItems: [CartItem] = []
    
    var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    func addToCart(_ product: Product, quantity: Int = 1) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity += quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
    }
    
    func updateQuantity(for product: Product, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if quantity <= 0 {
                cartItems.remove(at: index)
            } else {
                cartItems[index].quantity = quantity
            }
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
}

// MARK: - Favorites Service
protocol FavoritesServiceProtocol: ObservableObject {
    var favoriteProducts: Set<Int> { get }
    func toggleFavorite(_ product: Product)
    func isFavorite(_ product: Product) -> Bool
}

class FavoritesService: FavoritesServiceProtocol {
    @Published var favoriteProducts: Set<Int> = []
    
    func toggleFavorite(_ product: Product) {
        if favoriteProducts.contains(product.id) {
            favoriteProducts.remove(product.id)
        } else {
            favoriteProducts.insert(product.id)
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(product.id)
    }
}
