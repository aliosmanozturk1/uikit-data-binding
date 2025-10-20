//
//  UserViewModelClosure.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit

class ViewModelClosure {
    private var users: [User] = []
    var onUsersUpdated: (([User]) -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    func fetchUsers() {
        onLoading?(true)
        
        NetworkService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoading?(false)
                
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.onUsersUpdated?(users)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    func refreshUsers() {
        fetchUsers()
    }
}
