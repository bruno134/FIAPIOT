//
//  Utils.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 28/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

var dataFormatada: DateFormatter = {
    let formato = DateFormatter()
    formato.dateStyle = DateFormatter.Style.medium
    formato.timeStyle = DateFormatter.Style.short
    
    return formato
}()

var indiceListaTarefa: Int {
    get {
        return UserDefaults.standard.integer(forKey: "indiceListaTarefa")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "indiceListaTarefa")
        UserDefaults.standard.synchronize()
    }
}

func ajustePrimeiroAcesso() {
    let indice = indiceListaTarefa
    
    if indice == 0 {
       indiceListaTarefa = 1
    }
}

func disparaNotificacao(_ texto:String){
    
    
    let textoNotificacao = texto == "" ? "Lista de tarefa foi atualizada": texto
    
    
    let content = UNMutableNotificationContent()
    content.title = NSString.localizedUserNotificationString(forKey: "Organiza:", arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: textoNotificacao, arguments: nil)
    content.sound = UNNotificationSound.default()
    content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber?;
    content.categoryIdentifier = "organizaLista"
    // Deliver the notification in five seconds.
    
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
    let request = UNNotificationRequest.init(identifier: "now", content: content, trigger: trigger)
    
    // Schedule the notification.
    let center = UNUserNotificationCenter.current()
    center.add(request)
}
