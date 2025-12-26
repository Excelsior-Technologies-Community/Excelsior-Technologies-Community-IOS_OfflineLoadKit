//
//  ContentView.swift
//  IOS_OfflineLoadKit
//
//  Created by Noman belim on 26/12/25.
//

import SwiftUI
import SwiftUI
import CoreData

struct ContentView: View {

    // Core Data context
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch saved persons
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: []
    )
    private var people: FetchedResults<Person>

    // User input states
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var ageText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                // 🔹 INPUT FIELDS
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)

                TextField("Age", text: $ageText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                // 🔹 SAVE BUTTON
                Button("Save to Core Data") {
                    savePerson()
                }
                .buttonStyle(.borderedProminent)

                Divider()

                // 🔹 SAVED DATA LIST
                List {
                    ForEach(people) { person in
                        VStack(alignment: .leading) {
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                                .font(.headline)
                            Text("Age: \(person.age)")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Offline Core Data")
        }
    }

    // MARK: - Save Person
    private func savePerson() {
        guard let age = Int16(ageText) else { return }

        let person = Person(context: viewContext)
        person.firstName = firstName
        person.lastName = lastName
        person.age = age

        do {
            try viewContext.save()

            // Clear input after save
            firstName = ""
            lastName = ""
            ageText = ""

        } catch {
            print("Failed to save:", error)
        }
    }
}



#Preview {
    ContentView()
}
