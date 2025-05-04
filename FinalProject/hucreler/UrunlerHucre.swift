//
//  UrunlerHucre.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 25.04.2025.
//

import UIKit
import Kingfisher

class UrunlerHucre: UICollectionViewCell {
    
    @IBOutlet weak var marka: UILabel!
    @IBOutlet weak var kategori: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var urunAdi: UILabel!
    @IBOutlet weak var urunFiyat: UILabel!
    
    // Bu metodu hücre oluşturulduğunda çalıştırmak için override yapıyoruz
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellBorder()
    }
    
    private func setupCellBorder() {
        self.layer.borderColor = UIColor.gray.cgColor  // Border rengi
        self.layer.borderWidth = 1.0                     // Border kalınlığı
        self.layer.cornerRadius = 8.0                    // Köşe yuvarlama
        self.layer.masksToBounds = true                   // Taşmayı engelleme
    }
    
    @IBAction func sepeteEkle(_ sender: Any) {
    }
}
