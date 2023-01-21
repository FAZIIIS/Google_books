//
//  MainTabBar.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    var mainScreen = MainScreenViewController()
    var favoritesScreen = FavoritesScreenViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            generateNavigationController(rootViewController: mainScreen, image: "book", title: "Главная"),
            generateNavigationController(rootViewController: favoritesScreen, image: "heart", title: "Избранное"),
        ]
    }
    
    
//MARK: - TabBarGeneration
    
    private func generateNavigationController(rootViewController: UIViewController, image: String, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        navigationVC.tabBarItem.title = title
        
        tabBar.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        tabBar.backgroundColor = .white
        
        return navigationVC
    }
    
}


//MARK: - TAB BAR EXTENSION FOR ANIMATE HIDING AND SHOWING TAB

extension UITabBarController: UINavigationControllerDelegate {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        let tabBarHeight: CGFloat = tabBar.frame.size.height
        let tabBarPositionY: CGFloat = UIScreen.main.bounds.height - (hidden ? 0 : tabBarHeight)
        
        guard animated else {
            tabBar.frame.origin.y = tabBarPositionY
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.tabBar.frame.origin.y = tabBarPositionY
        }
    }
}

