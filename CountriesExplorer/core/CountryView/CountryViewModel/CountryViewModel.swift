//
//  CountryManager.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import Foundation

protocol CountryViewModelDelegate: AnyObject {
    func countriesDidLoad()
    func countriesDidFail(with error: Error)
}

final class CountryViewModel {
    weak var delegate: CountryViewModelDelegate?
    private let manager: CountryManager
    private var countries: [Country] = []

    init(manager: CountryManager = CountryManager()) {
        self.manager = manager
    }

    func loadData() {
        do {
            countries = try manager.loadCountries()
            delegate?.countriesDidLoad()
        } catch {
            delegate?.countriesDidFail(with: error)
        }
    }

    var numberOfCountries: Int {
        countries.count
    }

    func country(at index: Int) -> Country {
        countries[index]
    }
}
