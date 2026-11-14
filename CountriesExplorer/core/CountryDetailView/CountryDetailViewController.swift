//
//  CountryDetailViewController.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import UIKit

final class CountryDetailViewController: UITableViewController {
    private let viewModel: CountryDetailViewModel
    var onShowCurrency: (() -> Void)?

    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        let flag = UIImageView(image: UIImage(named: viewModel.flag))
        flag.contentMode = .scaleAspectFit
        flag.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 160)
        tableView.tableHeaderView = flag
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Información" : "Estados"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? viewModel.information.count : viewModel.states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if indexPath.section == 0 {
            let info = viewModel.information[indexPath.row]
            content.text = info.title
            content.secondaryText = info.value
            cell.accessoryType = info.field == .currency ? .disclosureIndicator : .none
        } else {
            content.text = viewModel.states[indexPath.row].nombre
            cell.accessoryType = .disclosureIndicator
        }
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && viewModel.information[indexPath.row].field != .currency {
            return nil
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            onShowCurrency?()
        } else {
            let state = viewModel.states[indexPath.row]
            let places = PointsOfInterestViewController(state: state)
            navigationController?.pushViewController(places, animated: true)
        }
    }
}
