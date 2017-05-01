//
//  ItemLista.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 18/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class ItemLista:NSObject {

    var texto:String = ""
    var checked = false
    var codigoItem:Int8 = 0
    var dataLembrete = Date()
	var idChecklist: String?
	var autoId: String?
    var lembrete = false
	private var _ref : FIRDatabaseReference?
	
	init(_ idChecklist: String)
	{
		self.idChecklist = idChecklist
	}
	
	func loadFromSnap(_ snap: FIRDataSnapshot)
	{
	let tarefa = snap.value as! NSDictionary
		autoId = snap.key
				texto = tarefa["texto"] as! String
		checked = (tarefa["estado"] as! String) == "S" ? true : false
		lembrete = (tarefa["lembrete"] as! String) == "S" ? true : false
        
        if lembrete {
            getDate (tarefa["data"] as! String)
		}
        print ("lembrete : \(tarefa["lembrete"] as! String)")
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

		let tarefaPath = "/tarefas/\(self.idChecklist!)/\(autoId!)"
		_ref!.child(tarefaPath).removeValue()
	}

    func mudarMarcaItem() {
print ("mudando marca de item \(texto) id \(autoId)")
        checked = !checked
		if _ref == nil
		{
			self._ref = FIRDatabase.database().reference()
		}
		let checkedPath = "tarefas/\(self.idChecklist!)/\(autoId!)"
print ("vou atualizar path \(checkedPath)")
		_ref!.child(checkedPath).updateChildValues(["estado": checked ? "S" : "N" ] )
		
    }
    
    func agendarNotificacao() -> Void {

        var existeNotificacao: UILocalNotification?
        existeNotificacao = verificaExisteNotificacao()

        if (existeNotificacao != nil){
            UIApplication.shared.cancelLocalNotification(existeNotificacao!)
        }
        
        if (lembrete == true && dataLembrete.compare(Date()) != ComparisonResult.orderedAscending) {
            
        

            let notificacao = UILocalNotification()
            notificacao.fireDate = self.dataLembrete
            notificacao.timeZone = TimeZone.current
            notificacao.alertBody = self.texto
            notificacao.soundName = UILocalNotificationDefaultSoundName
            notificacao.userInfo = ["codigoItem": String(self.codigoItem)]
        }
    }
    
    func verificaExisteNotificacao() -> UILocalNotification? {
        
        //resgata todas as notificações agendadas
        let todasNotificacoes:NSArray = UIApplication.shared.scheduledLocalNotifications! as NSArray
        
        for notificacao in todasNotificacoes as! [UILocalNotification] {
            
            //resgata a referencia da notificação
let codigo  = notificacao.userInfo?["codigoItem"] as? Int8

if (codigo != nil && codigo == self.codigoItem){
                return notificacao
            }
        }

        return nil;
    }
	
	func persiste()
	{
		if _ref == nil
		{
			self._ref = FIRDatabase.database().reference()
		}

		if autoId == nil
		{
			autoId = _ref!.child("tarefas/\(self.idChecklist)").childByAutoId().key
			print ("vou criar nova id tarefas/\(self.idChecklist)/\(autoId)")
		}
		else
		{
			print ("vou atualizar id tarefas/\(self.idChecklist)/\(autoId)")
		
		}
		
let tarefa = [
	"texto": texto,
	"estado": (checked ? "S" : "N"),
	"lembrete": (lembrete ? "S" : "N"),
	"data": (lembrete ? setDate() : "")
		]
		let tarefaPath = "tarefas/\(self.idChecklist!)/\(autoId!)"
		_ref!.child(tarefaPath).setValue(tarefa)
	}
	

private func setDate() -> String
{
let formatador = DateFormatter()
formatador.dateFormat = "YYYYMMddkkmm"
return formatador.string(from: dataLembrete)

	}

	private func getDate(_ date: String)
{
	let formatador = DateFormatter()
	formatador.dateFormat = "YYYYMMddkkmm"
	self.dataLembrete = formatador.date(from: date)!
	}

    func fomatarDataParaTexto() -> String {
        
        if (self.lembrete == true) {

            let formatoData = DateFormatter()
            formatoData.dateStyle = DateFormatter.Style.medium
            formatoData.timeStyle = DateFormatter.Style.short

            return formatoData.string(from: self.dataLembrete)
        }
        
        return "Não existe notificação agendada"
    }
}
