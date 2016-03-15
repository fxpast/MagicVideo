//
//  GridViewController.swift
//  MemeMe2.0
//
//  Created by MacbookPRV on 15/01/2016.
//  Copyright © 2016 Pastouret Roger. All rights reserved.
//
import Foundation
import UIKit

class GridViewController: UICollectionViewController {
    

    override func viewWillAppear(animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        let sentmemes = SentMemes.singleton
        if let _ = sentmemes.memeArray {
            collectionView?.reloadData()
        }
        
    }
    
    

    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        super.collectionView(collectionView, numberOfItemsInSection: section)
        
        let sentmemes = SentMemes.singleton
        if let _ = sentmemes.memeArray {
            return sentmemes.memeArray.count
        }
        else {
            return 0
        }
        
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath)
        let sentmemes = SentMemes.singleton
        let meme = sentmemes.memeArray[indexPath.row]
        let aView=UIImageView()
        aView.image=meme.memedImage
        item.backgroundView=aView

        return item
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let item = collectionView.cellForItemAtIndexPath(indexPath)
        let controller = UIViewController()
        controller.view=item?.backgroundView
        controller.view.contentMode = UIViewContentMode.ScaleAspectFit
        navigationController?.pushViewController(controller, animated: true)
        
        
        
        
    }
    
}