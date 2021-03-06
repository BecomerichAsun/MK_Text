//
//  ViewController.swift
//  MK_Text_iOS
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import UIKit
import YYText
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let ml = MK_Label()
        ml.isAsync = true
        //ml.frame = CGRect.init(x: 100, y: 300, width: 100, height: 100)
        let str =  NSMutableAttributedString.init(string: "Did not pass ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),.foregroundColor:UIColor.black])


        let imStr = NSMutableAttributedString.mk_image(im: UIImage.init(named: "face")!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        str.append(imStr)



        let tap = NSMutableAttributedString.init(string: "可点击字符", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),.foregroundColor:UIColor.black])
        let response = MK_TapResponse.init(highlite: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : UIColor.red]
        }) { (str, range) in
            print("点击字符串~")
        }
        tap.addTapAttr(response: response, range: nil)
        str.append(tap)


        let v = UISwitch.init()
        let viewStr = NSMutableAttributedString.mk_view(view: v,size: v.bounds.size ,alignType: NSMutableAttributedString.AlignType.center)
        str.append(viewStr)

        let imStr1 = NSMutableAttributedString.mk_image(im: UIImage.init(named: "face")!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.center)
        str.append(imStr1)

        self.view.addSubview(ml)

        ml.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(100)
            make.width.equalTo(240)
        }
        ml.text = str

        for i in 0...100{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(i)*0.1, execute: {
                ml.attributeStr = str
            })
        }


    }
}

