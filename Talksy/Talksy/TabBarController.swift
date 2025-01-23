//
//  TabBarController.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Coordinator
    var onChatsFlowSelect: ((UINavigationController) -> ())?
    var onProfileFlowSelect: ((UINavigationController) -> ())?
    
    // MARK: - Tabs
    private lazy var chatsTab: UINavigationController = {
        let chatsVC = ChatsViewController()
        let nc = UINavigationController(rootViewController: chatsVC)
        nc.tabBarItem = UITabBarItem(title: "Чаты", image: UIImage(named: "tabbar.chats"), tag: 0)
        return nc
    }()
    
    private lazy var profileTab: UINavigationController = {
        let profileVC = ProfileViewController()
        let nc = UINavigationController(rootViewController: profileVC)
        nc.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(named: "tabbar.profile"), tag: 1)
        return nc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        onChatsFlowSelect?(chatsTab)
        viewControllers = [chatsTab, profileTab]
    }
    
    private func selectTab() {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else {
            return
        }
        switch selectedIndex {
        case 0:
            onChatsFlowSelect?(controller)
        case 1:
            onProfileFlowSelect?(controller)
        default:
            break
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectTab()
    }
}
