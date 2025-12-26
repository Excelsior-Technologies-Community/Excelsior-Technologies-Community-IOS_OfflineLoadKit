//
//  Person+CoreDataProperties.swift
//  IOS_OfflineLoadKit
//
//  Created by Noman belim on 26/12/25.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}

extension Person : Identifiable {

}
