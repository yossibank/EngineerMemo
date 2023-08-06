import UIKit

protocol UIAppearanceProtocol {
    func configureAppearance()
}

extension UIAppearanceProtocol {
    func configureAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .background
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        UINavigationBar.appearance().tintColor = .primary
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .background
        tabBarAppearance.shadowColor = .clear
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.primary
        ]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        UIScrollView.appearance().configure {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }

        UITableView.appearance().configure {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.sectionHeaderTopPadding = .zero
        }

        UICollectionView.appearance().configure {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
}
