//
//  recursiveObjects.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


/**
 This method will perform a *recursive descent* on `object` using the value under `keyPath` and collect all objects on the way until the value under `keyPath` is *nil*.
 */
public
func recursiveObjects<T>
(
    on object: T,
    keyPath: KeyPath<T, T?>
)
-> [T]
{
    let result: [T]
    
    if let child = object[keyPath: keyPath]
    {
        result = [object] + recursiveObjects(on: child,
                                             keyPath: keyPath)
    }
    else
    {
        result = [object]
    }
    
    return result
}
