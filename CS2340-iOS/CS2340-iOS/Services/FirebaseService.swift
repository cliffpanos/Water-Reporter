//
//  FirebaseService.swift
//  HB141
//
//  Created by Daniel Becker on 2/22/17.
//  Copyright © 2017 International Human Trafficking Institute. All rights reserved.
//
import Firebase
import FirebaseDatabase

class FirebaseService : NSObject {
    var ref: FIRDatabaseReference!
    var table: FirebaseTable?
    
    override init() {
        super.init()
        
        ref = FIRDatabase.database().reference()
    }
    
    init(table: FirebaseTable) {
        super.init()
        ref = FIRDatabase.database().reference()
        self.table = table
    }
    
    func enterData(forIdentifier identifier: String, data: FIRDataObject) {
        if let table = table {
            self.ref.child(table.rawValue).child(identifier).setValue(data.toDictionary())
        } else {
            print("Unable to enter data. Desired table not set.")
        }
    }
    
    func deleteData(forIdentifier identifier: String) {
        if let table = table {
            self.ref.child(table.rawValue).child(identifier).removeValue()
        } else {
            print("Unable to remove data. Desired table is not set.")
        }
    }
    
    func retrieveData(forIdentifier identifier: String, callback: @escaping ((FIRDataObject) -> Void)) {
        if let table = table {
            ref.child(table.rawValue).child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
                let data = self.convertSnapshot(snapshot: snapshot)
                callback(data)
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            print("Unable to retrieve data. Desired table not set")
        }
        
    }
    
    func retrieveAll(callback: @escaping (([FIRDataObject]) -> Void)) {
        if let table = table {
            ref.child(table.rawValue).observeSingleEvent(of: .value, with: {
                (snapshot) in
                var result : [FIRDataObject] = [FIRDataObject]()
                for child in snapshot.children {
                    result.append(self.convertSnapshot(snapshot: child as! FIRDataSnapshot))
                }
                callback(result)
            })
        }
    }
    
    func getKey() -> String {
        let key = ref.child((table?.rawValue)!).childByAutoId().key
        
        return key
    }
    
    private func convertSnapshot(snapshot: FIRDataSnapshot) -> FIRDataObject {
        switch table! {
        case FirebaseTable.users :
            let user = User(snapshot: snapshot)
            return user
        case FirebaseTable.reports :
            let report = Report(snapshot: snapshot)
            report.identifier = snapshot.key
            return report
        case FirebaseTable.purityReports :
            let purity = PurityReport(snapshot: snapshot)
            purity.identifier = snapshot.key
            return purity
        case FirebaseTable.sourceReports :
            let source = SourceReport(snapshot: snapshot)
            source.identifier = snapshot.key
            return source
        }
    }
    
}

enum FirebaseTable : String {
    case users = "users"
    case reports = "reports"
    case purityReports = "purityReports"
    case sourceReports = "sourceReports"
}
