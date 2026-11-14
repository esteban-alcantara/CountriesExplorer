//
//  CurrencyModel.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//


import Foundation

struct CurrencyModel {
    let currencies: [CountryCurrency]
    let rates: [String: [String: Decimal]]

    func convert(_ amount: Decimal, from source: CountryCurrency, to destination: CountryCurrency) -> Decimal? {
        guard let rate = rates[source.codigo]?[destination.codigo] else { return nil }
        let result = amount * rate
        return result
    }
}
