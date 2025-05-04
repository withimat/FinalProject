//
//  DetayViewController.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import UIKit


class Detay: UIViewController {
    var urun: Urunler?
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var LabelMarka: UILabel!
    @IBOutlet weak var adetBilgisi: UILabel!
    @IBOutlet weak var toplamTutarLabel: UILabel!
    @IBOutlet weak var LabelKategori: UILabel!
    var adet: Int = 1
    var detayViewModel = DetayViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Renk1")
    
        self.navigationItem.hidesBackButton = true
            
        let geriButonu = UIBarButtonItem(
             image: UIImage(systemName: "chevron.backward"),
             style: .plain,
             target: self,
             action: #selector(kapatTiklandi)
         )
         geriButonu.tintColor = .white
         self.navigationItem.leftBarButtonItem = geriButonu
     
        if let urun = urun {
            adLabel.text = urun.ad
            fiyatLabel.text = "\(urun.fiyat!) ₺"
            adetBilgisi.text = "\(adet)"
            LabelMarka.text = urun.marka
            hesaplaToplamTutar()
            LabelKategori.text = urun.kategori

            navigationItem.title = urun.ad
            
            if let resimAdi = urun.resim,
               let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)") {
                ImageView.kf.setImage(with: url)
            }
        }
    }

    func hesaplaToplamTutar() {
        if let fiyat = urun?.fiyat {
            let toplamTutar = adet*fiyat
            toplamTutarLabel.text = "Toplam: \(toplamTutar) ₺"
        }
    }
    
    @objc func kapatTiklandi() {
        self.navigationController?.popViewController(animated: true)
        if urun != nil {
            adet = 1
        }
    }
    

    @IBAction func eksiButton(_ sender: Any) {
  
        if adet > 1 {
            adet -= 1
            adetBilgisi.text = "\(adet)"
            hesaplaToplamTutar()
        }
    }
    
    @IBAction func artiButton(_ sender: Any) {

        adet += 1
        adetBilgisi.text = "\(adet)"
        hesaplaToplamTutar()
    }
    
   
    
    @IBAction func ButtonSepeteEkle(_ sender: Any) {
        if let urun = urun {
            detayViewModel.sepeteEkle(urun: urun, adet: adet)
            
            let alert = UIAlertController(title: "Başarılı", message: "\(urun.ad ?? "Ürün") sepete eklendi.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.hidesBackButton = true
    }
    
    
}
