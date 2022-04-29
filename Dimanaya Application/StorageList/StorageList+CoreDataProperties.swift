//
//  StorageList+CoreDataProperties.swift
//  Dimanaya Application
//
//  Created by Atikah Febrianti Nastiti on 28/04/22.
//
//

import Foundation
import CoreData


extension StorageList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StorageList> {
        return NSFetchRequest<StorageList>(entityName: "StorageList")
    }

    @NSManaged public var name: String?
    @NSManaged public var productName: String?

}

extension StorageList : Identifiable {

}
