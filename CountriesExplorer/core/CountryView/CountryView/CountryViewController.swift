//
//  CountryViewController.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import UIKit

final class CountryViewController: UIViewController {
    private let viewModel = CountryViewModel()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        view.backgroundColor = .systemBackground

        collectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: CountryCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

        viewModel.delegate = self
        viewModel.loadData()
    }

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension CountryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCountries
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        if let countryCell = cell as? CountryCollectionViewCell {
            countryCell.configure(with: viewModel.country(at: indexPath.item))
        }
        return cell
    }
}

extension CountryViewController: CountryViewModelDelegate {
    func countriesDidLoad() {
        collectionView.backgroundView = nil
        collectionView.reloadData()
    }

    func countriesDidFail(with error: Error) {
        let message = UILabel()
        message.text = error.localizedDescription
        message.numberOfLines = 0
        message.textAlignment = .center
        collectionView.backgroundView = message
    }
}

extension CountryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let country = viewModel.country(at: indexPath.item)
        let detail = CountryDetailViewController(viewModel: CountryDetailViewModel(country: country))
        detail.onShowCurrency = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
            self?.navigationController?.popToRootViewController(animated: false)
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}
