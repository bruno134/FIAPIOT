//
//  Lista+CoreDataProperties.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Lista {

    @NSManaged var nome: String
    @NSManaged var caminhoImagem: String?
    @NSManaged var id: Int
    @NSManaged var tarefas: NSOrderedSet?

}
