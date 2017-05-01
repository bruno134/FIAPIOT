//
//  AdicionaTarefaViewController.swift
//  Organiza
//
//  Created by BRUNO DANIEL NOGUEIRA on 20/08/16.
//  Copyright © 2016 BRUNO DANIEL NOGUEIRA. All rights reserved.
//

import UIKit

protocol AdicionaTarefaDelegate {
    func desativaNotificacao()
}


class AdicionaTarefaViewController: UITableViewController {

    @IBOutlet weak var nomeTarefaTextField: UITextField!
    @IBOutlet weak var salvarBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var botaoAtivaAviso: UISwitch!
    @IBOutlet weak var lblDataAviso: UILabel!
    

    var itemParaEditar: ItemLista?

    var listaSelecionada: Lista?
	
	var idChecklist: String?
    
    var _calendarioVisivel: Bool!
    var _dataSelecionada : Date!
    var delegate:AdicionaTarefaDelegate?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let item = itemParaEditar {
            title = "Editar Item"
            nomeTarefaTextField.text = item.texto
            salvarBarButtonItem.isEnabled = true
            _calendarioVisivel = false
            _dataSelecionada = item.dataLembrete as Date!
            botaoAtivaAviso.isOn = item.lembrete
            salvarBarButtonItem.title = "Salvar"
            lblDataAviso.text = dataFormatada.string(from: _dataSelecionada)
            
        } else {
            _calendarioVisivel = false
            _dataSelecionada = Date()
            botaoAtivaAviso.isOn = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        nomeTarefaTextField.becomeFirstResponder()
    }

    @IBAction func salvarTarefa() {
		var item: ItemLista?

            if itemParaEditar == nil
			{
                item = ItemLista(idChecklist!)

            }
                else
			{
                    item = itemParaEditar
		    }

                item!.texto = nomeTarefaTextField.text!

                item!.dataLembrete = _dataSelecionada
                item!.lembrete = botaoAtivaAviso.isOn


                item!.agendarNotificacao()
                item!.persiste()

                view.endEditing(true)
                delegate?.desativaNotificacao()
		        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelarTarefa() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func ativaDesativaAviso(_ botaoAviso: UISwitch) {

        if (botaoAviso.isOn) {
            exibirCalendario()
            return
        }
        escondeCalendario()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1){
            return indexPath;
        }else{
            return nil;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2){
            
            let celulaCalendario: UITableViewCell =
                UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "celulaCalendario")
            
            celulaCalendario.selectionStyle = UITableViewCellSelectionStyle.none
            
            let calendario: UIDatePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 216.0) )
            calendario.tag = 100
            
            celulaCalendario.contentView.addSubview(calendario)
            
            calendario.addTarget(self, action: #selector(AdicionaTarefaViewController.dataAlterada), for: UIControlEvents.valueChanged)
            
            return celulaCalendario
            
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if ((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1) {
            
            if (_calendarioVisivel == false) {
                exibirCalendario()
                return
            }
            escondeCalendario()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 1 && _calendarioVisivel == true){
            return 3;
        }else{
            
            //caso contrario, somente mantem o numero atual de linhas na secao
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2){
            return 217.0;
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
       
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        if((indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2){
            
            
            //enganando o tableView, forçando o retorno para linha 0. Poderia ser a 1 também.
            let novoIndice: IndexPath = IndexPath(row: 1, section: (indexPath as NSIndexPath).section)
            
            return super.tableView(tableView, indentationLevelForRowAt: novoIndice)
        }else{
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        escondeCalendario()
    }
    
    
    func dataAlterada(_ calendario: UIDatePicker) -> Void {
        
        _dataSelecionada = calendario.date
        self.atualizaCampoData()
        
    }
    
    func atualizaCampoData() -> Void {
        
        let formatacaoData: DateFormatter = DateFormatter()
        formatacaoData.dateStyle = DateFormatter.Style.medium
        formatacaoData.timeStyle = DateFormatter.Style.short
        self.lblDataAviso.text = formatacaoData.string(from: _dataSelecionada)
    }
    
    func exibirCalendario() -> Void {
        _calendarioVisivel = true
        
        let indiceLinha: IndexPath = IndexPath(row: 1, section: 1)
        let indiceCalendario: IndexPath = IndexPath(row: 2, section: 1)
        
        let celulaCalendario: UITableViewCell = self.tableView.cellForRow(at: indiceLinha)!
        celulaCalendario.detailTextLabel?.textColor = celulaCalendario.detailTextLabel?.tintColor
        
        self.tableView.beginUpdates()
        
        self.tableView.insertRows(at: [indiceCalendario], with: .fade)
        self.tableView.reloadRows(at: [indiceLinha], with: .none)
        
        self.tableView.endUpdates()
        
        let linhaCalendario: UITableViewCell = self.tableView.cellForRow(at: indiceCalendario)!
        let calendario: UIDatePicker = linhaCalendario.viewWithTag(100) as! UIDatePicker
        
        calendario.setDate(_dataSelecionada, animated: false)
        
    }
    
    func escondeCalendario() -> Void {
        
        if (_calendarioVisivel == true){
            
            _calendarioVisivel = false
            
            let indiceLinha: IndexPath = IndexPath(row: 1, section: 1)
            let indiceCalendario: IndexPath = IndexPath(row: 2, section: 1)
            
            let linha: UITableViewCell = self.tableView.cellForRow(at: indiceLinha)!
            linha.detailTextLabel?.textColor = UIColor(white: 0.0, alpha: 0.5)
            
            self.tableView.beginUpdates()
            
            self.tableView.reloadRows(at: [indiceLinha], with: .none)
            self.tableView.deleteRows(at: [indiceCalendario], with: .fade)
            
            self.tableView.endUpdates()
        }
    }
    
}


    extension AdicionaTarefaViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        let textoAnterior: NSString = textField.text! as NSString
        let textoAtual: NSString = textoAnterior.replacingCharacters(in: range, with: string) as NSString
        
        salvarBarButtonItem.isEnabled = (textoAtual.length > 0)
        return true

    }
        
}

