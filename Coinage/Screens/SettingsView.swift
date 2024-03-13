//
//  SwiftUIView.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/11/24.
//

import SwiftUI

protocol SettingsViewDelegate {
    func didPressCategories()
    func didPressDeleteAllTransactions()
}

struct SettingsView: View {
    @State var isDeleteAllTransactionsSheetPresented = false
    var delegate: SettingsViewDelegate?
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Button {
                        delegate?.didPressCategories()
                    } label: {
                        HStack {
                            Text("Categories")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color(UIColor.systemGray2))
                        }
                        .foregroundStyle(Color(uiColor: .label))
                    }
                }
            }
            Section {
                Button {
                    isDeleteAllTransactionsSheetPresented = true
                } label: {
                    Text("Delete all transactions")
                        .foregroundStyle(.red)
                }
            }
        }
        .confirmationDialog("Select \"Delete transactions\" to delete all saved transactions", isPresented: $isDeleteAllTransactionsSheetPresented, titleVisibility: .visible) {
            Button(role: .destructive) {
                isDeleteAllTransactionsSheetPresented = false
                delegate?.didPressDeleteAllTransactions()
            } label: {
                Text("Delete transactions")
            }
        }
        
    }
}

#Preview {
    SettingsView()
}
