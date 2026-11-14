//
//  CountryDetailModel.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import Foundation

struct CountryDetailInfo {
    enum Field {
        case capital, language, currency
    }

    let field: Field
    let title: String
    let value: String
}
