//
//  UrunlerSepeti.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation

class UrunlerSepeti : Codable {
    var sepetId: Int?
    var ad : String?
    var resim : String?
    var kategori : String?
    var fiyat : Int?
    var marka : String?
    var siparisAdeti : Int?
    var kullaniciAdi : String?
    
    
    init(sepetId: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int, kullaniciAdi: String) {
        self.sepetId = sepetId
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
        self.siparisAdeti = siparisAdeti
        self.kullaniciAdi = kullaniciAdi
    }
    
    
}
