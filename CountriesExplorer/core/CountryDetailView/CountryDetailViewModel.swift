//
//  CountryDetailViewModel.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import Foundation

final class CountryDetailViewModel {
    private let country: Country

    init(country: Country) {
        self.country = country
    }

    var title: String { country.nombre }
    var flag: String { country.bandera }
    var states: [CountryState] { country.estados }

    var information: [CountryDetailInfo] {
        [
            CountryDetailInfo(field: .capital, title: "Capital", value: country.capital),
            CountryDetailInfo(field: .language, title: "Idioma", value: country.idioma),
            CountryDetailInfo(field: .currency, title: "Moneda", value: "\(country.moneda.nombre) (\(country.moneda.codigo))")
        ]
    }
}
