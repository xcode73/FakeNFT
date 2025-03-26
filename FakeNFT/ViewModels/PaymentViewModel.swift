//
//  PaymentViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 18.02.2025.
//

import Foundation
import Dependencies

// MARK: - Protocol
protocol PaymentViewModelProtocol {
    var onItemsUpdate: (() -> Void)? { get set }
    var onPaymentProcessingStart: (() -> Void)? { get set }
    var onPaymentError: (() -> Void)? { get set }

    var paymentMethodCount: Int { get }

    func getItem(at index: Int) -> CurrencyCard
    func loadData()
    func setSelectedCurrencyIndex(_ index: Int)
    func getSelectedCurrencyIndex() -> Int?
    func isCurrencySelected() -> Bool
    func paymentProcessing()
}

// MARK: - Implementation
final class PaymentViewModel: PaymentViewModelProtocol {
    @Dependency(\.orderService) var orderService

    var onItemsUpdate: (() -> Void)?
    var onPaymentProcessingStart: (() -> Void)?
    var onPaymentError: (() -> Void)?

    var paymentMethodCount: Int {
        currencyCards.count
    }

    private var selectedCurrencyIndex: Int?
    private var currencyCards: [CurrencyCard] = []

    // MARK: - Public Methods

    func getItem(at index: Int) -> CurrencyCard {
        currencyCards[index]
    }

    func loadData() {
        orderService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.currencyCards = currencies.map { currency in
                    CurrencyCard(
                        name: currency.title,
                        shortName: currency.name,
                        imageURL: currency.image
                    )
                }
                self?.onItemsUpdate?()
            case .failure(let error):
                assertionFailure("Error: \(error) in \(#function) \(#file)")
                self?.onPaymentError?()
            }
        }
    }

    func setSelectedCurrencyIndex(_ index: Int) {
        selectedCurrencyIndex = index
    }

    func getSelectedCurrencyIndex() -> Int? {
        return selectedCurrencyIndex
    }

    func isCurrencySelected() -> Bool {
        return selectedCurrencyIndex != nil
    }

    func paymentProcessing() {
        guard let id = selectedCurrencyIndex else {
            return
        }

        orderService.setCurrencyBeforePayment(id: "\(id)") { [weak self] result in
            switch result {
            case .success(let response):
                if response.success == true {
                    self?.onPaymentProcessingStart?()
                } else {
                    self?.onPaymentError?()
                }
            case .failure(let error):
                print("Error: \(error) in \(#function) \(#file)")
                self?.onPaymentError?()
            }
        }
    }
}
