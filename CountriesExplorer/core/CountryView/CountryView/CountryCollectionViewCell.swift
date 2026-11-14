//
//  CountryCollectionViewCell.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//


import UIKit

final class CountryCollectionViewCell: UICollectionViewListCell {
    static let reuseIdentifier = "CountryCell"

    func configure(with country: Country) {
        var content = UIListContentConfiguration.cell()
        content.text = country.nombre
        content.textProperties.numberOfLines = 0
        content.image = UIImage(named: country.bandera)
        content.imageProperties.maximumSize = CGSize(width: 45, height: 30)
        contentConfiguration = content
    }
}
