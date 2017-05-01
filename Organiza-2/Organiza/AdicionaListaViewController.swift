//
//  AdicionaListaViewController.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit
import CoreData

protocol AdicionaListaViewControllerDelegate: class {
    func atualizaTabelaLista()
    func desabilitaNotificacao()
}

class AdicionaListaViewController: UITableViewController {

    @IBOutlet weak var nomeTarefaTextField: UITextField!
    @IBOutlet weak var adicionaBarButton: UIBarButtonItem!
    @IBOutlet weak var iconeImageView: UIImageView!
    
    var delegate:AdicionaListaViewControllerDelegate?
    var listaParaEditar:ListaTarefa?
    var managedObjectContext: NSManagedObjectContext!
    var nomeIcone = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let listaTarefa = listaParaEditar {
            title = "Editar Lista Tarefa"
            nomeTarefaTextField.text = listaTarefa.nomeLista
            adicionaBarButton.isEnabled = true
            adicionaBarButton.title = "Salvar"
            nomeIcone = listaTarefa.nomeImagem

        }

        iconeImageView.image = UIImage(named: nomeIcone)
		iconeImageView.isAccessibilityElement = true
		iconeImageView.accessibilityLabel = nomeIcone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nomeTarefaTextField.becomeFirstResponder()
    }
    
    @IBAction func adicionar(_ sender: UIBarButtonItem) {
		
		var listaTarefa: ListaTarefa

if  listaParaEditar == nil
{
listaTarefa = ListaTarefa()
		}
		else
{
listaTarefa = listaParaEditar!

		}

listaTarefa.nomeLista = nomeTarefaTextField.text!
            listaTarefa.nomeImagem = nomeIcone
			listaTarefa.persist()
            delegate?.desabilitaNotificacao()
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath as NSIndexPath).section == 1 {
            return indexPath
        }else{
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "SeletorIcone" {
            let controller = segue.destination as! SeletorIconeTableViewController
            controller.delegate = self
        }
        
    }
    
}

extension AdicionaListaViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let velhoTexto: NSString = textField.text! as NSString
        let novoTexto: NSString = velhoTexto.replacingCharacters(in: range, with: string) as NSString
        adicionaBarButton.isEnabled = (novoTexto.length > 0)
        return true
    }

}

extension AdicionaListaViewController:SeletorIconeDelegate{
    
    func selecionaIcone(_ icone: String){
        nomeIcone = icone
        iconeImageView.image = UIImage(named: nomeIcone)
        navigationController?.popViewController(animated: true)
    }
}
