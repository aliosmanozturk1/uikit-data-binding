# 📱 Data Binding Patterns in Swift/UIKit

A personal learning project exploring **5 different data binding approaches** in Swift, documenting my journey to understand when and how to use each pattern effectively.

## 🎯 Project Overview

This is my personal learning project where I implement the **same functionality** using five different data binding patterns to:

- ✅ Deeply understand each pattern's strengths and weaknesses
- ✅ Practice and compare different architectural approaches
- ✅ Build muscle memory with reactive programming
- ✅ Create a reference guide for my future projects
- ✅ Document my learning journey

### Common Functionality

All implementations fetch user data from [JSONPlaceholder API](https://jsonplaceholder.typicode.com/users) and display it in a `UICollectionView` with:

- ⏳ Loading indicator
- ❌ Error handling with alerts
- 📱 Clean, modern UI with programmatic constraints

---

## 🏗️ Architecture Patterns

### 1️⃣ Closure Pattern
**The Traditional Approach**

```swift
class UserViewModelClosure {
    var onUsersUpdated: (([User]) -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
}
```

**Pros:**
- ✅ Simple and straightforward
- ✅ Easy to understand for beginners
- ✅ No external dependencies
- ✅ Quick to implement

**Cons:**
- ⚠️ Requires manual memory management (`weak self`)
- ⚠️ Limited to single observer per callback
- ⚠️ Can become messy with multiple callbacks
- ⚠️ No built-in threading support

**Best For:** Small projects, simple use cases, rapid prototyping

---

### 2️⃣ Delegate Pattern
**The Protocol-Oriented Way**

```swift
protocol UserViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: UserViewModelDelegatePattern, didUpdateUsers users: [User])
    func viewModel(_ viewModel: UserViewModelDelegatePattern, didFailWithError error: Error)
    func viewModel(_ viewModel: UserViewModelDelegatePattern, isLoading: Bool)
}
```

**Pros:**
- ✅ iOS standard pattern (familiar to all iOS devs)
- ✅ Compile-time safety with protocols
- ✅ Automatic memory management with `weak` delegates
- ✅ Clear contract between components
- ✅ Well-organized with multiple methods

**Cons:**
- ⚠️ Limited to one delegate at a time
- ⚠️ Boilerplate code for protocol definition
- ⚠️ Tight coupling between components

**Best For:** Framework design, reusable components, team projects with strict conventions

---

### 3️⃣ NotificationCenter Pattern
**The Broadcast Approach**

```swift
extension Notification.Name {
    static let usersDidUpdate = Notification.Name("usersDidUpdate")
    static let usersDidFail = Notification.Name("usersDidFail")
    static let usersLoading = Notification.Name("usersLoading")
}
```

**Pros:**
- ✅ Multiple observers (one-to-many relationship)
- ✅ Loose coupling between components
- ✅ System-wide communication
- ✅ No direct references needed

**Cons:**
- ⚠️ No type safety (uses `Any?` in userInfo)
- ⚠️ String-based keys (prone to typos)
- ⚠️ Memory leaks if observers not removed
- ⚠️ Difficult to debug and trace

**Best For:** System-wide events, loosely coupled architecture, plugin systems

---

### 4️⃣ Combine Framework
**Apple's Modern Reactive Solution**

```swift
class UserViewModelCombine {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
}
```

**Pros:**
- ✅ Native Apple framework (no 3rd party dependency)
- ✅ SwiftUI integration out of the box
- ✅ Powerful operators (map, filter, debounce, etc.)
- ✅ Automatic memory management with `AnyCancellable`
- ✅ Thread-safe by design
- ✅ Declarative and functional programming style

**Cons:**
- ⚠️ iOS 13+ only (limiting for legacy support)
- ⚠️ Steep learning curve
- ⚠️ Still evolving (less mature than RxSwift)
- ⚠️ Limited documentation and community resources

**Best For:** Modern iOS apps (iOS 13+), SwiftUI projects, new greenfield projects

---

### 5️⃣ RxSwift
**The Reactive Programming Powerhouse**

```swift
class UserViewModelRx {
    let users = BehaviorRelay<[User]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
}
```

**Pros:**
- ✅ Most mature reactive framework
- ✅ Extensive operator library (200+ operators)
- ✅ Cross-platform knowledge transfer (RxJava, RxJS, RxKotlin)
- ✅ Excellent for complex async operations
- ✅ Automatic UI binding with `RxCocoa`
- ✅ Strong community and resources
- ✅ Works with iOS 9+

**Cons:**
- ⚠️ 3rd party dependency (~3MB binary size)
- ⚠️ Very steep learning curve
- ⚠️ Requires team-wide adoption for consistency
- ⚠️ Can be overkill for simple apps
- ⚠️ Longer compile times

**Best For:** Large complex apps, teams experienced in reactive programming, apps with heavy async operations

---

## 📊 Comparison Table

| Feature | Closure | Delegate | Notification | Combine | RxSwift |
|---------|---------|----------|--------------|---------|---------|
| **Learning Curve** | ⭐ Easy | ⭐⭐ Medium | ⭐⭐ Medium | ⭐⭐⭐⭐ Hard | ⭐⭐⭐⭐⭐ Very Hard |
| **Code Lines** | ~80 | ~100 | ~90 | ~60 | ~50 |
| **iOS Version** | iOS 2.0+ | iOS 2.0+ | iOS 2.0+ | iOS 13.0+ | iOS 9.0+ |
| **3rd Party Dep** | ❌ No | ❌ No | ❌ No | ❌ No | ✅ Yes |
| **Multiple Observers** | ❌ No | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes |
| **Type Safety** | ✅ Yes | ✅ Yes | ⚠️ Partial | ✅ Yes | ✅ Yes |
| **Memory Safety** | ⚠️ Manual | ✅ Auto | ⚠️ Manual | ✅ Auto | ✅ Auto |
| **Threading** | ⚠️ Manual | ⚠️ Manual | ⚠️ Manual | ✅ Built-in | ✅ Built-in |
| **Testability** | ⭐⭐⭐ Good | ⭐⭐⭐⭐ Great | ⭐⭐ Fair | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent |
| **Community** | 🌍 Universal | 🌍 Universal | 🌍 Universal | 🌱 Growing | 🚀 Massive |

---

## 📁 Project Structure

```
DataBindingPatterns/
│
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── MainTabBarController.swift
│
├── Models/
│   └── User.swift
│
├── Services/
│   └── NetworkService.swift
│
├── Views/
│   └── Cells/
│       └── UserCell.swift
│
├── ViewModels/
│   ├── Closure/
│   │   └── UserViewModelClosure.swift
│   ├── Delegate/
│   │   └── UserViewModelDelegate.swift
│   ├── Notification/
│   │   └── UserViewModelNotification.swift
│   ├── Combine/
│   │   └── UserViewModelCombine.swift
│   └── RxSwift/
│       └── UserViewModelRx.swift
│
├── Controllers/
│   ├── Closure/
│   │   └── ClosureViewController.swift
│   ├── Delegate/
│   │   └── DelegateViewController.swift
│   ├── Notification/
│   │   └── NotificationViewController.swift
│   ├── Combine/
│   │   └── CombineViewController.swift
│   └── RxSwift/
│       └── RxSwiftViewController.swift
│
├── Protocols/
│   └── UserViewModelDelegateProtocol.swift
│
└── Extensions/
    ├── Notification+Names.swift
    └── UIViewController+Alert.swift
```

---

## 💡 Code Examples

### Binding Comparison

**Closure:**
```swift
viewModel.onUsersUpdated = { [weak self] users in
    self?.users = users
    self?.collectionView.reloadData()
}
```

**Delegate:**
```swift
func viewModel(_ viewModel: UserViewModelDelegatePattern, didUpdateUsers users: [User]) {
    self.users = users
    collectionView.reloadData()
}
```

**Notification:**
```swift
NotificationCenter.default.addObserver(forName: .usersDidUpdate, object: nil, queue: .main) { notification in
    if let users = notification.userInfo?["users"] as? [User] {
        self.users = users
        self.collectionView.reloadData()
    }
}
```

**Combine:**
```swift
viewModel.$users
    .receive(on: DispatchQueue.main)
    .sink { [weak self] users in
        self?.users = users
        self?.collectionView.reloadData()
    }
    .store(in: &cancellables)
```

**RxSwift:**
```swift
viewModel.users
    .bind(to: collectionView.rx.items(cellIdentifier: UserCell.identifier, cellType: UserCell.self)) { index, user, cell in
        cell.configure(with: user)
    }
    .disposed(by: disposeBag)
```

---

## 🎯 When to Use What?

### Small Projects (1-2 developers)
```
✅ Closure or Delegate
```
- Fast development
- Easy to understand
- Minimal overhead

### Medium Projects (3-10 developers)
```
✅ Combine (if iOS 13+)
✅ Delegate + Closure mix
```
- Balanced approach
- Modern but not too complex
- Team can gradually learn

### Large Projects (10+ developers)
```
✅ RxSwift or Combine
```
- Standardized reactive pattern
- Complex async operations
- Strong type safety
- Better testability

### SwiftUI Projects
```
✅ Combine (mandatory)
```
- Native integration
- @Published properties
- ObservableObject protocol
