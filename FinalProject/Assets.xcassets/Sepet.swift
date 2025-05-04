//
//  Sepet.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import UIKit
import RxSwift
import Kingfisher

class Sepet: UIViewController {
    var sepetViewModel = SepetViewModel()
    var sepetListesi = [UrunlerSepeti]()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var urunlerTableView: UITableView!
    
    @IBOutlet weak var ToplamFiyatLabel: UILabel!
    @IBOutlet weak var kargoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
            
        let geriButonu = UIBarButtonItem(
             image: UIImage(systemName: "chevron.backward"),
             style: .plain,
             target: self,
             action: #selector(kapatTiklandi)
         )
         geriButonu.tintColor = .white
         self.navigationItem.leftBarButtonItem = geriButonu
        
        urunlerTableView.delegate = self
        urunlerTableView.dataSource = self

        let lottieAnim = createLottieAnimationView(
                from: "https://lottie.host/b012dc97-6109-4a96-b1fa-0a2c683d0987/seY4xgJ8PK.json",
                width: 100,
                height: 100
            )
            
        let containerView = UIView(frame: urunlerTableView.bounds)
        containerView.addSubview(lottieAnim)
        lottieAnim.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieAnim.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            lottieAnim.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            lottieAnim.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            lottieAnim.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        urunlerTableView.backgroundView = containerView
        
        sepetViewModel.sepetListesi
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] liste in
                guard let self = self else { return }
                
                self.sepetListesi = liste
                
                if liste.isEmpty {
                    print("Sepet boş, Lottie animasyonu gösteriliyor")
                    self.urunlerTableView.backgroundView?.isHidden = false
                    self.ToplamFiyatLabel.text = "₺0"
                    self.kargoLabel.text = "0 ₺"
                } else {
                    self.urunlerTableView.backgroundView?.isHidden = true
                    self.toplamFiyatVeKargoHesapla()
                }
                
                self.urunlerTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sepetViewModel.sepetiGetir()
    }
    
    @objc func kapatTiklandi() {
        self.navigationController?.popViewController(animated: true)
    }

    private func sepetiBosGoster() {
        self.urunlerTableView.backgroundView?.isHidden = false
        self.ToplamFiyatLabel.text = "₺0"
        self.kargoLabel.text = "0 ₺"
    }
    
    func toplamFiyatVeKargoHesapla() {
        let toplamFiyat = sepetListesi.reduce(0) { toplam, urun in
            toplam + ((urun.fiyat ?? 0) * (urun.siparisAdeti ?? 0))
        }

        let kargoBedeli: Int = toplamFiyat > 10_000 ? 0 : 100

        ToplamFiyatLabel.text = "₺\(toplamFiyat)"
        if kargoBedeli == 0 {
            let eskiFiyat = NSAttributedString(
                string: "100 ₺ ",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.red
                ]
            )
            let yeniFiyat = NSAttributedString(
                string: "0 ₺",
                attributes: [
                    .foregroundColor: UIColor.systemGreen,
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ]
            )
            let toplamYazi = NSMutableAttributedString()
            toplamYazi.append(eskiFiyat)
            toplamYazi.append(yeniFiyat)

            kargoLabel.attributedText = toplamYazi
        } else {
            kargoLabel.text = "\(kargoBedeli) ₺"
            kargoLabel.textColor = .label
        }
    }
}

extension Sepet: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hucre = tableView.dequeueReusableCell(withIdentifier: "toSepet", for: indexPath) as? SepetHucre else {
            return UITableViewCell()
        }

        let urun = sepetListesi[indexPath.row]

        hucre.LabelAd.text = urun.ad ?? ""
        hucre.LabelFiyat.text = "\(urun.fiyat ?? 0) ₺"
        hucre.LabelAdet.text = "\(urun.siparisAdeti ?? 0) Adet"
        hucre.LabelToplamFiyat.text = "\(urun.fiyat! * urun.siparisAdeti!) ₺"
        hucre.ImageView.kf.setImage(with: URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(urun.resim ?? "")"))

        hucre.sepetId = urun.sepetId
        hucre.kullaniciAdi = urun.kullaniciAdi!
        hucre.delegate = self

        return hucre
    }
}

extension Sepet: SepetHucreDelegate {
    func urunuSil(sepetId: Int, kullaniciAdi: String) {
        let itemIsBeingDeleted = sepetListesi.first(where: { $0.sepetId == sepetId })
        
        sepetViewModel.urunuSil(sepetId: sepetId, kullaniciAdi: kullaniciAdi)
        
        if let index = sepetListesi.firstIndex(where: { $0.sepetId == sepetId }) {
            sepetListesi.remove(at: index)
            urunlerTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            
            if sepetListesi.isEmpty {
                self.urunlerTableView.backgroundView?.isHidden = false
                ToplamFiyatLabel.text = "₺0"
                kargoLabel.text = "0 ₺"
            } else {
                toplamFiyatVeKargoHesapla()
            }
        }
    }
}
