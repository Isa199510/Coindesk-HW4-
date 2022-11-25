//
//  ViewController.swift
//  Coindesk(HW4)
//
//  Created by Иса on 24.11.2022.
//

import UIKit

class CoindeskViewController: UIViewController {
    
    @IBOutlet var bpiHeaderLabel: UILabel!
    @IBOutlet var bpiFooterLabel: UILabel!
    @IBOutlet var bpiTextField: UITextField!

    private var pickerViewForBPI = UIPickerView()
    private var coindesk: Coindesk?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerViewForBPI.delegate = self
        pickerViewForBPI.dataSource = self
        bpiTextField.inputView = pickerViewForBPI
        
        fetchDataAF()
    }
}

// MARK: Extension CoindeskViewController
extension CoindeskViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func fetchDataAF() {
        NetworkManager.shared.fetchAF(from: Link.urlCoindesk.rawValue) { [weak self] result in
            switch result {
            case .success(let coindesk):
                self?.coindesk = coindesk
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Extension UIPickerView
extension CoindeskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let bpi = coindesk?.bpi else { return "" }
        
        switch row {
        case 0: return bpi.USD.code
        case 1: return bpi.GBP.code
        default: return bpi.EUR.code
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let bpi = coindesk?.bpi else { return }
        bpiHeaderLabel.text = coindesk?.descriptionHeader
        
        switch row {
        case 0:
            bpiTextField.text = bpi.USD.code
            bpiFooterLabel.text = coindesk?.bpi.USD.descriptionCurency
        case 1:
            bpiTextField.text = bpi.GBP.code
            bpiFooterLabel.text = coindesk?.bpi.GBP.descriptionCurency
        default:
            bpiTextField.text = bpi.EUR.code
            bpiFooterLabel.text = coindesk?.bpi.EUR.descriptionCurency
        }
    }
}
