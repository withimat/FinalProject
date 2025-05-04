//
//  UrunlerCevap.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation

class UrunlerCevap: Codable{
    var urunler: [Urunler]?
    var success : Int?
}


class SepetCevap: Codable{
    var urunler_sepeti: [UrunlerSepeti]?
    var success : Int?
}
