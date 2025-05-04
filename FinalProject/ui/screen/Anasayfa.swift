//
//  ViewController.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 24.04.2025.
//
import UIKit
import Kingfisher
import RxSwift
import Lottie

class Anasayfa: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    var UrunlerListesi = [Urunler]()
    var anasayfaViewModel = AnasayfaViewModel()
    let tasarim = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Gokaslan Store"

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "Renk3")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Tangerine-Bold", size: 30)!
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        mySearchBar.barTintColor = UIColor(named: "AnaRenk")
        mySearchBar.backgroundColor = UIColor(named: "AnaRenk")
        mySearchBar.searchTextField.backgroundColor = UIColor(named: "Renk1")
        myCollection.backgroundColor = .clear

        
        let ekranGenisligi = UIScreen.main.bounds.width
        let itemGenisligi = (ekranGenisligi - 30) / 2

        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 10
        tasarim.itemSize = CGSize(width: itemGenisligi, height: itemGenisligi * 1.5)

        myCollection.collectionViewLayout = tasarim
        myCollection.delegate = self
        myCollection.dataSource = self
        mySearchBar.delegate = self

      
        _ = anasayfaViewModel.UrunlerListesi.subscribe(onNext: { liste in
            self.UrunlerListesi = liste
            DispatchQueue.main.async {
                self.myCollection.reloadData()
            }
        })
        
       
        if let textFieldInsideSearchBar = mySearchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.backgroundColor = UIColor(named: "Renk2") // #047579
            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(
                string: "Ürün ara...",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4]
            )
            textFieldInsideSearchBar.layer.cornerRadius = 10
            textFieldInsideSearchBar.layer.masksToBounds = true
        }
        view.backgroundColor = UIColor(named: "AnaRenk")
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        anasayfaViewModel.urunleriYukle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay",
           let urun = sender as? Urunler,
           let gidilecekVC = segue.destination as? Detay {
            gidilecekVC.urun = urun
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        anasayfaViewModel.ara(aramaKelimesi: searchText)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UrunlerListesi.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UrunlerHucre", for: indexPath) as! UrunlerHucre
        
        let urun = UrunlerListesi[indexPath.row]
        cell.urunAdi.text = urun.ad
        cell.urunFiyat.text = "\(urun.fiyat ?? 0) ₺"
        cell.kategori.text = "\(urun.kategori ?? "kategorisiz")"
        cell.marka.text = "\(urun.marka ?? "markasiz")"
        
        if let resimAdi = urun.resim,
           let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)") {
            cell.ImageView.kf.setImage(with: url)
        }
        
        cell.backgroundColor = UIColor(named: "Renk1")
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        
        cell.urunAdi.textColor =   UIColor(named:"Renk3")
        cell.urunFiyat.textColor = UIColor(named: "Renk3")
        cell.kategori.textColor =  UIColor(named: "Renk3")
        cell.marka.textColor =    UIColor(named: "Renk3")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urun = UrunlerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: urun)
    }
}
