//
//  ListaItensViewController.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 18/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

class ListaItensViewController: UITableViewController, AdicionaTarefaDelegate {
    
    var itens = [ItemLista]()

    var delegate:ListaTarefasViewController?
    var listaSelecionada:ListaTarefa!
	var idChecklist: String!
    var primeiraVez = true
    var fireBaseHandle:UInt?
	
	private var _ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

		if _ref == nil
		{
			self._ref = FIRDatabase.database().reference()
		}
		
        if let lista = listaSelecionada{
            navigationItem.title = lista.nomeLista
            idChecklist = lista.autoId
        }
        
         setupListenner()

    }

    override func viewWillDisappear(_ animated: Bool) {
        
        print("removendo observer itens")
        _ref?.removeAllObservers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
//        setupListenner()
    }
    
    //MARK: TableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListaCell", for: indexPath) as! ItemListaCell

        cell.textoTarefaLabel.text = itens[(indexPath as NSIndexPath).row].texto
        
        marcarCelula(cell, item: itens[(indexPath as NSIndexPath).row])
        
        return cell;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = itens[(indexPath as NSIndexPath).row]
            item.mudarMarcaItem()
            marcarCelula(cell, item: item)
            desativaNotificacao()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Deleta itens da tabela, com swipe para a esquerda
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {


        if editingStyle == UITableViewCellEditingStyle.delete {

        let tarefaParaRemover = itens[(indexPath as NSIndexPath).row]
            tarefaParaRemover.remove()
            desativaNotificacao()
            itens.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
 
    }



    //MARK: Segue Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adicionaItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AdicionaTarefaViewController


			controller.idChecklist = idChecklist
            controller.delegate = self
            
        } else if segue.identifier == "EditaItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AdicionaTarefaViewController

            controller.delegate = self

            if let indexPath = tableView.indexPath( for: sender as! UITableViewCell) {
                controller.itemParaEditar = itens[(indexPath as NSIndexPath).row]
            }
        }
    }
    
    //MARK: Custom Function
    func marcarCelula(_ cell: UITableViewCell, item: ItemLista) {
        
        let label = cell.viewWithTag(100) as! UILabel


        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
    }
    
    func setTextForCell(_ cell: UITableViewCell, doItem item: ItemLista) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.texto
    }

	private func quantidadeItensPendentes() -> Int
	{

		var i = 0

		for t in itens
		{
			if t.checked == false
			{
				i += 1;
			}
		}

	return i

}


func atualizarChecklistStatus()
{

	var status: String

	if itens.count == 0
	{
		status =  "Vazio"
	}
	else if itens.count == quantidadeItensPendentes()
	{
		status = "não iniciado"
	}
	else if quantidadeItensPendentes() == 0
	{
		status = "Concluído"
	}
	else
	{
		status = "\((itens.count - quantidadeItensPendentes())) de \(itens.count) concluídos"
	}
	let checklistPath = "checklists/\(self.idChecklist!)"
	_ref!.child(checklistPath).updateChildValues(["status": status])
}





    func setupListenner(){
        
        if fireBaseHandle == nil{
            print("Criando observer")
            
            fireBaseHandle = _ref!.child("tarefas/\(idChecklist!)").observe(FIRDataEventType.value, with: {
            
            (snapshot) in
                
                let quantidadeListaAtual = self.itens
                
                print("QtdAtual \(quantidadeListaAtual.count)")
                
                self.itens.removeAll()
                
                var item: ItemLista
                for child in snapshot.children {
                    
                    if let childSnap = child as? FIRDataSnapshot
                    {
                        item = ItemLista(self.idChecklist!)
                        
                        item.loadFromSnap(childSnap)
                        self.itens.append(item)
                    }
                    
                }
                
                self.atualizarChecklistStatus()
                
                print("meu flag itens \(self.primeiraVez)")
                if !self.primeiraVez //&& (quantidadeListaAtual != self.itens.count)
                {
                    disparaNotificacao("Itens da sua lista foram atualizados")
                }else{
                    self.delegate?.desabilitaNotificacao()
                    self.primeiraVez = false
                    
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                
                }
            })
        }else{
            print("observer ja esta criado")
        }
    }
    
    
    func desativaNotificacao() {
        
        primeiraVez = true
        
        print("setei flag: \(primeiraVez)")
    }
}
