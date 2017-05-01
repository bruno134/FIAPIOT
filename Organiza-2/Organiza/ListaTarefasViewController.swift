//
//  ListaTarefasViewController.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase


class ListaTarefasViewController: UITableViewController, UINavigationControllerDelegate{


    var listasTarefa = [ListaTarefa]()
	var checkLists = [ListaTarefa]()
    var listaAcesso = [Acesso]()
    var primeiraVez = true
    var fireBaseHandle:UInt?
	
	private   var _ref: FIRDatabaseReference? = nil

    override func viewDidLoad() {
        
        tableView.rowHeight = 88.0;
		
        super.viewDidLoad()

		if _ref == nil
		{
			_ref = FIRDatabase.database().reference()
		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupListenner()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print ("vou desenhar \(listasTarefa.count)")
        return listaAcesso.count;
    }
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cellIdentifier = "Cell"

        //let lista = listasTarefa[(indexPath as NSIndexPath).row]
        let lista = listaAcesso[indexPath.row];


        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AcessoCell

        cell.hourLabelView.text = lista.hora;
        cell.dateLabelView.text = lista.data
       
        
        cell.accessoryView?.isAccessibilityElement = true
        cell.accessoryView?.accessibilityLabel = "Data e Hora Acesso"
        return cell

    }

    
    
   	func setupListenner()
	{

   
        
        if fireBaseHandle == nil {
            
           
            print("Criando observer lista")
            
            fireBaseHandle = _ref!.observe(FIRDataEventType.value, with: { (snapshot) in
           // fireBaseHandle = _ref!.child("/").observe(FIRDataEventType.value, with: { (snapshot) in
                
                
                
                
                let acessoFB = snapshot.value as? [String:AnyObject] ?? [:];
                
                
                
                self.listaAcesso.removeAll();
                for item in acessoFB{
                   
                    if let acessoRef = (item.value as? NSDictionary)
                    {
                    
                    let acesso = Acesso();
                        acesso.data = acessoRef["data"] as! String;
                        acesso.hora = acessoRef["hora"] as! String;
                        self.listaAcesso.insert(acesso, at: self.listaAcesso.count);
                    }
                }
                
                
                if !self.primeiraVez //&& (quantidadeListaAtual.count != self.listasTarefa.count)
                {
                    disparaNotificacao("a porta da sua casa foi aberta!")
                    
                }else{
             
                    self.primeiraVez = false
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            })
        }

        
        
    }
    
}

extension ListaTarefasViewController: AdicionaListaViewControllerDelegate{
    
    func atualizaTabelaLista(){
        tableView.reloadData()
    }
    
    func desabilitaNotificacao() {
        primeiraVez = true
    }
    
}
