//
//  EditaListaIconeTableViewController.swift
//  Organiza
//
//  Created by Usuário Convidado on 27/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

class EditaListaIconeTableViewController: UITableViewController {
    
    struct icone {
        var nome: String
        var img: String
    }
    
    let iconesLista = [
        icone(nome: "Appointments", img: ""),
        icone(nome: "Appointments", img: ""),
        icone(nome: "Appointments", img: ""),
        icone(nome: "Appointments", img: ""),
        icone(nome: "Appointments", img: ""),
        icone(nome: "Appointments", img: "")
        
    ]


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemPastaListaCell", forIndexPath: indexPath) as! ItemListaCell
        
        cell.textoTarefaLabel.text = iconesLista[indexPath.row].nome
        
        return cell;
    }

}
