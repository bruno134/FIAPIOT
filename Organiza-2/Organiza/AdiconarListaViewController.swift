//
//  AdiconarListaViewController.swift
//  Organiza
//
//  Created by Usuário Convidado on 27/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

protocol AdicionaPastaDelegate: class {
    func adicionadoTarefa(controller: AdiconarListaViewController, doItemAdicionado item: ItemPastaLista)
    func adicionadoTarefa(controller: AdiconarListaViewController, doItemEditado item: ItemPastaLista)
}

class AdiconarListaViewController: UITableViewController {

    @IBOutlet weak var imageViewicon: UIImageView!
    @IBOutlet weak var saveListButton: UIBarButtonItem!
    @IBOutlet weak var listName: UITextField!
    
    weak var delegate:AdicionaPastaDelegate?
    var itemParaEditar: ItemPastaLista?
    
 
    @IBAction func salvarTarefa(sender: AnyObject) {
        if let delegate = delegate {
            
            if let item = itemParaEditar {
                item.texto = listName.text!
                delegate.adicionadoTarefa(self, doItemEditado: item)
            }else{
                let item = ItemPastaLista()
                item.texto = listName.text!
                delegate.adicionadoTarefa(self, doItemAdicionado: item)
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemParaEditar {
            title = "Editar Item"
            listName.text = item.texto
            saveListButton.enabled = true
        }
    }
    
    @IBAction func cancelarTarefa() {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
}

extension AdiconarListaViewController:UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let textoAnterior: NSString = textField.text!
        let textoAtual: NSString = textoAnterior.stringByReplacingCharactersInRange(range, withString: string)
        
        saveListButton.enabled = (textoAtual.length > 0)
        return true
        
    }
}