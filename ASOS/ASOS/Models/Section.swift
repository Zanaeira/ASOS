//
//  Section.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

enum Section: Int {
    
    case announcements
    case extraSales
    case featured
    case grid
    case special
    case sales
    case yourEdit
    case recent
    
    static func items(forSection section: Section) -> [Item] {
        switch section {
        case .announcements: return [.init(text: "Premier Delivery\n\nUnlimited free Next-Day Delivery for a whole year for £9.95",
                                           secondaryText: "Ts&Cs apply")]
        case .extraSales: return [.init(text: "EXTRA 20% OFF SALE\nCOATS & JACKETS\n(ALREADY UP TO 80% OFF)", secondaryText: "With code: WARMUP\n\nSale items only. See website banner for Tx&Cs. Selected marked products excluded from promo.")]
        case .featured: return [.init(text: "PITCH PERFECT", secondaryText: "Shop ASOS 4505", image: UIImage(named: "pitch-perfect"))]
        case .grid: return [.init(text: "FRED PERRY", secondaryText: "Always iconic", image: UIImage(named: "fred-perry")),
                            .init(text: "LOGO LOVE", secondaryText: "Ft. ASOS Dark Future", image: UIImage(named: "logo-love")),
                            .init(text: "TOPMAN", secondaryText: "Join the cargo craze", image: UIImage(named: "topman")),
                            .init(text: "FEET FIRST", secondaryText: "Top-tier trainers", image: UIImage(named: "feet-first"))]
        case .special: return [.init(text: "ADIDAS", secondaryText: "'das right", image: UIImage(named: "adidas")),
                               .init(text: "COSY CLUB", secondaryText: "You do knit wanna miss this", image: UIImage(named: "cosy-club"))]
        case .sales: return [.init(text: "SALE:\nUP TO 80% OFF\nFINAL DISCOUNTS!",
                                           secondaryText: "Limited time only. While stocks lack. Selected styles marked down on site.")]
        case .yourEdit: return [.init(text: "Your Edit", secondaryText: "We reckon you'll like this lot")]
        case .recent: return [.init(text: "adidas Running long sleeve top with grey colour block in black",
                                                          secondaryText: "", image: UIImage(named: "recent-1")),
                              .init(text: "ellesse t-shirt with logo in black",
                                                          secondaryText: "", image: UIImage(named: "recent-2")),
                              .init(text: "French Connection henley t-shirt in navy",
                                                          secondaryText: "", image: UIImage(named: "recent-3")),
                              .init(text: "Don't Think Twice slim fit jeans in dark blue",
                                                          secondaryText: "", image: UIImage(named: "recent-4")),
                              .init(text: "Selected Homme shirt with grandad collar in light blue",
                                                          secondaryText: "", image: UIImage(named: "recent-5")),
                              .init(text: "ASOS DESIGN organic long sleeve button through jersey shirt in washed khaki",
                                                          secondaryText: "", image: UIImage(named: "recent-6")),
                              .init(text: "French Connection slim jeans in dark grey",
                                                          secondaryText: "", image: UIImage(named: "recent-7")),
                              .init(text: "Calvin Klein Golf Voltron gilet in navy",
                                                          secondaryText: "", image: UIImage(named: "recent-8")),
                              .init(text: "ASOS DESIGN paka jacket in green with faux fur trim hood",
                                                          secondaryText: "", image: UIImage(named: "recent-9")),
                              .init(text: "Harry Brown cable knitted crew neck jumper",
                                                          secondaryText: "", image: UIImage(named: "recent-10"))]
        }
    }
    
}
