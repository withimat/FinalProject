//
//  AnasayfaViewModel.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
        
    var UrunlerRepo = UrunlerRepository()
    var UrunlerListesi = BehaviorSubject<[Urunler]>(value:  [Urunler]())

    init() {
        UrunlerListesi = UrunlerRepo.urunlerListesi
    }
    
    func ara (aramaKelimesi: String){
        UrunlerRepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    
    
    func urunleriYukle(){
        UrunlerRepo.urunleriYukle() //Tetikleme trigger
    }
    
    
    
}
