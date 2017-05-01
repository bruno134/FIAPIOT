//
//  Lista.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 27/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation
import CoreData


class Lista: NSManagedObject {
    

    class func retornaLista(_ contexto:NSManagedObjectContext, doCodigo codigo:Int) -> Lista?{
        
		let listaFetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Lista")
        listaFetch.predicate = NSPredicate(format: "id == %li", codigo)
        
        do{
            
            let resultado = try contexto.fetch(listaFetch) as? [Lista]
            
            if let listaResultado = resultado{
                
                if listaResultado.count > 0 {
                    return listaResultado[0]
                }else{
                    print("Pesquisa retornou mais de um resultado")
                }
            }
            
        }catch{
            fatalCoreDataError(error)
        }
        
        return nil
    }
    
    class func retornaListas(_ contexto:NSManagedObjectContext) -> [Lista]{
        
        var listaResultado = [Lista]()
		let listaFetch : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Lista")
        
        do{
            
            let resultado = try contexto.fetch(listaFetch) as? [Lista]
            
            if let resultado = resultado{
                listaResultado = resultado
            }
            
        }catch{
            fatalCoreDataError(error)
        }
        
        return listaResultado
    }

    class func salvarLista(_ context: NSManagedObjectContext, lista:ListaTarefa){
        
        let novaLista = NSEntityDescription.insertNewObject(forEntityName: "Lista", into: context) as! Lista
        
        
        
        novaLista.id = indiceListaTarefa + 1
        novaLista.nome = lista.nomeLista
        novaLista.tarefas = nil
        novaLista.caminhoImagem = lista.nomeImagem
        
        do {
            try context.save()
            indiceListaTarefa = novaLista.id
        } catch {
            fatalCoreDataError(error)
        }

    }
    
    class func excluirLista(_ lista:Lista, context:NSManagedObjectContext){
        
        
        
        do{            
            context.delete(lista)
            
            try context.save()
            
        }catch{
            fatalCoreDataError(error)
        }
        
    }
    
    class func atualizarLista(_ context:NSManagedObjectContext){
        
        do{
            try context.save()
        }catch{
            fatalCoreDataError(error)
        }
        
    }
    
}
