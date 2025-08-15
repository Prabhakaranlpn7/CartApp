//
//  HomeView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderView(address: viewModel.deliveryAddress)
                
                SearchBarView(searchText: $viewModel.searchText)
                
                DeliveryBannerView(discountPercentage: viewModel.discountPercentage)
                
                CategoriesView(
                    categories: viewModel.categories,
                    selectedCategory: viewModel.selectedCategory,
                    onCategorySelected: viewModel.selectCategory
                )
                
                FlashSaleHeaderView(timeRemaining: viewModel.flashSaleTime)
                
                if viewModel.isLoading && viewModel.products.isEmpty {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage, viewModel.products.isEmpty {
                    ErrorView(message: errorMessage, retry: viewModel.retryLoading)
                } else {
                    ProductsGridView(products: viewModel.filteredProducts)
                }
            }
            .padding(.vertical)
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.products.isEmpty {
                viewModel.loadProducts()
            }
        }
        .refreshable {
            viewModel.loadProducts()
        }
    }
}


