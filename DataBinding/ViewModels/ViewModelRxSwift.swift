//
//  UserViewModelRx.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit
import RxSwift
import RxCocoa

class ViewModelRxSwift {
    let users = BehaviorRelay<[User]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    
    func fetchUsers() {
        isLoading.accept(true)
        
        NetworkService.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading.accept(false)
                
                switch result {
                case .success(let users):
                    self?.users.accept(users)
                case .failure(let error):
                    self?.error.accept(error)
                }
            }
        }
    }
    
    func refreshUsers() {
        fetchUsers()
    }
}
