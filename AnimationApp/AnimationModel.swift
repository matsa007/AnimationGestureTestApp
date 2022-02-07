//
//  AnimationModel.swift
//  AnimationApp
//
//  Created by Сергей Матвеенко on 07.02.2022.
//

import UIKit

enum RectanglePosition: CaseIterable {
    case center
    case topLeftCorner
    case topRightCorner
    case bottomRightCorner
    case bottomLeftCorner
    
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex: next]
    }
}

class AnimationModel {
    weak private var childVc: ViewController?
    private var vc: ViewController {
        childVc!
    }
    init(vc: ViewController) {
        self.childVc = vc
    }
    private let toTheLeft = -1 , toTheRight = 1, toTheTop = -1, toTheBottom = 1, center = 0
    
    private func direction(xDirection: Int, yDirection: Int, isRotation: Bool) {
        let x = ((vc.view.frame.width/2) - (vc.animationRectangle.frame.width/2)), y = ((vc.view.frame.height/2) - (vc.animationRectangle.frame.height/2))
        if isRotation {
            if xDirection == center && yDirection == center {
                UIView.animate(withDuration: 2, animations: {
                    self.vc.animationRectangle.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
                }, completion: { (finished: Bool) in
                    self.vc.animationRectangle.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            } else {
                vc.animationRectangle.transform = CGAffineTransform(translationX: x*CGFloat(xDirection), y: y*CGFloat(yDirection)).rotated(by: CGFloat.pi / 4)
            }
        } else {
            vc.animationRectangle.transform = CGAffineTransform(translationX: x*CGFloat(xDirection), y: y*CGFloat(yDirection))
        }
    }
    
    func animateToPosition(_ position: RectanglePosition) {
        UIView.animate(withDuration: 2) { [self] in
            switch position {
            case .topLeftCorner:
                direction(xDirection: toTheLeft, yDirection: toTheTop, isRotation: true)
            case .topRightCorner:
                direction(xDirection: toTheRight, yDirection: toTheTop, isRotation: false)
            case .bottomRightCorner:
                direction(xDirection: toTheRight, yDirection: toTheBottom, isRotation: true)
            case .bottomLeftCorner:
                direction(xDirection: toTheLeft, yDirection: toTheBottom, isRotation: false)
            case .center:
                direction(xDirection: center, yDirection: center, isRotation: true)
            }
        }
    }
    
    func setupGestures() {
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateTriggered))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panTriggered))
        vc.animationRectangle.addGestureRecognizer(panGesture)
        vc.animationRectangle.addGestureRecognizer(rotateGesture)
    }
}

extension AnimationModel {
    @objc private func panTriggered(sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.vc.view)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(.zero, in: vc.view)
        }
    }
    
    @objc private func rotateTriggered(gestureRecognizer: UIRotationGestureRecognizer) {
        if let view = gestureRecognizer.view {
            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }
}


//    @objc private func rotateTriggered(gestureRecognizer: UIRotationGestureRecognizer) {
//
//        if let view = gestureRecognizer.view {
//            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
//        }
//
//        var lastRotation = CGFloat()
//        self.view.bringSubviewToFront(animationRectangle)
//        let rotation = 0 - (lastRotation - gestureRecognizer.rotation)
//        let currentTransformation = gestureRecognizer.view!.transform
//        let newTransformation = currentTransformation.rotated(by: rotation)
//        gestureRecognizer.view!.transform = newTransformation
//        lastRotation = gestureRecognizer.rotation
//    }