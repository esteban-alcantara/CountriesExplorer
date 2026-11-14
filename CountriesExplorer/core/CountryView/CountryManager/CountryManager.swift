//
//  CountryManager.swift
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


final class CountryManager {
    
    func loadCountries() throws -> [Country] {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            throw LocalJSONError.fileNotFound("countries.json")
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Country].self, from: data)
    }
    
}
