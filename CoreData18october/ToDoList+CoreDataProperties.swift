//
//  ToDoList+CoreDataProperties.swift
//  CoreData18october
//
//  Created by Nazrin Sultanlı on 18.10.23.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?
    @NSManaged public var definition: String?

}

extension ToDoList : Identifiable {

}
