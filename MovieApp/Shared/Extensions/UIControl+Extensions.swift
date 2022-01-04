//
//  UIControl+Extensions.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.01.2022..
//

import Combine
import UIKit

extension UIButton {
    
    class InteractionSubscription<S: Subscriber>: Subscription
    where S.Input == Void {
        
        private let subscriber: S?
        private let button: UIButton
        private let event: UIControl.Event
        
        init(subscriber: S,
             button: UIButton,
             event: UIControl.Event) {
            
            self.subscriber = subscriber
            self.button = button
            self.event = event
            
            self.button.addTarget(self, action: #selector(handleEvent), for: event)
            
        }
        
        @objc func handleEvent(_ sender: UIButton) {
            _ = self.subscriber?.receive(())
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {}
    }
    
    struct InteractionPublisher: Publisher {
        
        typealias Output = Void
        typealias Failure = Never
        
        private let button: UIButton
        private let event: UIControl.Event
        
        init(button: UIButton, event: UIControl.Event) {
            self.button = button
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                button: button,
                event: event
            )
            
            subscriber.receive(subscription: subscription)
        }
        
    }
    func publisher(for event: UIButton.Event) -> UIButton.InteractionPublisher {
            return InteractionPublisher(button: self, event: event)
        }
    
}
