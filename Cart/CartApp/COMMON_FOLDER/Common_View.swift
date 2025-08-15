//
//  Common_View.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct HeaderView: View {
    let address: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.themePrimary)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "location")
                        .foregroundColor(.black)
                )
            
            Spacer()
            
            VStack(alignment: .center, spacing: 2) {
                Text("Delivery address")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(address)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .padding(12)
                    .background(Color.black.opacity(0.1))
                    .clipShape(Circle())
            }

            
        }
        .padding(.horizontal, 20)
    }
}



struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search the entire shop", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}



struct DeliveryBannerView: View {
    let discountPercentage: Int
    
    var body: some View {
        HStack {
            Text("Delivery is")
                .fontWeight(.medium)
            Text("\(discountPercentage)%")
                .fontWeight(.black)
                .padding(5)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(.white)
                )
                .cornerRadius(10)
            
            Text("cheaper")
                .fontWeight(.medium)
            
            Spacer()
            
            Image(systemName: "bicycle")
                .foregroundColor(.black)
                .font(.system(size: 24))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.mint.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

struct CategoriesView: View {
    let categories: [Category]
    let selectedCategory: String?
    let onCategorySelected: (String?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Categories")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("See all")
                    .foregroundColor(.gray)
                Button(action: {onCategorySelected(nil)}) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .padding(5)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                    
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 20) {
                    ForEach(categories) { category in
                        CategoryItemView(
                            category: category,
                            isSelected: selectedCategory == category.name
                        ) {
                            onCategorySelected(
                                selectedCategory == category.name ? nil : category.name
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct CategoryItemView: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(isSelected ? Color.themePrimary.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: category.icon)
                            .font(.system(size: 24))
                            .foregroundColor(isSelected ? .green : .black)
                    )
                
                Text(category.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .green : .black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FlashSaleHeaderView: View {
    let timeRemaining: String
    
    var body: some View {
        HStack {
            Text("Flash Sale")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(timeRemaining)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.themePrimary)
                .foregroundColor(.white)
                .cornerRadius(4)
            
            Spacer()
            
            Button("See all") {}
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 20)
    }
}

struct ProductsGridView: View {
    let products: [Product]
    @EnvironmentObject private var coordinator: AppCoordinator
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCardView(product: product) {
                    coordinator.navigateToProduct(product)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}


struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading products...")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: retry) {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Add some products to get started")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
