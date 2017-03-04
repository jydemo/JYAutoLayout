//
//  AutoLayout.swift
//  JYAutoLayout
//
//  Created by atom on 2017/3/4.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

public enum JY_AlignType {
    case topLeft
    case topRight
    case topCenter
    case bottomLeft
    case bottomRight
    case bottomCenter
    case centerLeft
    case centerRight
    case center
    
    fileprivate func layoutAttributes(_ isInner: Bool, isVertical: Bool) -> JY_LayoutAttributes {
        let attributes = JY_LayoutAttributes()
        switch self {
        case .topLeft:
            let _ = attributes.horizontals(.left, to: .left).verticals(.top, to: .top)
            if isInner {
                print("topLeft 在内部")
                return attributes
            } else if isVertical {
                print("topLeft 垂直")
                return attributes.verticals(.bottom, to: .top)
            } else {
                print("topLeft 既不在内部也不垂直 水平")
                return attributes.horizontals(.right, to: .left)
            }
            
        case .topRight:
            let _ = attributes.horizontals(.right, to: .right).verticals(.top, to: .top)
            if isInner {
                print("topRight 在内部")
                return attributes
            } else if isVertical {
                print("topRight 垂直")
                return attributes.verticals(.bottom, to: .top)
            } else {
                 print("topRight 既不在内部也不垂直 水平")
                return attributes.horizontals(.left, to: .right)
            }
            
        case .bottomLeft:
            let _ = attributes.horizontals(.left, to: .left).verticals(.bottom, to: .bottom)
            if isInner {
                print("bottomLeft 内部")
                return attributes
            } else if isVertical {
                print("bottomLeft 垂直")
                return attributes.verticals(.top, to: .bottom)
            } else {
                print("bottomLeft 水平")
                return attributes.horizontals(.right, to: .left)
            }
            
        case .bottomRight:
            let _ = attributes.horizontals(.right, to: .right).verticals(.bottom, to: .bottom)
            if isInner {
                print("bottomRight 内部")
                return attributes
            } else if isVertical {
                print("bottomRight 垂直")
                return attributes.verticals(.top, to: .bottom)
            } else {
                print("bottomRight 水平")
                return attributes.horizontals(.left, to: .right)
            }
        
        case .topCenter:
            print("topCenter")
            let _ = attributes.horizontals(.centerX, to: .centerX).verticals(.top, to: .top)
            return isInner ? attributes : attributes.verticals(.bottom, to: .top)
            
        case .bottomCenter:
            print("bottomCenter")
            let _ = attributes.horizontals(.centerX, to: .centerX).verticals(.bottom, to: .bottom)
            return isInner ? attributes : attributes.verticals(.top, to: .bottom)
        case .centerLeft:
            print("centerLeft")
            let _ = attributes.horizontals(.left, to: .left).verticals(.centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(.right, to: .left)
        case .centerRight:
            print("centerRight")
            let _ = attributes.horizontals(.right, to: .right).verticals(.centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(.left, to: .right)
        case .center:
            print("center")
            return JY_LayoutAttributes(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        default:
            break
            
        }
    }
}

extension UIView {
    public func jy_fill(_ referView: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
       translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView": self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: .alignAllLastBaseline, metrics: nil, views: ["subView": self])
        superview?.addConstraints(cons)
        return cons
    }
    
    public func jy_AlignInner(_ type: JY_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return jy_AlignLayout(referView, attributes: type.layoutAttributes(true, isVertical: true), size: size, offset: offset)
        
    }
    
    public func jy_algnVertical(_ type: JY_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        return jy_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: true), size: size, offset: offset)
        
    }
    
    public func jy_alignHorizontal(_ type: JY_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        
        return jy_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: false), size: size, offset: offset)
        
    }
    
    public func jy_HorizontalTitle(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        assert(!views.isEmpty, "views should not be empty")
        var cons = [NSLayoutConstraint]()
        let firstView = views[0]
        let _ = firstView.jy_AlignInner(JY_AlignType.topLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -insets.bottom))
        
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.jy_sizeConstraints(referView: firstView)
            let _ = subView.jy_alignHorizontal(JY_AlignType.topRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -insets.right))
        addConstraints(cons)
        return cons
    }
    
    public func jy_constraint(constraninsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
    
        for constraint in constraninsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    private func jy_AlignLayout(_ referView: UIView, attributes: JY_LayoutAttributes, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += jy_posittionConstraints(referView: referView, attributes: attributes, offset: offset)
        if size != nil {
            cons += jy_sizeConstraints(size: size!)
        }
        superview?.addConstraints(cons)
        return cons
    }
    
    private func jy_sizeConstraints(referView: UIView) -> [NSLayoutConstraint] {
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: referView, attribute: .width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: referView, attribute: .height, multiplier: 1.0, constant: 0))
        return cons
    }
    
    private func jy_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.height))
        return cons
    }
    
    private func jy_posittionConstraints(referView: UIView, attributes: JY_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint] {
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: .equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: .equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        return cons
    }
}

fileprivate final class JY_LayoutAttributes {
    var horizontal: NSLayoutAttribute
    var referHorizontal: NSLayoutAttribute
    var vertical: NSLayoutAttribute
    var referVertical: NSLayoutAttribute
    
    init() {
        horizontal = .left
        referHorizontal = .left
        vertical = .top
        referVertical = .top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    fileprivate func horizontals(_ from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        return self
    }
    
    fileprivate func verticals(_ from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        return self
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
