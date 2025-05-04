//
//  Repository.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//


import Foundation
import UIKit
import RxSwift
import Alamofire

class UrunlerRepository {
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var sepetListesi = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())
    var tumUrunler = [Urunler]()

    func sil(sepetId: Int, kullaniciAdi: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let parameters: Parameters = ["sepetId": sepetId, "kullaniciAdi": kullaniciAdi]

        AF.request(url, method: .post, parameters: parameters).response { response in
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    let cevap = try decoder.decode(CRUDCevap.self, from: data)
                    print("Başarı durumu: \(cevap.success ?? -1)")
                    print("Mesaj: \(cevap.message ?? "Mesaj yok")")
                } catch {
                    print("Hata oluştu: \(error.localizedDescription)")
                }
            } else {
                print("Veri alınamadı.")
            }

        }
    }

    
    
    
    
    
    func ara(aramaKelimesi: String) {
        if aramaKelimesi.isEmpty {
          
            urunlerListesi.onNext(tumUrunler)
        } else {
        
            let filtrelenmisListe = tumUrunler.filter { urun in
                return (urun.ad?.lowercased().contains(aramaKelimesi.lowercased()) ?? false)
                || (urun.marka?.lowercased().contains(aramaKelimesi.lowercased()) ?? false)
                || (urun.kategori?.lowercased().contains(aramaKelimesi.lowercased()) ?? false)
            }
            urunlerListesi.onNext(filtrelenmisListe)
        }
    }
    
    
    
    func urunleriYukle() {
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    if let liste = cevap.urunler {
                        self.tumUrunler = liste  // burada yedek alıyoruz
                        self.urunlerListesi.onNext(liste) // burada güncelliyoruz
                    }
                } catch {
                    print("Decode hatası: \(error.localizedDescription)")
                }
            } else {
                print("Veri gelmedi veya hata oluştu.")
            }
        }
    }



    func sepeteUrunEkle(sepet: UrunlerSepeti) {
      
        sepettekiUrunleriGetir()
        
        if let mevcutListe = try? sepetListesi.value() {
            
            if let mevcutUrun = mevcutListe.first(where: { $0.ad == sepet.ad }) {
            
                sil(sepetId: mevcutUrun.sepetId!, kullaniciAdi: "imat")
                
                let yeniSepet = UrunlerSepeti(
                    sepetId: 0,
                    ad: sepet.ad!,
                    resim: sepet.resim!,
                    kategori: sepet.kategori!,
                    fiyat: sepet.fiyat!,
                    marka: sepet.marka!,
                    siparisAdeti: (mevcutUrun.siparisAdeti ?? 0) + (sepet.siparisAdeti ?? 0),
                    kullaniciAdi: sepet.kullaniciAdi!
                )
                
                let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                let params: [String: Any] = [
                    "ad": yeniSepet.ad!,
                    "resim": yeniSepet.resim!,
                    "kategori": yeniSepet.kategori!,
                    "fiyat": yeniSepet.fiyat!,
                    "marka": yeniSepet.marka!,
                    "siparisAdeti": yeniSepet.siparisAdeti!,
                    "kullaniciAdi": "imat"
                ]
                
                AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
                    if let data = response.data {
                        do {
                            let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                            if cevap.success == 1 {
                                print("Ürün başarıyla güncellendi.")
                                self.sepettekiUrunleriGetir()
                            } else {
                                print("Güncelleme başarısız.")
                            }
                        } catch {
                            print("JSON Decode hatası guncelle : \(error.localizedDescription)")
                        }
                    } else {
                        print("Veri yok veya istek hatalı.")
                    }
                }
            } else {
              
                let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
                let params: [String: Any] = [
                    "ad": sepet.ad!,
                    "resim": sepet.resim!,
                    "kategori": sepet.kategori!,
                    "fiyat": sepet.fiyat!,
                    "marka": sepet.marka!,
                    "siparisAdeti": sepet.siparisAdeti!,
                    "kullaniciAdi": "imat"
                ]
                
                AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
                    if let data = response.data {
                        do {
                            let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                            if cevap.success == 1 {
                                print("Ürün başarıyla sepete eklendi.")
                                self.sepettekiUrunleriGetir()
                            } else {
                                print("Başarısız ekleme.")
                            }
                        } catch {
                            print("JSON Decode hatası: \(error.localizedDescription)")
                        }
                    } else {
                        print("Veri yok veya istek hatalı.")
                    }
                }
            }
        }
    }
    
    
    
    
    
    func sepettekiUrunleriGetir() {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        let params: [String: Any] = [
            "kullaniciAdi": "imat"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default).response { response in
            if let data = response.data {
            
              

                do {
                    let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                    if let liste = cevap.urunler_sepeti {
                        self.sepetListesi.onNext(liste)
                    } else {
                        print("Sepette ürün bulunamadı.")
                    }
                } catch {
                    print("JSON Decode hatası sepetteki urunler: \(error.localizedDescription)")
                }
            } else {
                print("Veri yok veya istek hatalı.")
            }
        }

    }

    
    
    
    

}

