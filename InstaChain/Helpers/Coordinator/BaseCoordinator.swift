import Foundation
import UIKit


protocol ChildCoordinable {
    var childCoordinators: [Coordinator] { get set }
    func addDependency(_ coordinator: Coordinator)
    func removeDependency(_ coordinator: Coordinator?)
}


class BaseCoordinator: Coordinator, ChildCoordinable {
    
    var childCoordinators: [Coordinator] = []
    
    var completionHandler: (() -> ())?
    
    func start() {
        
    }
        
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
