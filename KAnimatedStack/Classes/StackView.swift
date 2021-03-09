//
//  StackView.swift
//  KAnimatedStack
//
//  Created by Kishore S on 09/03/21.
//

import UIKit

public protocol StackViewDelegate: class {
    
    var sourceViewController: UIViewController { get }
    
    func numberOfItems(in stackView: StackView) -> Int
    
    func controller(forIndex index: Int, stackView: StackView) -> UIViewController?
    func inactiveView(forIndex index: Int, stackView: StackView) -> UIView
    func collapsedTitle(forIndex index: Int, stackView: StackView) -> String
    
    func properties(forIndex index: Int, stackView: StackView) -> StackCard.Properties
}

public class StackView: UIView {
    
    weak var delegate: StackViewDelegate?
    
    private var cards: [StackCard] = []
    
    public init(delegate: StackViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        if let firstCard = self.addNext(animated: false) {
            firstCard.set(state: .active, animated: false)
        }
        
        self.addNext(animated: false)
    }
    
    @discardableResult private func addNext(animated: Bool) -> StackCard? {
        guard let maxCount = self.delegate?.numberOfItems(in: self), self.cards.count < maxCount else {
            return nil
        }
        
        let index = self.cards.count
        
        let card = StackCard(index: index, delegate: self)
        card.translatesAutoresizingMaskIntoConstraints = false
        if let properties = self.delegate?.properties(forIndex: index, stackView: self) {
            card.properties = properties
        }

        let topRefanchor = self.cards.last?.inactiveContainerView.bottomAnchor ?? self.topAnchor
        card.topContraint = card.topAnchor.constraint(equalTo: topRefanchor)

        self.cards.append(card)
        
        card.open(animated: animated, parentView: self)

        return card
    }
}

extension StackView: StackCardDelegate {
    public var sourceViewController: UIViewController? {
        return delegate?.sourceViewController
    }
    
    public func controller(for card: StackCard) -> UIViewController? {
        return delegate?.controller(forIndex: card.index, stackView: self)
    }
    
    public func inactiveView(for card: StackCard) -> UIView? {
        return delegate?.inactiveView(forIndex: card.index, stackView: self)
    }
    
    public func collapsedTitle(for card: StackCard) -> String? {
        return delegate?.collapsedTitle(forIndex: card.index, stackView: self)
    }
    
    public func activate(_ card: StackCard) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        
        for index in 0..<self.cards.count {
            let existingCard = self.cards[index]
            
            if index < card.index {
                existingCard.set(state: .inactive)
            } else if index == card.index + 1 {
                existingCard.set(state: .collapsed)
            } else if index > card.index + 1 {
                break
            }

        }
        
        if self.cards.last == card {
            self.addNext(animated: true)
        }
        else {
            if card.index < delegate.numberOfItems(in: self) - 1 {

                let remianingCards = cards.suffix(from: card.index + 2)

                for remianingCard in remianingCards {
                    remianingCard.close(animated: true)
                }

                self.cards.removeLast(remianingCards.count)

            }
        }
    }
    
}
