//
//  Item.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

public struct Item: Hashable {
    
    private let id = UUID()
    public let text: String
    public let secondaryText: String
    public let image: UIImage?
    
    public let section: Section
    
    public init(text: String = "", secondaryText: String = "", image: UIImage? = nil, section: Section) {
        self.text = text
        self.secondaryText = secondaryText
        self.image = image
        self.section = section
    }
    
    static let stubs: [Item] = [
        .init(text: "Premier Delivery\n\nUnlimited free Next-Day Delivery for a whole year for £9.95",
                                           secondaryText: "Ts&Cs apply", section: .announcements),
        .init(text: "EXTRA 20% OFF SALE\nCOATS & JACKETS\n(ALREADY UP TO 80% OFF)", secondaryText: "With code: WARMUP\n\nSale items only. See website banner for Tx&Cs. Selected marked products excluded from promo.", section: .extraSales),
        .init(text: "PITCH PERFECT", secondaryText: "Shop ASOS 4505", image: UIImage(named: "pitch-perfect"), section: .featured),
        .init(text: "FRED PERRY", secondaryText: "Always iconic", image: UIImage(named: "fred-perry"), section: .grid),
        .init(text: "LOGO LOVE", secondaryText: "Ft. ASOS Dark Future", image: UIImage(named: "logo-love"), section: .grid),
        .init(text: "TOPMAN", secondaryText: "Join the cargo craze", image: UIImage(named: "topman"), section: .grid),
        .init(text: "FEET FIRST", secondaryText: "Top-tier trainers", image: UIImage(named: "feet-first"), section: .grid),
        .init(text: "ADIDAS", secondaryText: "'das right", image: UIImage(named: "adidas"), section: .special),
        .init(text: "COSY CLUB", secondaryText: "You do knit wanna miss this", image: UIImage(named: "cosy-club"), section: .special),
        .init(text: "SALE:\nUP TO 80% OFF\nFINAL DISCOUNTS!", secondaryText: "Limited time only. While stocks lack. Selected styles marked down on site.", section: .sales),
        .init(text: "Your Edit", secondaryText: "We reckon you'll like this lot", section: .yourEdit),
        .init(text: "adidas Running long sleeve top with grey colour block in black", secondaryText: "", image: UIImage(named: "recent-1"), section: .recent),
        .init(text: "ellesse t-shirt with logo in black", secondaryText: "", image: UIImage(named: "recent-2"), section: .recent),
        .init(text: "French Connection henley t-shirt in navy", secondaryText: "", image: UIImage(named: "recent-3"), section: .recent),
        .init(text: "Don't Think Twice slim fit jeans in dark blue", secondaryText: "", image: UIImage(named: "recent-4"), section: .recent),
        .init(text: "Selected Homme shirt with grandad collar in light blue", secondaryText: "", image: UIImage(named: "recent-5"), section: .recent),
        .init(text: "ASOS DESIGN organic long sleeve button through jersey shirt in washed khaki", secondaryText: "", image: UIImage(named: "recent-6"), section: .recent),
        .init(text: "French Connection slim jeans in dark grey", secondaryText: "", image: UIImage(named: "recent-7"), section: .recent),
        .init(text: "Calvin Klein Golf Voltron gilet in navy", secondaryText: "", image: UIImage(named: "recent-8"), section: .recent),
        .init(text: "ASOS DESIGN paka jacket in green with faux fur trim hood", secondaryText: "", image: UIImage(named: "recent-9"), section: .recent),
        .init(text: "Harry Brown cable knitted crew neck jumper", secondaryText: "", image: UIImage(named: "recent-10"), section: .recent)
    ]
    
}
