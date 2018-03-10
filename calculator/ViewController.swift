//
//  ViewController.swift
//  calculator
//
//  Created by Kenith Aiyappa on 07/03/18.
//  Copyright © 2018 K2A. All rights reserved.
//

import UIKit


class Key{
    var type:String
    var value:String
    init(type:String,value:String) {
        self.type = type
        self.value = value
    }
}

class ViewController: UIViewController {
    
    let keyList : [Key] = [Key(type:"number",value:"7"),Key(type:"number",value:"8"),Key(type:"number",value:"9"),Key(type:"operator",value:"*"),Key(type:"number",value:"4"),Key(type:"number",value:"5"),Key(type:"number",value:"6"),Key(type:"operator",value:"-"),Key(type:"number",value:"1"),Key(type:"number",value:"2"),Key(type:"number",value:"3"),Key(type:"operator",value:"+"),Key(type:"number",value:"0"),Key(type:"number",value:"."),Key(type:"operator",value:"="),Key(type:"operator",value:"/")]
    
    var LHS : String = ""
    var OPR : String = ""
    var RHS : String = ""
    
    lazy var Stitle: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Calculator"
        label.textColor = UIColor.red
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 19.0, left: 1.0, bottom: 19.0, right: 2.0)
        collectionView.backgroundColor = UIColor.white //default background color is black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var numberDisplay : UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var operatorDisplay : UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = ""
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var clearScreen : UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "CLEAR"
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.yellow
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clearScreenAction))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var displayView : UIView = {
        let view : UIView = UIView()
        view.addSubview(numberDisplay)
        view.addSubview(operatorDisplay)
        numberDisplay.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        numberDisplay.trailingAnchor.constraint(equalTo: operatorDisplay.leadingAnchor, constant: -10).isActive = true
        operatorDisplay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        numberDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        operatorDisplay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        numberDisplay.heightAnchor.constraint(equalToConstant: 50).isActive = true
        operatorDisplay.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(Stitle)
        view.addSubview(displayView)
        view.addSubview(clearScreen)
        displayView.backgroundColor = UIColor.green
        view.addSubview(collectionView)
        Stitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Stitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        Stitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        Stitle.bottomAnchor.constraint(equalTo: displayView.topAnchor, constant: -10).isActive = true
        displayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        displayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        displayView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        displayView.bottomAnchor.constraint(equalTo: clearScreen.topAnchor, constant: -20).isActive = true
        clearScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        clearScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        clearScreen.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearScreen.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clearScreenAction(){
        operatorDisplay.text = ""
        numberDisplay.text = ""
        RHS = ""
        LHS = ""
        OPR = ""
    }

}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.yellow
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        textLabel.text = keyList[indexPath.row].value
        cell.contentView.addSubview(textLabel)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80);
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (keyList[indexPath.row].type == "operator"){
            if(RHS != ""){
                self.performOperation()
                numberDisplay.text = LHS
            }
            if(LHS != ""){
                OPR = keyList[indexPath.row].value
                if(OPR == "="){
                    operatorDisplay.text = ""
                }else{
                    operatorDisplay.text = OPR
                }
            }
        }else{
            if(OPR == ""){
                LHS = LHS + keyList[indexPath.row].value
                numberDisplay.text = LHS
            }else{
                RHS = RHS + keyList[indexPath.row].value
                numberDisplay.text = RHS
            }
        }
    }
    
    func performOperation(){
        
        let _LHS = Float(LHS)!
        let _RHS = Float(RHS)!
        var result : Float = 0.0
        var isInt : Bool = true
        if (LHS.contains(".") || RHS.contains(".")){
            isInt = false
        }
        
        switch OPR {
        case "+":
            result = _LHS + _RHS
        case "-":
            result = _LHS - _RHS
        case "*":
            result = _LHS * _RHS
        case "/":
            result = _LHS / _RHS
        default:
            print("\(LHS) \(OPR) \(RHS)")
        }
        if(isInt == true){
            LHS = String(format: "%.0f", result)
        }else{
            LHS = String(result)
        }
        RHS = ""
        OPR = ""
    }
    
}



