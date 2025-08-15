//
//  CatalogView.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct CatalogView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Catalog View")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Browse all products here")
                    .foregroundColor(.gray)
            }
            .navigationTitle("Catalog")
        }
    }
}
