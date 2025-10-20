//
//  UserViewModelDelegate.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit

protocol ViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: UserViewModelDelegatePattern, didUpdateUsers users: [User])
    func viewModel(_ viewModel: UserViewModelDelegatePattern, didFailWithError error: Error)
    func viewModel(_ viewModel: UserViewModelDelegatePattern, isLoading: Bool)
}

class UserViewModelDelegatePattern {
    weak var delegate: ViewModelDelegate?
    private var users: [User] = []
    
    func fetchUsers() {
        delegate?.viewModel(self, isLoading: true)
        
        NetworkService.shared.fetchUsers { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.delegate?.viewModel(self, isLoading: false)
                
                switch result {
                case .success(let users):
                    self.users = users
                    self.delegate?.viewModel(self, didUpdateUsers: users)
                case .failure(let error):
                    self.delegate?.viewModel(self, didFailWithError: error)
                }
            }
        }
    }
    
    func refreshUsers() {
        fetchUsers()
    }
}
