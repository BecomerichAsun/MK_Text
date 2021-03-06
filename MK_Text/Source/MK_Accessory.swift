//
//  MK_Accessory.swift
//  MK_Text
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreText

public extension NSMutableAttributedString {
    ///内容
    enum ContentType {

        case image (MK_Image,CGSize)

        case view (MK_View,CGSize)
    }

    ///对齐方式
    enum AlignType{
        case center

        case bottom

        case top

        case custom(CGFloat)
    }


    /// 设置图像富文本
    ///
    /// - Parameters:
    ///   - im: Image
    ///   - size: 像是Image大小,默认显示image原始大小
    ///   - alignType: 与字行中线对齐方式
    /// - Returns: 图像富文本
    static func mk_image(im:MK_Image,size:CGSize = CGSize.zero,alignType:AlignType = .center)->NSMutableAttributedString{
        let conSize = size == CGSize.zero ? im.size : size
        let acc = MK_Accessory.init(con: ContentType.image(im, conSize), ali: alignType)
        return acc.turnToAttrStr()
    }


    /// 设置控件富文本
    ///
    /// - Parameters:
    ///   - view: 放置的View
    ///   - superView: 传入其所在Label
    ///   - size: View大小
    ///   - alignType: 与字行中线对齐方式
    /// - Returns: 控件富文本
    static func mk_view(view:MK_View,size:CGSize,alignType:AlignType = .center)->NSMutableAttributedString{
        let acc = MK_Accessory.init(con: NSMutableAttributedString.ContentType.view(view,size), ali: alignType)
        return acc.turnToAttrStr()
    }
    
}


///富文本中附件
class MK_Accessory:NSObject {

    static var AttributeKeyStr = "MK_Accessory_AttributeKeyStr"

    static let Attribute_PlaceholderStr = " "

    var content:NSMutableAttributedString.ContentType!

    var align:NSMutableAttributedString.AlignType!

    init(con:NSMutableAttributedString.ContentType,ali:NSMutableAttributedString.AlignType) {
        super.init()
        content = con
        align = ali
    }

    class AccessorySize {
        var MK_Accessory_Height:CGFloat = 0.0
        var MK_Accessory_Width:CGFloat = 0.0
        var MK_Accessory_Descent:CGFloat = 0.0
    }

    ///附件大小信息
    var acc_Size = AccessorySize.init()


    ///转换为属性字符串
    func turnToAttrStr()->NSMutableAttributedString{


        switch content! {
        case .image(let (_, size)),.view(let (_, size)):
            acc_Size.MK_Accessory_Width = size.width
            acc_Size.MK_Accessory_Height = size.height
        }
        switch align! {
        case .center:
            acc_Size.MK_Accessory_Descent = 0.0
        case .bottom:
            acc_Size.MK_Accessory_Descent = -acc_Size.MK_Accessory_Height * 0.5
        case .top:
            acc_Size.MK_Accessory_Descent = acc_Size.MK_Accessory_Height * 0.5
        case .custom(let (cus)):
            acc_Size.MK_Accessory_Descent = cus * CGFloat(0.5)
        }

        let res = NSMutableAttributedString.init(string: MK_Accessory.Attribute_PlaceholderStr)
        res.addAttributes([NSAttributedStringKey.init(MK_Accessory.AttributeKeyStr):self], range: NSRange.init(location: 0, length: res.length))
        return res
    }

    static func removeViewFrom(str:NSAttributedString){
        let arr:[MK_Accessory] = str.getAttributeValue(name: NSAttributedStringKey.init(MK_Accessory.AttributeKeyStr))

        arr.forEach { (acc) in
            guard let type = acc.content else {return}
            switch type {
            case .image(_, _): break
            case let .view(v, _):
                v.removeFromSuperview()
            }
        }
    }

}

extension MK_Accessory {
    
    ///中心对附件顶边的距离
    var CenterToTop:CGFloat{
        get{
            return acc_Size.MK_Accessory_Height * 0.5 - acc_Size.MK_Accessory_Descent
        }
    }
    ///中心对附件底边的距离
    var CenterToBottom:CGFloat{
        get{
            return acc_Size.MK_Accessory_Height * 0.5 + acc_Size.MK_Accessory_Descent
        }
    }

}


extension NSAttributedString {

    ///获取单个字符富文本中附件
    func getAccessoryFromCha()->MK_Accessory?{
        guard self.string == MK_Accessory.Attribute_PlaceholderStr else { return nil }
        let res : MK_Accessory? = self.getAttributeValue(name: NSAttributedStringKey.init(MK_Accessory.AttributeKeyStr)).first
        return res
    }
}


