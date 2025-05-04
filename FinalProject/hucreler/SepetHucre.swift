//
//  SepetHucre.swift
//  FinalProject
//
//  Created by İmat Gökaslan on 27.04.2025.
// tasındı
 
import UIKit
protocol SepetHucreDelegate: AnyObject {
    func urunuSil(sepetId: Int, kullaniciAdi: String)
}

class SepetHucre: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var LabelAd: UILabel!
    @IBOutlet weak var LabelFiyat: UILabel!
    @IBOutlet weak var LabelAdet: UILabel!
    @IBOutlet weak var LabelToplamFiyat: UILabel!

    weak var delegate: SepetHucreDelegate?
    var sepetId: Int?
    var kullaniciAdi = "imat"

    @IBAction func TrashButton(_ sender: Any) {
        if let id = sepetId {
            
            delegate?.urunuSil(sepetId: id, kullaniciAdi: kullaniciAdi)
 
        }
    }
}
