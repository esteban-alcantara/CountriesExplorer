//
//  CurrencyManager.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import Foundation

private enum LocalJSONError: LocalizedError {
    case fileNotFound(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "No se encontró el archivo: \(name)"
        }
    }
}


final class CurrencyManager {

    func loadConversion() throws -> CurrencyModel {
        guard let url = Bundle.main.url(forResource: "currency_conversion", withExtension: "json") else {
            throw LocalJSONError.fileNotFound("currency_conversion.json")
        }

        let data = try Data(contentsOf: url)
        let rates = try JSONDecoder().decode([String: [String: Decimal]].self, from: data)
        let countries = try CountryManager().loadCountries()
        var codes = Set<String>()
        let currencies = countries.map(\.moneda).filter { codes.insert($0.codigo).inserted }
        return CurrencyModel(currencies: currencies, rates: rates)
    }

}
