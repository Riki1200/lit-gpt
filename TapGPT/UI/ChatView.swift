//
//  ChatView.swift
//  TapGPT
//
//  Created by Romeo Betances on 12/4/25.
//

import SwiftUI
import LLM
import CoreData
import SwiftData





struct ChatView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ChatViewModel
    @State private var multiLineText = ""
    @Binding var _presentSideMenu: Bool

    init(model: Model?, context: ModelContext, presentSideMenu: Binding<Bool>) {
        
           _viewModel = StateObject(wrappedValue: ChatViewModel(model: model, context:  context))
           __presentSideMenu = presentSideMenu
         
       }

    var body: some View {
        
 
            VStack(spacing: 0) {
              
                HStack {
             
                    Button {
                        _presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.lefthalf.filled")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }

                    Spacer()

                 
                    Text("Chat")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    Spacer()

                  
                    Image(systemName: "rectangle.portrait.lefthalf.filled")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
                
            

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if message.sender == .assistant {
                                        Text(message.text)
                                            .padding()
                                            .background(Color.secondary.opacity(0.2))
                                            .cornerRadius(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                                .id(message.id)
                            }

                            if viewModel.isLoading {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .padding(10)
                                        .background(Color.secondary.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            }

                            Color.clear.frame(height: 1).id("bottomID")
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .onChange(of: viewModel.messages.count) {
                        withAnimation {
                            proxy.scrollTo("bottomID", anchor: .bottom)
                        }
                    }
                }

        
                
                
            }.safeAreaInset(edge: .bottom, content:  {
                HStack(alignment: .bottom, spacing: 0) {
                    
                    ZStack(alignment: .topLeading) {
                        Text("Typing something...")
                              .foregroundColor(.gray)
                              .padding(.horizontal, 20)
                              .padding(.vertical, 14)
                              .opacity(multiLineText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0)
                        TextEditor(text: $multiLineText)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color(.secondarySystemBackground))
                            
                            .frame(minHeight: 40, maxHeight: 120)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.clear, lineWidth: 0)
                            )
                    }
                   

                    Button(action: {
                        let textToSend = multiLineText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !textToSend.isEmpty && !viewModel.isLoading else { return }

                        multiLineText = ""
                        Task {
                            await viewModel.send(textToSend)
                        }
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(viewModel.isLoading ? .gray : .blue)
                            .opacity(viewModel.isLoading ? 0.5 : 1.0)
                    }
                    .disabled(viewModel.isLoading)

                    Button(action: {
                        viewModel.clear()
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(24, corners: [.topLeft, .topRight])
            })

            .background(Color(.systemBackground))
            .hideKeyboardOnTap()
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
    }
}




#Preview {
    ContentView()
        .modelContainer(for: ChatMessage.self, inMemory: true)
}

