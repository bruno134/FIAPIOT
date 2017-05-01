//
//  Acesso.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 29/01/17.
//  Copyright © 2017 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

class Acesso: NSObject {
    
    var data = "";
    var hora = "";
    
    
    func formatar(str:String) -> String{
        
        let start = str.index(str.startIndex, offsetBy: 7)
        let end = str.index(str.endIndex, offsetBy: -6)
        let range = start..<end
        
        str.substring(with: range)  // play
        
        return str;
    }
    
}
