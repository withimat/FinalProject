//
//  Urunler.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation

class Urunler:Codable{
    var id : Int?
    var ad : String?
    var resim : String?
    var kategori : String?
    var fiyat : Int?
    var marka: String?
    
    
    init() {
       // print("bos init")
    }
    
    init(id: Int, ad: String, resim: String,kategori:String,fiyat:Int,marka:String) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
//        print("dolu init")
    }
}
