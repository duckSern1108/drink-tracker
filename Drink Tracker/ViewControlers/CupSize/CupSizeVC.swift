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
    
    let cupSize = [
        100,
        200,
        300,
        400,
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self)
    }
    @IBAction func onConfirm(_ sender: Any) {
        defer {
            dismiss(animated: true)
        }
        guard selectIndex >= 0 else { return }
        Setting.shared.cupSize = Double(cupSize[selectIndex])
        
        Setting.shared.saveToUserDefault()
    }
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true)
    }
}


extension CupSizeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cupSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DateCell.self, indexPath)
        cell.customLabel.text = "\(cupSize[indexPath.row]) ml"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
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
