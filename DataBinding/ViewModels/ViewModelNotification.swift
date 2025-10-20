//
//  UserViewModelNotification.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit

extension Notification.Name {
    static let usersDidUpdate = Notification.Name("usersDidUpdate")
    static let usersDidFail = Notification.Name("usersDidFail")
    static let usersLoading = Notification.Name("usersLoading")
}

class ViewModelNotification {
    func fetchUsers() {
        NotificationCenter.default.post(name: .usersLoading, object: true)
        
        NetworkService.shared.fetchUsers { result in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .usersLoading, object: false)
                
                switch result {
                case .success(let users):
                    NotificationCenter.default.post(
                        name: .usersDidUpdate,
                        object: nil,
                        userInfo: ["users": users]
                    )
                case .failure(let error):
                    NotificationCenter.default.post(
                        name: .usersDidFail,
                        object: nil,
                        userInfo: ["error": error]
                    )
                }
            }
        }
    }
    
    func refreshUsers() {
        fetchUsers()
    }
}
