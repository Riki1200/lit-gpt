//
//  LLMModel.swift
//  TapGPT
//
//  Created by Romeo Betances on 6/5/25.
//

import Foundation
import LLM

class Model: LLM {
    convenience init?() {
        guard let url = Bundle.main.url(forResource: "Llama-3.2-1B-Instruct-Q4_K_M", withExtension: "gguf") else {
            print("Error: archivo no encontrado")
          return nil
        }

        self.init(from: url, template: .chatML())!
    }
}
