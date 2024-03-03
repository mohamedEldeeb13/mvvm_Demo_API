//
//  userView.swift
//  mvvm_Demo_API
//
//  Created by Mohamed Abd Elhakam on 25/12/2023.
//

import SwiftUI

struct userView: View {
    let user : User
    var body: some View {
        VStack(alignment: .leading)
        {
            Text("**Name**: \(user.name)")
            Text("**Email**: \(user.email)")
            Divider()
            Text("**Company**: \(user.company.name)")
        }
        .frame(maxWidth: .infinity,  alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal , 4)
    }
}

#Preview {
    userView(user: User(id: 0, name: "mo", email: "mcoc", company: .init(name: "sini")))
    
}
