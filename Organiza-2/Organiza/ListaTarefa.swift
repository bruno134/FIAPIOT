//
//  ListaTarefa.swift
//  Organiza
//
//  Created by Marlon Sousa on 8/27/16.
//  Edited  by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class ListaTarefa:NSObject{
private var _ref: FIRDatabaseReference?
	
    var id:Int = 0
	var autoId : String?
    var nomeLista:String = ""
    var nomeImagem:String = ""
    var status: String = "Vazio"
    var tarefas:NSOrderedSet?
	
	init(_ snap: FIRDataSnapshot)
	{
        if let checklist = (snap.value as? NSDictionary)
        {
            
            
            
                autoId = snap.key
            
            if checklist["nomeLista"] != nil {
                nomeLista = checklist["nomeLista"] as! String
            }else{
                nomeLista = ""
            }
            
            if checklist["nomeImagem"] != nil {
                nomeImagem = checklist["nomeImagem"] as! String
            }else{
                nomeImagem = ""
            }
            
            if checklist["status"] != nil {
                status = checklist["status"] as! String
            }else{
                status = ""
            }
        }
	}
	
	override init()
	{

	
	}
	
	func persist()
	{
		if _ref == nil
		{
			    self._ref = FIRDatabase.database().reference()
		}
		
		if autoId == nil
		{
		    autoId = _ref!.child("checklists").childByAutoId().key
			print ("vou criar nova id \(autoId)")
		}
		else
		{
			print ("vou atualizar id \(autoId!)")
		}
		let checklist = [
		"nomeLista" : nomeLista,
		"nomeImagem": nomeImagem,
		"status": status
		]
        let checkListPath = "checklists/\(autoId!)"
        _ref!.child(checkListPath).setValue(checklist)
		
	}
	
	func remove()
	{
		
		// se autoId for nulo, objeto ainda não foi persistido
		if autoId == nil
		{
			return
		}

		if _ref == nil
		{
			self._ref = FIRDatabase.database().reference()
		}
		let checkListPath = "/checklists/\(autoId!)"
		_ref!.child(checkListPath).removeValue()
	}
}
