//
//  HomeViewController.swift
//  Base-ios
//
//  Created by Than Van Thanh on 29/7/24.
//

import UIKit
import Combine

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
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, HomeModel>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        setupTableView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
        let input = HomeViewModel.Input(
            loadTrigger: Just(()).eraseToAnyPublisher())
        
        let output = viewModel.transform(input, disposeBag)
        output.$response
            .subscribe(repoSubscriber)
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
            print(itemIdentifier)
            print(indexPath)
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(
                    cell: CollectionTableViewCell.self,
                    indexPath: indexPath)
                cell.config(image: itemIdentifier.collection.listCollection)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(
                    cell: NewArrivalTableViewCellTableViewCell.self,
                    indexPath: indexPath)
                return cell
            default:
                return UITableViewCell()
            }
            
        }
        dataSource?.defaultRowAnimation = .fade
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 600
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - Binder
private extension HomeViewController {
    var repoSubscriber: Binder<[HomeModel]> {
        Binder(self) {vc, repos in
            var snapshot = NSDiffableDataSourceSnapshot<Section, HomeModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(repos, toSection: .main)
            vc.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}
