//
//  DetailViewController.swift
//  mvvm-combine-uikit
//
//  Created by Thân Văn Thanh on 30/08/2023.
//

import UIKit
import Combine
import SDWebImage

final class DetailViewController: BaseViewController {

    @IBOutlet private  weak var nameTitle: UILabel!
    @IBOutlet private weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewmodel = viewModel as? DetailViewModel else { return }
        
        nameTitle.text = viewmodel.repo.login
        avatarImage.sd_setImage(with: URL(string: viewmodel.repo.avatarUrl))
    }

}


