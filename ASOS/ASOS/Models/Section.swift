//
//  Section.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

enum Section: Int {
    case announcements
    case sales
    case featured
    case grid
    
    static func items(forSection section: Section) -> [Item] {
        switch section {
        case .announcements: return [.init(text: "Premier Delivery\n\nUnlimited free Next-Day Delivery for a whole year for £9.95",
                                           secondaryText: "Ts&Cs apply")]
        case .sales: return [.init(text: "SALE:\nUP TO 80% OFF\nFINAL DISCOUNTS!",
                                           secondaryText: "Limited time only. While stocks lack. Selected styles marked down on site.")]
        case .featured: return [.init(text: "PITCH PERFECT", secondaryText: "Shop ASOS 4505", image: UIImage(named: "pitch-perfect"))]
        case .grid: return [.init(text: "FRED PERRY", secondaryText: "Always iconic", image: UIImage(named: "fred-perry")),
                            .init(text: "LOGO LOVE", secondaryText: "Ft. ASOS Dark Future", image: UIImage(named: "logo-love")),
                            .init(text: "TOPMAN", secondaryText: "Join the cargo craze", image: UIImage(named: "topman")),
                            .init(text: "FEET FIRST", secondaryText: "Top-tier trainers", image: UIImage(named: "feet-first"))]
        }
    }
}
