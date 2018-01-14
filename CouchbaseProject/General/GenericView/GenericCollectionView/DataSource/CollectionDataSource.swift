//
//  GenericDictionaryTypeData.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 12/4/17.
//  Copyright © 2017 Fractal Analytics Inc. All rights reserved.
//

import Foundation
import UIKit

/// Encapsulating the Boilerplate: CollectionDataSource
///With the above abstractions in place, it is possible to start implementing a base class that will
///encapsulate the common boilerplate required to create a data source for a collection view.
open class CollectionDataSource<Provider:DataProvider,Cell:UICollectionViewCell>:
    NSObject,UICollectionViewDataSource,
UICollectionViewDelegate where Cell:ConfigurableCell,Provider.T == Cell.T {
    // MARK: - Private Properties
    //CollectionDataSource needs to know which collection view instance it will be acting upon and through which specific Provider.
    let provider: Provider
    let collectionView: UICollectionView
    
    // MARK: - Lifecycle
    init(collectionView: UICollectionView, provider: Provider) {
        self.collectionView = collectionView
        self.provider = provider
        super.init()
        setUp()
    }
    
    func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifierForCell,
                                                            for: indexPath) as? Cell else {
                                                                return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }

    // MARK: - Delegates
    public var collectionItemSelectionHandler: ItemSelectionHandlerType?
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionItemSelectionHandler?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        return UICollectionReusableView(frame: CGRect.zero)
    }
}

