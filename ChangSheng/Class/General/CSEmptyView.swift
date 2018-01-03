//
//  APEmptyView.swift
//  EmptyKit-Demo
//
//  Created by cnepayzx on 2017/12/19.
//  Copyright © 2017年 archerzz. All rights reserved.
//

import UIKit
import EmptyKit

struct APEmptyConfig {
    static var titleFont : CGFloat!
    static var titleColor : UInt32!
    static var title : String!
    static var image : String!
    static var verticalSpace : CGFloat!
    static var verticalOffset : CGFloat!
    
    var titleFont : CGFloat = 14
    var titleColor : UInt32 = 0x484848
    var title = "暂无数据记录"
    var image = "Table_Empty_Image"
    var verticalSpace : CGFloat = 22
    var verticalOffset : CGFloat = 0
    
    static func clear(){
        titleFont = 14
        titleColor = 0x484848
        title = "暂无数据记录"
        image = "Table_Empty_Image"
        verticalSpace = 22
        verticalOffset = 0
    }
}
// MARK: - Setup
extension UITableView : EmptyDataSource, EmptyDelegate{
    
    func AP_setupEmpty(customConfig config : APEmptyConfig){
        APEmptyConfig.clear()
        APEmptyConfig.title = config.title
        APEmptyConfig.titleFont = config.titleFont
        APEmptyConfig.titleColor = config.titleColor
        APEmptyConfig.image = config.image
        APEmptyConfig.verticalSpace = config.verticalSpace
        APEmptyConfig.verticalOffset = config.verticalOffset
        self.ept.dataSource = self
        self.ept.delegate = self
    }
    
    func AP_setupEmpty(){
        APEmptyConfig.clear()
        self.ept.dataSource = self
        self.ept.delegate = self
    }
    
    public func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: APEmptyConfig.image)
    }
    
    public func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let title = APEmptyConfig.title
        let font = UIFont.systemFont(ofSize: APEmptyConfig.titleFont)
        let attributes: [NSAttributedStringKey : Any] = [.foregroundColor: UIColor.init(hex6: APEmptyConfig.titleColor), .font: font]
        return NSAttributedString(string: title!, attributes: attributes)
    }
    
    public func verticalSpaceForEmpty(in view: UIView) -> CGFloat {
        return APEmptyConfig.verticalSpace
    }
    
    public func verticalOffsetForEmpty(in view: UIView) -> CGFloat {
        return APEmptyConfig.verticalOffset
    }
    
    /*
     public func emptyButton(_ button: UIButton, tappedIn view: UIView) {
     print( #function, #line, type(of: self))
     }
     
     public func emptyView(_ emptyView: UIView, tappedIn view: UIView) {
     print( #function, #line, type(of: self))
     }
     */
}
