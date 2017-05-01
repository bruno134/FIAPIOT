//
//  SeletorIconeTableViewController.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

protocol SeletorIconeDelegate: class {
    
    func selecionaIcone(_ icone: String)
}

class SeletorIconeTableViewController: UITableViewController {

    var delegate: SeletorIconeDelegate?
    
    let icones = [
        ("No Icon","Sem Ícone"),
        ("Appointments","Compromisso"),
        ("Birthdays","Aniversario"),
        ("Chores","Atividades"),
        ("Drinks","Bebidas"),
        ("Folder","Pasta"),
        ("Groceries","Supermercado"),
        ("Inbox","Entrada"),
        ("Photos","Fotos"),
        ("Trips","Viagem") ]
    
   
    
    override func viewDidLoad() {
        navigationController?.title = "Selecione Ícone"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Icone", for: indexPath)
        
        let iconName = icones[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = iconName.1
        cell.imageView!.image = UIImage(named: iconName.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            let nomeIcone = icones[(indexPath as NSIndexPath).row]
            delegate.selecionaIcone(nomeIcone.0)
        }
    }

    
}
