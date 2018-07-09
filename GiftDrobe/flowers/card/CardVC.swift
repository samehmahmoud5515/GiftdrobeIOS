//
//  CardVC.swift
//  GiftDrobe
//
//  Created by Logic Designs on 5/6/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

class CardVC: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet var viewModel : CardViewModel!
    var listener : CardSelected?
    @IBOutlet weak var errorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initList()
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.displayContent(card: viewModel.getCard(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColoums : CGFloat = 2
        let width = collectionView.frame.size.width
        let xInsets : CGFloat = 5
        let cellSpacing : CGFloat = 5
        return CGSize(width: (width / numberOfColoums) - (xInsets + cellSpacing), height: (width / numberOfColoums) - (xInsets + cellSpacing))
    }
    
    func initList()
    {
        self.startActivityIndicator()
        viewModel.requestCardList(limit:5, page:5, compeletion: {
            success in
            if success == true {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = nil
                    self.collectionView.reloadData()
                }
            } else {
                  DispatchQueue.main.async {
                    self.collectionView.backgroundView = self.errorView
                }
            }
            self.stopActivityIndicator()
        } )
    }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let alert = UIAlertController(title: "Greating Message Card", message: "Enter greating message", preferredStyle: .alert)
         alert.addTextField { (textField) in
         textField.placeholder = "Enter your message"
         }
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
         let textField = alert?.textFields![0]
         let message = textField?.text ?? ""
         self.dismiss(animated: true, completion: nil)
         self.callListner(message: message,card:self.viewModel.getCard(indexPath: indexPath))

         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [ ] (_) in }))
         self.present(alert, animated: true, completion: nil)
     }
    
    func callListner(message: String ,card: CardModel) {
        self.performSegueToReturnBack()
        self.listener?.onCardSelected(message: message,card:card)
    }
    
}

protocol CardSelected {
    
    func onCardSelected(message: String , card: CardModel)
}

