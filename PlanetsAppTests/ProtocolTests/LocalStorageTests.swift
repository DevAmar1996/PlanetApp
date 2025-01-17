//
//  LocalStorageTests.swift
//  PlanetsApp
//
//  Created by Qamar Al Amassi on 17/01/2025.
//

import Testing

final actor LocalStorageTests {
    var mockLocalStorage: MockLocalStorage!

    init() {
        self.mockLocalStorage =  MockLocalStorage()
    }

    deinit {
        self.mockLocalStorage = nil
    }

    @Test func testSaveRetriveData_Sucess() async throws {
        //prapre the object to be saved
        let objectToSave = TestObject(id: 42, name: "Planet")
        let key = "testKey"

        do {
            //save the object
            try mockLocalStorage.saveObject(objectToSave, forKey: key)

            //retrive the object
            let object: TestObject? = try mockLocalStorage.retrieveObject(forKey: key, as: TestObject.self)

            #expect(objectToSave == object, "The saved and retrieved objects should match.")
        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }

    @Test func testRetrivalFail_NOData() async throws {
        let key = "notExistKey"
        do {
            //retrive the object
            let _: TestObject? = try mockLocalStorage.retrieveObject(forKey: key, as: TestObject.self)

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
            try mockLocalStorage.saveObject(invalidObject, forKey: key)
            #expect(Bool(false), "expected an error but not received one.")
        } catch OfflineError.failToSave {
            //object not found
            #expect(Bool(true), "fail to save")
        } catch {
            #expect(Bool(false), "Unexpecte error: \(error)")
        }
    }
}
