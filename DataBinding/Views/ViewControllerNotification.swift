//
//  NotificationViewController.swift
//  DataBinding
//
//  Created by Ali Osman Öztürk on 5.10.2025.
//

import UIKit

class ViewControllerNotification: UIViewController {
    private let viewModel = ViewModelNotification()
    private var collectionView: UICollectionView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var users: [User] = []
    private var observers: [NSObjectProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeNotifications()
        viewModel.fetchUsers()
    }
    
    private func setupUI() {
        title = "Notification"
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 120)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshTapped)
        )
    }
    
    private func observeNotifications() {
        let updateObserver = NotificationCenter.default.addObserver(
            forName: .usersDidUpdate,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let users = notification.userInfo?["users"] as? [User] {
                self?.users = users
                self?.collectionView.reloadData()
            }
        }
        
        let errorObserver = NotificationCenter.default.addObserver(
            forName: .usersDidFail,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let error = notification.userInfo?["error"] as? Error {
                self?.showAlert(message: error.localizedDescription)
            }
        }
        
        let loadingObserver = NotificationCenter.default.addObserver(
            forName: .usersLoading,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let isLoading = notification.object as? Bool {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        observers = [updateObserver, errorObserver, loadingObserver]
    }
    
    @objc private func refreshTapped() {
        viewModel.refreshUsers()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}

extension ViewControllerNotification: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        cell.configure(with: users[indexPath.item])
        return cell
    }
}
