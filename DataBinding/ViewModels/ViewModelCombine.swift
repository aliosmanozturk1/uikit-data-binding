//
//  UserViewModelCombine.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit
import Combine

class ViewModelCombine {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    func fetchUsers() {
        isLoading = true
        
        NetworkService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func refreshUsers() {
        fetchUsers()
    }
}
