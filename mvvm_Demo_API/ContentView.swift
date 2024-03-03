//
//  ContentView.swift
//  mvvm_Demo_API
//
//  Created by Mohamed Abd Elhakam on 25/12/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = userViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                
                if vm.isRefreashing {
                    ProgressView()
                }else {
                    List {
                        ForEach(vm.users , id : \.id ){ user in
                            userView(user: user)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                .navigationTitle("Users")
                }
            
            }
            .onAppear(perform: {
//                vm.fetchData()
                vm.fetchUser()
            })
            .alert(isPresented: $vm.hasError , error: vm.error) {
                Button {
//                    vm.fetchData()
                    vm.fetchUser()
                } label: {
                    Text("Retry")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
