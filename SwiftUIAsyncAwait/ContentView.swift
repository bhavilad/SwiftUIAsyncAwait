//
//  ContentView.swift
//  SwiftUIAsyncAwait
//
//  Created by Bhavi Mistry on 14/08/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width: 120, height: 120)

            Text(user?.login ?? "Username")
                .bold()
                .font(.title)
            Text(user?.bio ?? "this is the description.")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await NetworkManager.shared.getUser()
            } catch APIError.invalidURL {
                print("Invalid URL")
            } catch APIError.invalidResponse {
                print("Invalid Response")
            } catch APIError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unexpected Error")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
