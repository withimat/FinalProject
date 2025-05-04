//
//  ViewController.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 24.04.2025.
//

import UIKit
import Kingfisher

class Anasayfa:  UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var UrunlerListesi = [Urunler]()
    

    
    @IBOutlet weak var myCollection: UICollectionView!
    let tasarim = UICollectionViewFlowLayout()
   
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        let ekranGenisligi = UIScreen.main.bounds.width
        let itemgenisligi = (ekranGenisligi - 30)/2
        
        
        
        myCollection.delegate = self
        myCollection.dataSource = self
        
    }

    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
   
    

}

extension Anasayfa {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UrunlerListesi.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrunlerHucre", for: indexPath) as! UrunlerHucre
        let urun = UrunlerListesi[indexPath.row]
        
        cell.urunAdi.text = urun.ad
        cell.urunFiyat.text = "\(String(describing: urun.fiyat)) ₺"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(String(describing: urun.ad))") {
            cell.ImageView.kf.setImage(with: url)
        }

        return cell
    }
    
}
