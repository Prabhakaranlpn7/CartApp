//
//  Profileview.swift
//  Cart
//
//  Created by Vigneshvarma V on 15/08/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                        )
                    
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("john.doe@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    VStack(spacing: 16) {
                        ProfileMenuItem(icon: "person.circle", title: "Edit Profile")
                        ProfileMenuItem(icon: "creditcard", title: "Payment Methods")
                        ProfileMenuItem(icon: "truck.box", title: "Order History")
                        ProfileMenuItem(icon: "bell", title: "Notifications")
                        ProfileMenuItem(icon: "questionmark.circle", title: "Help & Support")
                        ProfileMenuItem(icon: "gearshape", title: "Settings")
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .navigationTitle("Profile")
            }
            
        }
    }
}


struct ProfileMenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
