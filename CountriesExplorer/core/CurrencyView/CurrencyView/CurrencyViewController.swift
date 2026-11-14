//
//  CurrencyViewController.swift
//  CountriesExplorer
//
//  Created by Daniel Esteban Alcantara on 13/11/26.
//

import UIKit

final class CurrencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet private weak var sourcePicker: UIPickerView!
    @IBOutlet private weak var destinationPicker: UIPickerView!
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var convertButton: UIButton!

    private let resultLabel = UILabel()
    private let manager = CurrencyManager()
    private var conversion: CurrencyModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency Conversion"
        setUpResultLabel()

        do {
            conversion = try manager.loadConversion()
        } catch {
            resultLabel.text = error.localizedDescription
        }

        for picker in [sourcePicker!, destinationPicker!] {
            picker.dataSource = self
            picker.delegate = self
        }
        let count = conversion?.currencies.count ?? 0
        convertButton.isEnabled = count > 0
        if count > 1 {
            destinationPicker.selectRow(1, inComponent: 0, animated: false)
        }
        
        amountField.addTarget(self, action: #selector(clearResult), for: .editingChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    private func setUpResultLabel() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        resultLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: 8),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            convertButton.topAnchor.constraint(greaterThanOrEqualTo: resultLabel.bottomAnchor, constant: 8)
        ])
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        conversion?.currencies.count ?? 0
    }


    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.text = conversion?.currencies[row].nombre
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontSizeToFitWidth = true
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 48 }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        clearResult()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        amountField.isFirstResponder && touch.view?.isDescendant(of: amountField) == false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    @objc private func closeKeyboard() {
        amountField.resignFirstResponder()
    }

    @objc private func clearResult() {
        if convertButton.isEnabled { resultLabel.text = nil }
    }

    @IBAction private func convertAmount(_ sender: UIButton) {
        closeKeyboard()
        guard let conversion, !conversion.currencies.isEmpty else { return }
        let input = (amountField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let normalized = input.replacingOccurrences(of: ",", with: ".")
        guard normalized.wholeMatch(of: #/[0-9]+(?:\.[0-9]+)?/#) != nil,
              let amount = Decimal(string: normalized, locale: Locale(identifier: "en_US_POSIX")) else {
            resultLabel.text = "Ingresa un monto válido."
            return
        }
        let source = conversion.currencies[sourcePicker.selectedRow(inComponent: 0)]
        let destination = conversion.currencies[destinationPicker.selectedRow(inComponent: 0)]
        guard let result = conversion.convert(amount, from: source, to: destination) else {
            resultLabel.text = "No se pudo convertir el monto."
            return
        }
        resultLabel.text = result.formatted(.currency(code: destination.codigo).presentation(.isoCode))
    }
}
