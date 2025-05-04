//
//  DetayViewModel.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation
import RxSwift



class DetayViewModel {
    var UrunlerRepo = UrunlerRepository()
    var UrunlerListesi = BehaviorSubject<[Urunler]>(value:  [Urunler]())
    
    func sepeteEkle(urun: Urunler, adet: Int) {
        let sepetUrun = UrunlerSepeti(
            sepetId: 0, 
            ad: urun.ad ?? "",
            resim: urun.resim ?? "",
            kategori: urun.kategori ?? "",
            fiyat: urun.fiyat ?? 0,
            marka: urun.marka ?? "",
            siparisAdeti: adet,
            kullaniciAdi: "imat"
        )
        
        UrunlerRepo.sepeteUrunEkle(sepet: sepetUrun)
    }
}

