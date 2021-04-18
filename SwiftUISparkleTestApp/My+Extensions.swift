//
//  My+Extensions.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 18.04.21.
//

import Foundation

// disable default focus ring
extension NSTextField {

  open override var focusRingType: NSFocusRingType {
    get { .none }
    set { }
  }

}
