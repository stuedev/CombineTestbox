//
//  String+truncate.swift
//  
//
//  Created by Stefan Ueter on 27.03.23.
//

import Foundation


extension String
{
    public
    func truncate
    (
        maxLength: Int
    )
    -> String
    {
        if self.count <= maxLength
        {
            return self
        }
        else
        {
            return self.prefix(maxLength - 3) + "..."
        }
    }
}
