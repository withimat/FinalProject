//
//  SepetViewModel.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation
import RxSwift

class SepetViewModel {
    var UrunlerRepo = UrunlerRepository()
    var sepetListesi = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    
    init() {
        sepetListesi = UrunlerRepo.sepetListesi
    }
    func sepetiGetir(){
        UrunlerRepo.sepettekiUrunleriGetir()
    }
    
    
    func urunuSil(sepetId: Int, kullaniciAdi: String){
        UrunlerRepo.sil(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
        sepetiGetir()
    }
    
}
