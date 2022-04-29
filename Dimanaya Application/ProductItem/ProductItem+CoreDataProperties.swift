//
//  ProductItem+CoreDataProperties.swift
//  Dimanaya Application
//
//  Created by Atikah Febrianti Nastiti on 28/04/22.
//
//

import Foundation
import CoreData


extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: "ProductItem")
    }

    @NSManaged public var name: String?

}

extension ProductItem : Identifiable {

}
