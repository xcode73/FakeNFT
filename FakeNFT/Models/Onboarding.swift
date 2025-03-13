//
//  OnboardingItem.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 13.03.2025.
//

import UIKit

struct Onboarding: Equatable {
    let image: UIImage
    let title: String
    let description: String
    let buttonTitle: String?
}

extension Onboarding {
    static let items: [Onboarding] = [
        Onboarding(
            image: .imgOnboarding1,
            title: "Исследуйте",
            description: "Присоединяйтесь и откройте новый мир уникальных NFT для коллекционеров",
            buttonTitle: nil
        ),
        Onboarding(
            image: .imgOnboarding2,
            title: "Коллекционируйте",
            description: "Пополняйте свою коллекцию эксклюзивными картинками, созданными нейросетью!",
            buttonTitle: nil
        ),
        Onboarding(
            image: .imgOnboarding3,
            title: "Состязайтесь",
            description: "Смотрите статистику других и покажите всем, что у вас самая ценная коллекция",
            buttonTitle: "Что внутри?"
        )
    ]
}
