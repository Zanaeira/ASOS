//
//  Item.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

public struct Item: Hashable {
    
    public let id: UUID
    public let text: String
    public let secondaryText: String
    public let image: UIImage?
    public let isLiked: Bool
    public let section: Section
    
    public init(id: String, text: String = "", secondaryText: String = "", image: UIImage? = nil, isLiked: Bool = false, section: Section) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.text = text
        self.secondaryText = secondaryText
        self.image = image
        self.isLiked = isLiked
        self.section = section
    }
    
    static let stubs: [Item] = [
        .init(id: "CB351A42-B6B9-4954-8B55-1F377CC63484", text: "Premier Delivery\n\nUnlimited free Next-Day Delivery for a whole year for £9.95",
                                           secondaryText: "Ts&Cs apply", section: .announcements),
        .init(id: "49D27F07-14FB-4F91-A62F-80AB45B32DD0", text: "EXTRA 20% OFF SALE\nCOATS & JACKETS\n(ALREADY UP TO 80% OFF)", secondaryText: "With code: WARMUP\n\nSale items only. See website banner for Tx&Cs. Selected marked products excluded from promo.", section: .extraSales),
        .init(id: "6D9214F9-FA9B-4D1D-94C2-66199CA47DF1", text: "PITCH PERFECT", secondaryText: "Shop ASOS 4505", image: UIImage(named: "pitch-perfect"), section: .featured),
        .init(id: "A277C335-BC0D-4FF0-984B-F4F043B3F0AE", text: "FRED PERRY", secondaryText: "Always iconic", image: UIImage(named: "fred-perry"), section: .grid),
        .init(id: "B5F67381-8C7D-484C-AACE-AA77229E66CA", text: "LOGO LOVE", secondaryText: "Ft. ASOS Dark Future", image: UIImage(named: "logo-love"), section: .grid),
        .init(id: "8422EFBC-A5E2-40B5-B208-EAA6FEFD85C0", text: "TOPMAN", secondaryText: "Join the cargo craze", image: UIImage(named: "topman"), section: .grid),
        .init(id: "EB9F5E52-877E-4C61-B22E-068045B5FD9B", text: "FEET FIRST", secondaryText: "Top-tier trainers", image: UIImage(named: "feet-first"), section: .grid),
        .init(id: "F93F554E-C179-45C8-89BB-4D1018F6C350", text: "ADIDAS", secondaryText: "'das right", image: UIImage(named: "adidas"), section: .special),
        .init(id: "659C20C2-7F09-4DA3-909E-3A226608AA66", text: "COSY CLUB", secondaryText: "You do knit wanna miss this", image: UIImage(named: "cosy-club"), section: .special),
        .init(id: "4B7AD065-0975-48A2-A53C-FE10B3443372", text: "SALE:\nUP TO 80% OFF\nFINAL DISCOUNTS!", secondaryText: "Limited time only. While stocks lack. Selected styles marked down on site.", section: .sales),
        .init(id: "D8669A88-965F-43E7-A3F5-0D11D1E27D36", text: "Your Edit", secondaryText: "We reckon you'll like this lot", section: .yourEdit),
        .init(id: "56395118-8B0A-4D37-87AB-66E3F63F98D1", text: "adidas Running long sleeve top with grey colour block in black", secondaryText: "", image: UIImage(named: "recent-1"), isLiked: true, section: .recent),
        .init(id: "0D1A670A-69AB-4D6D-9913-4B282CC590C4", text: "ellesse t-shirt with logo in black", secondaryText: "", image: UIImage(named: "recent-2"), section: .recent),
        .init(id: "B8FF21F3-1902-4369-9375-AD3CBA7C39F9", text: "French Connection henley t-shirt in navy", secondaryText: "", image: UIImage(named: "recent-3"), isLiked: true, section: .recent),
        .init(id: "CEFA2B21-9E13-46D1-B46D-66153FDF10E8", text: "Don't Think Twice slim fit jeans in dark blue", secondaryText: "", image: UIImage(named: "recent-4"), section: .recent),
        .init(id: "8D1F8244-8865-406D-B885-39C84F51B2E6", text: "Selected Homme shirt with grandad collar in light blue", secondaryText: "", image: UIImage(named: "recent-5"), section: .recent),
        .init(id: "6D647A4C-C773-4978-B938-99AAE24798DD", text: "ASOS DESIGN organic long sleeve button through jersey shirt in washed khaki", secondaryText: "", image: UIImage(named: "recent-6"), section: .recent),
        .init(id: "BE4282CF-B59F-4FFC-A8A5-F0B869185A2E", text: "French Connection slim jeans in dark grey", secondaryText: "", image: UIImage(named: "recent-7"), section: .recent),
        .init(id: "A70884B8-B429-4313-83FF-803DD820035F", text: "Calvin Klein Golf Voltron gilet in navy", secondaryText: "", image: UIImage(named: "recent-8"), section: .recent),
        .init(id: "67A4BC5F-5DAD-493B-B1E8-DE26D3DD2088", text: "ASOS DESIGN paka jacket in green with faux fur trim hood", secondaryText: "", image: UIImage(named: "recent-9"), section: .recent),
        .init(id: "54BFF376-2D44-43C3-B02F-9CD5D67B5E7C", text: "Harry Brown cable knitted crew neck jumper", secondaryText: "", image: UIImage(named: "recent-10"), section: .recent)
    ]
    
}
