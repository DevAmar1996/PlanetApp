//
//  UserDefaultsLocalStorageTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing

final actor UserDefaultsLocalStorageTests {
    var localStorage: UserDefaultsLocalStorage!

    init() {
        self.localStorage = UserDefaultsLocalStorage()
    }

    deinit {
        self.localStorage = nil
    }

    @Test("Save key in local storage make sure it retrive successfully")
    func testSaveRetiveSuccess() async throws {
        //prepare testObject
        let testObject = TestObject(id: 28, name: "Planet")
        let key = "testKey"
        do {
            //save the object
            try localStorage.saveObject(testObject, forKey: key)

            //retrive the object
            let object: TestObject? = try localStorage.retrieveObject(forKey: key, as: TestObject.self)

            #expect(testObject == object, "The saved and retrieved objects should match.")
        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }

    @Test("test retrive unexisting key")
    func testFailRetrive_NotExistKey() async throws {
        let key = "notExistKey"
        do {
            //retrive the object
            let _: TestObject? = try localStorage.retrieveObject(forKey: key, as: TestObject.self)

            //object should not retrived
            #expect(Bool(false), "expected an error but not received one.")
        } catch OfflineError.noDataAvailable {
            //object not found
            #expect(Bool(true), "Data not available")
        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }

    @Test func testSaveObject_InvalidEncoding() {
        let invalidObject = InvalidObject(value: 42, invalidReference: "" as Any)

        let key = "invalidKey"

        do {
            //save the object
            try localStorage.saveObject(invalidObject, forKey: key)
            #expect(Bool(false), "expected an error but not received one.")
        } catch OfflineError.failToSave {
            //object not found
            #expect(Bool(true), "fail to save")
        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }
}
