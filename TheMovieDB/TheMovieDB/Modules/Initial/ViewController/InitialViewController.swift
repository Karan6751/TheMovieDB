//
//  InitialViewController.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        changeRoot()
    }
    
    private func changeRoot() {
        let designatedController = AppFactoryDIContainer.shared.makeSearchMovieViewController()
        let navigationController = UINavigationController(rootViewController: designatedController)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
