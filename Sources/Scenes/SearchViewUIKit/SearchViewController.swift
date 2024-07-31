//
//  SearchViewController.swift
//  base-combine
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    enum Section: Hashable {
        case main
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let searchTextSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Search"
        setupTableView()
        configDataSource()
    }
    
    private func configDataSource() {
        
    }
    
    private func setupTableView() {
        tableView.register(cell: SearchTableViewCell.self)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewmodel = viewModel as? SearchViewModel else { return }
        
        let input = SearchViewModel.Input(trigger: Driver.just("thanvanthanh"),
                                          searchTrigger: searchTextSubject.asDriverOnErrorJustComplete())
        let output = viewmodel.transform(input)
        
        output.searchResponse
            .drive(tableView.rx.items(cellIdentifier: SearchTableViewCell.cellId,
                                      cellType: SearchTableViewCell.self))
        { row, element, cell in
            cell.config(data: element)
        }
        ~ rx.disposeBag
        
        tableView
            .rx
            .modelSelected(SearchModel.self)
            .do(onNext: { user in
                DetailViewCoordinator.shared.start(data: user)
            })
            .subscribe()
        ~ rx.disposeBag
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextSubject.onNext(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTextSubject.onNext("")
    }
}
