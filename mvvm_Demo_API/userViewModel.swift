//
//  userViewModel.swift
//  mvvm_Demo_API
//
//  Created by Mohamed Abd Elhakam on 25/12/2023.
//

import Foundation
import Combine


final class userViewModel : ObservableObject {
    
    @Published var users : [User] = []
    @Published var hasError = false
    @Published var error : UserError?
    @Published private(set) var isRefreashing = false
    private var bag = Set<AnyCancellable>()
    func fetchData() {
        hasError = false
        isRefreashing = true
        
        let baseUrl = "https://jsonplaceholder.typicode.com/users"
      
        if let url = URL(string: baseUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let error = error {
                        self?.hasError = true
                        self?.error = UserError.custom(error: error)
                        
                    }else{
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        if let data = data,
                            let users = try? decoder.decode([User].self, from: data){
                            self?.users = users
                        }else{
                            self?.hasError = true
                            self?.error = UserError.failedTodecode
                            
                        }
                    }
                    self?.isRefreashing = false
                }
                
            }.resume()
        }
        
        
    }
    
    func fetchUser() {
        let baseUrl = "https://jsonplaceholder.typicode.com/usersn"
        
        if let url = URL(string: baseUrl) {
            isRefreashing = true
            hasError = false
            URLSession.shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ res in
                    guard let response = res.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else {
                        throw UserError.invailedStatusCode
                    }
                    
                    let decode = JSONDecoder()
                    guard let users = try? decode.decode([User].self, from: res.data) else {
                        throw UserError.failedTodecode
                    }
                    return users
                })
                
                .sink { [weak self] res in
                    defer{self?.isRefreashing = false}
                    switch res {
                    case .failure(let error):
                        self?.hasError = true
                        self?.error = UserError.custom(error: error)
                    default:
                        break
                    }
                    
                } receiveValue: { [weak self] users in
                    self?.users = users
                }
                .store(in: &bag)
               

                
        }

    }
    
}

extension userViewModel {
    enum UserError : LocalizedError {
        case custom(error : Error)
        case failedTodecode
        case invailedStatusCode
        
        var errorDescription : String? {
            switch self {
            case .failedTodecode:
                return "Failed to decode response"
            case.custom(let error):
                return error.localizedDescription
            case.invailedStatusCode:
                return "request falls withen an invaild rang"
            }
        }
    }
}



