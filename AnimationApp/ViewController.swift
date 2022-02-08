//
//  ViewController.swift
//  AnimationApp
//
//  Created by Сергей Матвеенко on 01.02.2022.
//

import UIKit

class ViewController: UIViewController {
    public var animationRectangle = UIView()
    private let animationButton = UIButton(type: .system)
    private var rectanglePosition: RectanglePosition = .center
    private lazy var animationModelVc = {
        AnimationModel.init(vc: self)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        animationRectangleSetup()
        animationButtonSetup()
        animationModelVc.setupGestures()
        view.isUserInteractionEnabled = true
    }
    
    // передергивает вид при провороте экрана чтобы квадратик не "улетал"
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationModelVc.animateToPosition(rectanglePosition)
    }
    //    MARK: - VIEW setuping:
    // настройка View квадратика
    private func animationRectangleSetup() {
        let viewR = animationRectangle
        viewR.translatesAutoresizingMaskIntoConstraints = false
        viewR.backgroundColor = UIColor(red: 0, green: 1, blue: 221/225, alpha: 1)
        viewR.isUserInteractionEnabled = true
        view.addSubview(viewR)
        NSLayoutConstraint.activate([
            viewR.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewR.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewR.heightAnchor.constraint(equalToConstant: 100),
            viewR.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // настройка View кнопки
    private func animationButtonSetup() {
        let button = animationButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Animation", for: .normal)
        button.setTitle("Animating process ...", for: .highlighted)
        button.backgroundColor = UIColor(red: 94/255, green: 0, blue: 1, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(animationButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
    }
}
//    MARK: - IBAction for button

extension ViewController {
    /* при нажатии на кнопку перебирается enum по очереди при помощи функции next() в нем
     затем дергается функция, отвечающая за анимацию animateToPosition() где на вход приходит новое значение позиции rectanglePosition из enum */
    @objc private func animationButtonTapped() {
        rectanglePosition = rectanglePosition.next()
        animationModelVc.animateToPosition(rectanglePosition)
    }
}





