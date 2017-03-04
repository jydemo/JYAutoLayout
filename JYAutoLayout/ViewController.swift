//
//  ViewController.swift
//  JYAutoLayout
//
//  Created by atom on 2017/3/4.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(view01)
        self.view.addSubview(view02)
        view01.frame = CGRect(x: 100, y: 200, width: 20, height: 20)
        view02.frame = CGRect(x: 100, y: 10, width: 10, height: 10)
        //let _ = view01.jy_fill(self.view01, insets: UIEdgeInsets(top: 64, left: 20, bottom: 20, right: 20))
        
        //let _ = view01.jy_AlignInner(JY_AlignType.center, referView: view02, size: CGSize(width: 20, height: 20))
        let _ = view01.jy_AlignInner(.bottomLeft, referView: view02, size: CGSize(width: 20, height: 20))
    }
    
    private lazy var view01: UIView = {
        let view01 = UIView()
        view01.backgroundColor = UIColor.red
        return view01
    }()
    private lazy var view02: UIView = {
        let view02 = UIView()
        view02.backgroundColor = UIColor.blue
        return view02
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

