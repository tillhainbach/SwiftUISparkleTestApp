//
//  InputValidationTextFieldStyle.swift
//  SwiftUISparkleTestApp
//
//  Created by Till Hainbach on 18.04.21.
//

import SwiftUI

/// Draws red or green rectangle around textfield based on input
struct InputValidationTextFieldStyle: TextFieldStyle {
  @Binding var isValidInput: Bool

  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(5)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .stroke(isValidInput ? Color.green : Color.red, lineWidth: 2)
      )
  }

}
