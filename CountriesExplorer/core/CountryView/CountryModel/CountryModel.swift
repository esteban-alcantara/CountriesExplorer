//
//  CountryModel.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import Foundation


struct Country: Decodable {
    let nombre: String
    let capital: String
    let bandera: String
    let idioma: String
    let moneda: CountryCurrency
    let estados: [CountryState]
}

struct CountryCurrency: Decodable {
    let nombre: String
    let codigo: String
}

struct CountryState: Decodable {
    let nombre: String
    let lugares: [String]
}
