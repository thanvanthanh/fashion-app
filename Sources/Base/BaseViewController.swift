//
//  BaseViewController.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit
import Lottie
import RxSwift

class BaseViewController: UIViewController {
    
    var statusBarFrameHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    var navigationHeight: CGFloat {
        return navigationController?.navigationBar.frame.size.height ?? 0
    }
    
    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.size.height ?? 0
    }
    
    var topPadding: CGFloat {
        return UIApplication
            .shared
            .windows
            .filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
    }
    
    var bottomPadding: CGFloat {
        return UIApplication
            .shared.windows
            .filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
    }
    
    var isModal: Bool {
        presentingViewController?.presentedViewController == self
            || (navigationController != nil && navigationController?.presentingViewController?.presentedViewController == navigationController)
            || tabBarController?.presentingViewController is UITabBarController
    }
    
    let isLoading = PublishSubject<Bool>()
    
    var viewModel: BaseViewModel
    var disposeBag = DisposeBag()
        
    private let loadingView = UIView()
    private let animationView = LottieAnimationView(name: "animation")
    
    init(viewModel: BaseViewModel? = nil) {
        self.viewModel = viewModel ?? BaseViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        setupNavigationBarColor()
    }
    
    func bindViewModel() {
        isLoading
            .distinctUntilChanged()
            .throttle(.microseconds(100), scheduler: MainScheduler.instance)
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: rx.disposeBag)
        
        viewModel
            .loading
            .asDriver()
            .drive(onNext: { self.handleActivityIndicator(state: $0) })
            .disposed(by: rx.disposeBag)
        
        viewModel.isLoading ~> isLoading ~ rx.disposeBag
    }
    
}

extension BaseViewController {
    func handleActivityIndicator(state: Bool) {
        state ? showActivityIndicator() : hideActivityIndicator()
    }
    
    func showActivityIndicator() {
        guard let window = UIApplication.shared.mainKeyWindow else { return }
        animationView.loopMode = .loop
        animationView.play()
        
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        window.addSubview(loadingView)
        loadingView.addSubview(animationView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: window.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            loadingView.rightAnchor.constraint(equalTo: window.rightAnchor),
            loadingView.leftAnchor.constraint(equalTo: window.leftAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
            self.animationView.stop()
        }
    }
}

extension BaseViewController {
    func setupNavigationBar() {
        let logo = UIImage(asset: Asset.AssetsIOS.iconLogo)
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        addLeftBarItem(imageName: Asset.AssetsIOS.iconMenu.name)
        addRightBarItems()
    }
    
    func setupNavigationBarColor() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = UIImage()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        } else {
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
    
    func addLeftBarItem(imageName: String = "ico_chevron_left", title: String = "") {
        let leftButton = UIButton.init(type: UIButton.ButtonType.custom)
        leftButton.isExclusiveTouch = true
        leftButton.isSelected = false
        leftButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        leftButton.addTarget(self, action: #selector(tappedLeftBarButton(sender:)),
                             for: UIControl.Event.touchUpInside)
        if title.isEmpty == false {
            leftButton.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
            leftButton.setTitle(title, for: UIControl.State.normal)
            leftButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        }
        
        if imageName.isEmpty == false {
            leftButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
            leftButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            leftButton.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        }
        
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    func addRightBarItems() {
        let searchButton = UIButton.init(type: UIButton.ButtonType.custom)
        searchButton.isExclusiveTouch = true
        searchButton.isSelected = false
        searchButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchButton.setImage(UIImage(asset: Asset.AssetsIOS.iconSearch), for: UIControl.State.normal)
        searchButton.addTarget(self, action: #selector(tappedSearchBarButton(sender:)),
                             for: UIControl.Event.touchUpInside)
        
        let bagButton = UIButton.init(type: UIButton.ButtonType.custom)
        bagButton.isExclusiveTouch = true
        bagButton.isSelected = false
        bagButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        bagButton.setImage(UIImage(asset: Asset.AssetsIOS.iconBag), for: UIControl.State.normal)
        bagButton.addTarget(self, action: #selector(tappedBagBarButton(sender:)),
                             for: UIControl.Event.touchUpInside)
        
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        let bagBarButton = UIBarButtonItem(customView: bagButton)
        navigationItem.rightBarButtonItems = [bagBarButton, searchBarButton]
    }
    
    func leftBarAction() {}
    func searchBarAction() {}
    func bagBarAction() {}
    
    @objc private func tappedLeftBarButton(sender : UIButton) {
        leftBarAction()
    }
    
    @objc private func tappedSearchBarButton(sender : UIButton) {
        searchBarAction()
    }
    
    @objc private func tappedBagBarButton(sender : UIButton) {
        bagBarAction()
    }
}
