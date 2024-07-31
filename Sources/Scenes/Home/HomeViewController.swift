//
//  HomeViewController.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit

final class HomeViewCoordinator: Coordinator {
    static let shared = HomeViewCoordinator()
    func start(data: Any?) {
        guard let window = data as? UIWindow else { return }
        let vc = HomeViewController()
        vc.viewModel = HomeViewModel(getHomeData: HomeRequest())
        let nav = UINavigationController(rootViewController: vc)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}

class HomeViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    enum Section: Int, Hashable {
        case collection
        case newArrival
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, HomeModel>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupTableView()
        configureDataSource()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
    }
}

// MARK: - Private
private extension HomeViewController {
    func setupTableView() {
        tableView.register(cell: CollectionTableViewCell.self)
        tableView.register(cell: NewArrivalTableViewCellTableViewCell.self)
        
        tableView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, HomeModel>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            switch Section(rawValue: indexPath.section) {
            case .collection:
                let cell = tableView.dequeueReusableCell(
                    cell: CollectionTableViewCell.self,
                    indexPath: indexPath)
                cell.config(image: itemIdentifier.collection.listCollection)
                return cell
            case .newArrival:
                let cell = tableView.dequeueReusableCell(
                    cell: NewArrivalTableViewCellTableViewCell.self,
                    indexPath: indexPath)
                cell.configCell(arrFilter: ["All", "Apparel", "Dress", "Tshirt", "Bag"])
                return cell
            case .none:
                return UITableViewCell()
            }
            
//            switch indexPath.row {
//            case 0:
//                let cell = tableView.dequeueReusableCell(
//                    cell: CollectionTableViewCell.self,
//                    indexPath: indexPath)
//                cell.config(image: itemIdentifier.collection.listCollection)
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(
//                    cell: NewArrivalTableViewCellTableViewCell.self,
//                    indexPath: indexPath)
//                cell.configCell(arrFilter: ["All", "Apparel", "Dress", "Tshirt", "Bag"])
//                return cell
//            default:
//                return UITableViewCell()
//            }
            
        }
        dataSource?.defaultRowAnimation = .fade
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .collection:
            return 600
        case .newArrival:
            return 736
        default:
            return UITableView.automaticDimension
        }
    }
}

