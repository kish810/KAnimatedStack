//
//  StackCard.swift
//  KAnimatedStack
//
//  Created by Kishore S on 08/03/21.
//

import UIKit

public protocol StackCardDelegate: class {
    var sourceViewController: UIViewController? { get }
    
    func controller(for card: StackCard) -> UIViewController?
    func inactiveView(for card: StackCard) -> UIView?
    func collapsedTitle(for card: StackCard) -> String?
    
    func activate(_ card: StackCard)
    
}

public class StackCard: UIView {
    
    public enum State {
        case active
        case inactive
        case collapsed
    }
    
    public struct Properties {
        public var cornerRadius: CGFloat = 20
        public var backgroundColor: UIColor = .secondarySystemBackground
        
        public var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.2)
        public var shadowRadius: CGFloat = 8
        public var shadowOffset: CGSize = .init(width: 0, height: -5)

        public var collapsedBackgroundColor: UIColor = .systemPink
        public var collapsedTitleColor: UIColor = .white

        var arrowColor: UIColor = .label
        
        public init() {
            
        }
    }
    
    public var properties: Properties = Properties() {
        didSet {
            self.updateProperties()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collapsedView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collapsedLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        view.preferredSymbolConfiguration = .init(weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var inactiveContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
    
    public let index: Int
    
    private weak var controller: UIViewController?
    
    private weak var inactiveView: UIView?
    
    public weak var delegate: StackCardDelegate?
    
    public var state: State = .collapsed
    
    lazy var collapsedViewBottomContraint: NSLayoutConstraint = self.collapsedView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    
    var topContraint: NSLayoutConstraint?
    
    public init(index: Int, delegate: StackCardDelegate?) {
        self.index = index
        self.delegate = delegate
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeController()
    }
    
    private func configure() {
        
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(containerView)
        self.addSubview(inactiveContainerView)
        inactiveContainerView.addSubview(iconView)
        self.addSubview(collapsedView)
        collapsedView.addSubview(collapsedLabel)
        
        
        NSLayoutConstraint.activate([
            inactiveContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            inactiveContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            inactiveContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            
            iconView.centerYAnchor.constraint(equalTo: inactiveContainerView.centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: inactiveContainerView.trailingAnchor, constant: -20),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            collapsedView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collapsedView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collapsedView.topAnchor.constraint(equalTo: self.topAnchor),
            
            collapsedLabel.leadingAnchor.constraint(equalTo: collapsedView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collapsedLabel.topAnchor.constraint(equalTo: collapsedView.safeAreaLayoutGuide.topAnchor, constant: 20),
            collapsedLabel.bottomAnchor.constraint(equalTo: collapsedView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collapsedLabel.trailingAnchor.constraint(equalTo: collapsedView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        self.updateProperties()
        self.set(state: .collapsed, animated: false)
    }
    
    private func updateProperties() {
        self.clipsToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = properties.shadowColor.cgColor
        self.layer.shadowRadius = properties.shadowRadius
        self.layer.shadowOffset = properties.shadowOffset
        self.containerView.layer.cornerRadius = properties.cornerRadius
        self.containerView.backgroundColor = properties.backgroundColor
        self.iconView.tintColor = properties.arrowColor
        
        self.collapsedView.layer.cornerRadius = properties.cornerRadius
        self.collapsedView.backgroundColor = properties.collapsedBackgroundColor
        self.collapsedLabel.textColor = properties.collapsedTitleColor
    }
    
    public func setController() {
        guard let controller = self.delegate?.controller(for: self), let parent = self.delegate?.sourceViewController else {
            return
        }
        self.controller = controller
        parent.addChild(controller)
        self.containerView.addSubview(controller.view)
        controller.didMove(toParent: parent)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    public func removeController() {
        if let existingController = self.controller {
            existingController.willMove(toParent: nil)
            existingController.view.removeFromSuperview()
            existingController.removeFromParent()
        }
    }
    
    public func setInactiveView() {
        guard let inactiveView = self.delegate?.inactiveView(for: self) else {
            return
        }
        
        self.inactiveView = inactiveView
        
        inactiveContainerView.addSubview(inactiveView)
        inactiveView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inactiveView.topAnchor.constraint(equalTo: inactiveContainerView.topAnchor, constant: 20),
            inactiveView.leadingAnchor.constraint(equalTo: inactiveContainerView.leadingAnchor, constant: 20),
            inactiveView.bottomAnchor.constraint(equalTo: inactiveContainerView.bottomAnchor, constant: -20),
            inactiveView.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -10)
        ])
    }
    
    public func removeInactiveView() {
        self.inactiveView?.removeFromSuperview()
    }
    
    public func set(state: State, animated: Bool = true) {
        
        let duration = animated ? 0.7 : 0
        
        let previousState = self.state
        self.state = state
        
        switch state {
        case .active:
            
            if self.controller == nil {
                self.setController()
                if animated {
                    self.superview?.layoutIfNeeded()
                }
            }
            
            collapsedViewBottomContraint.isActive = true
            topContraint?.isActive = true
            
            tapGesture.isEnabled = false
            
            self.controller?.view.isHidden = false
            
            if animated {
                UIView.animate(withDuration: duration) {
                    self.controller?.view.alpha = 1
                    
                    self.inactiveContainerView.alpha = 0
                    self.collapsedView.alpha = 0
                    
                    if previousState == .collapsed {
                        self.superview?.layoutIfNeeded()
                    } else {
                        self.layoutIfNeeded()
                    }
                    
                } completion: { (finished) in
                    self.inactiveContainerView.isHidden = true
                    self.collapsedView.isHidden = true
                    self.removeInactiveView()
                }
            } else {
                self.controller?.view.alpha = 1
                
                self.inactiveContainerView.alpha = 0
                self.collapsedView.alpha = 0
                
                self.inactiveContainerView.isHidden = true
                self.collapsedView.isHidden = true
                self.removeInactiveView()
            }
            
            
        case .inactive:
            
            if self.inactiveView == nil {
                self.setInactiveView()
                if animated {
                    self.superview?.layoutIfNeeded()
                }
            }
            
            collapsedViewBottomContraint.isActive = false
            topContraint?.isActive = true
            
            tapGesture.isEnabled = true
            
            self.inactiveContainerView.isHidden = false
            
            if animated {
                UIView.animate(withDuration: duration) {
                    self.inactiveContainerView.alpha = 1
                    
                    self.controller?.view.alpha = 0
                    self.collapsedView.alpha = 0
                    
                    self.layoutIfNeeded()
                } completion: { (finished) in
                    self.collapsedView.isHidden = true
                    self.controller?.view.isHidden = true
                }
            } else {
                self.inactiveContainerView.alpha = 1
                
                self.controller?.view.alpha = 0
                self.collapsedView.alpha = 0
                
                self.collapsedView.isHidden = true
                self.controller?.view.isHidden = true
            }
        case .collapsed:
            
            topContraint?.isActive = false
            collapsedViewBottomContraint.isActive = true
            
            collapsedLabel.text = self.delegate?.collapsedTitle(for: self)
            
            tapGesture.isEnabled = true
                        
            self.collapsedView.isHidden = false
            
            if animated {
                UIView.animate(withDuration: duration) {
                    self.collapsedView.alpha = 1
                    
                    self.inactiveContainerView.alpha = 0
                    self.controller?.view.alpha = 0
                    
                    self.superview?.layoutIfNeeded()
                } completion: { (finished) in
                    self.removeController()
                    self.removeInactiveView()
                    self.inactiveContainerView.isHidden = true
                }
            } else {
                self.removeController()
                self.removeInactiveView()

                self.collapsedView.alpha = 1
                
                self.inactiveContainerView.alpha = 0
                self.controller?.view.alpha = 0
                
                self.inactiveContainerView.isHidden = true
            }
        }
    }
    
    func open(animated: Bool = true, parentView: UIView) {
        let duration = animated ? 0.7 : 0
        
        parentView.addSubview(self)
        
        if animated {
            let hideConstraint = self.topAnchor.constraint(equalTo: parentView.bottomAnchor)
            
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                hideConstraint,
            ])
            
            parentView.layoutIfNeeded()
            
            hideConstraint.isActive = false
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
            
            UIView.animate(withDuration: duration) {
                parentView.layoutIfNeeded()
            }
        } else {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            ])
        }
    }
    
    func close(animated: Bool = true) {
        let duration = animated ? 0.7 : 0
        
        let height = self.frame.size.height
        
        if animated {
            UIView.animate(withDuration: duration) {
                self.transform = self.transform.translatedBy(x: 0, y: height)
            } completion: { (finished) in
                self.removeController()
                self.removeInactiveView()
                self.removeFromSuperview()
            }
        } else {
            self.removeController()
            self.removeInactiveView()
            self.removeFromSuperview()
        }
    }
    
    @objc private func tapped(_ gesture: UITapGestureRecognizer) {
        self.delegate?.activate(self)
        self.set(state: .active)
    }
}
