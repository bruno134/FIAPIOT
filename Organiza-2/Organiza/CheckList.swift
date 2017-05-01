//
//  CheckList.swift
//  Organiza
//
//  Created by Marlon Sousa on 8/27/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation

// modelo de checkList

class CheckList
{

    var nome: String

    var imagem: String

    let id: int

var tarefas = [ItemLista]()

    func init(id: Int)
    {
        self.id = id
    }

    func append(i: ListaItem)
    {
tarefas.append(i)
    }

}