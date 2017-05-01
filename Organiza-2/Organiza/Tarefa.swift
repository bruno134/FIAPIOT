//
//  Tarefa.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation
import CoreData


class Tarefa: NSManagedObject {

    class func salvar(_ itemLista:ItemLista, daLista lista:Lista, context:NSManagedObjectContext){
        
        let tarefa = NSEntityDescription.insertNewObject(forEntityName: "Tarefa", into: context) as! Tarefa
        
        
        tarefa.texto = itemLista.texto
        tarefa.concluido = itemLista.checked
        tarefa.dataLembrete = itemLista.dataLembrete
        tarefa.lembrete = itemLista.lembrete
        
        let tarefas = lista.tarefas?.mutableCopy() as! NSMutableOrderedSet
        
        print("salvar")
        print(tarefa.dataLembrete)
        
        tarefas.add(tarefa)
        
        lista.tarefas = tarefas.copy() as? NSOrderedSet
        
        do{
            try context.save()
        }catch{
            print("Erro ao salvar tarefas: \(error)")
        }
    }
    
    class func excluir(_ tarefa:Tarefa, daLista lista:Lista, context:NSManagedObjectContext){
        
        do{
            let tarefaParaRemover = tarefa
            let tarefas = lista.tarefas?.mutableCopy() as! NSMutableOrderedSet
            let index = tarefas.index(of: tarefaParaRemover)
            
            tarefas.remove(index)
            
            lista.tarefas = (tarefas.copy() as! NSOrderedSet)
            
            context.delete(tarefaParaRemover)
            
            try context.save()
            
        }catch{
            fatalCoreDataError(error)
        }

    }
    
    class func atualizarTarefa(_ context:NSManagedObjectContext){
        
        do{
            try context.save()
        }catch{
            fatalCoreDataError(error)
        }
        
    }
    
}

    
