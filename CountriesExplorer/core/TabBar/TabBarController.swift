//
//  TabBarController.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews(){
        
        //MARK: Country View
        //Instanciamos El viewController
        let countryViewController = CountryViewController()
        //Embebemos el viewController en un navigation Controller
        let countryNavigation = UINavigationController(rootViewController: countryViewController)
        countryNavigation.tabBarItem.title = "Countries"
        countryNavigation.tabBarItem.image = UIImage(systemName: "globe.americas")
        countryNavigation.tabBarItem.selectedImage = UIImage(systemName: "globe.americas.fill")
        
        
        //MARK: Currency View
        //Instanciamos El viewController
        let currencyViewController = CurrencyViewController()
        //Embebemos el viewController en un navigation Controller
        let currencyNavigation = UINavigationController(rootViewController: currencyViewController)
        currencyNavigation.tabBarItem.title = "Currency"
        currencyNavigation.tabBarItem.image = UIImage(systemName: "dollarsign.building.classical")
        currencyNavigation.tabBarItem.selectedImage = UIImage(systemName: "dollarsign.building.classical.fill")
        
        
        //MARK: ViewControllers ARRAY
        let viewControllers: [UIViewController] = [countryNavigation, currencyNavigation]
        self.viewControllers = viewControllers
        self.selectedIndex = 0
    }
    
    

}

