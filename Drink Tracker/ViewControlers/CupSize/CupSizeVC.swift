//
//  CupSizeVC.swift
//  Drink Tracker
//
//  Created by Sern Duck on 31/03/2023.
//

import UIKit

class CupSizeVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectIndex: Int = -1
    
    var cupSize: [Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Đổi cốc"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        genData()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self)
    }
    
    func genData() {
        cupSize = [
            100,
            200,
            300,
            400,
            500
        ] + AppConfig.shared.customCupSize
        
        cupSize = cupSize.sorted(by: <)
        
        selectIndex = cupSize.firstIndex(where: { $0 == Setting.shared.cupSize }) ?? -1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func onConfirm(_ sender: Any) {
        defer {
            navigationController?.popViewController(animated: true)
        }
        guard selectIndex >= 0 else { return }
        Setting.shared.cupSize = Double(cupSize[selectIndex])
        
        Setting.shared.saveToUserDefault()
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func imageForCup(size: Double) -> UIImage? {
        switch size {
        case 100..<200:
            return UIImage(named: "cup")
        case 200..<300:
            return UIImage(named: "bottle_small")
        case 300..<400:
            return UIImage(named: "bottle_medium")
        case 400...500:
            return UIImage(named: "bottle_big")
        default:
            return UIImage(named: "bottle")
        }
    }
}


extension CupSizeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cupSize.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DateCell.self, indexPath)
        if indexPath.row < cupSize.count {
            cell.customLabel.text = "\(Int(cupSize[indexPath.row])) ml"
            cell.imgView.image = imageForCup(size: cupSize[indexPath.row])
            cell.bindSelected(selectIndex == indexPath.row)
        } else {
            cell.customLabel.text = "Thêm cốc"
            cell.imgView.image = UIImage(named: "plus")
            cell.bindSelected(false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < cupSize.count {
            selectIndex = indexPath.row
            collectionView.reloadData()
        } else {
            let addCupVC = AddCupVC()
            addCupVC.onConfirm = { [weak self] newSize in
                AppConfig.shared.customCupSize.append(newSize)
                AppConfig.shared.saveToUserDefault()
                self?.genData()
                self?.collectionView.reloadData()
            }
            let vc = BottomSheetVC.newVC(contentVC: addCupVC, contentHeight: 130)
            vc.modalPresentationStyle = .overFullScreen
            MainTabBarVC.shared.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
