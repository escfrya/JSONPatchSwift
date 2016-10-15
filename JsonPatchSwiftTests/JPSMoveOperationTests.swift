//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// http://tools.ietf.org/html/rfc6902#section-4.4
// 4.  Operations
// 4.4.  move
class JPSMoveOperationTests: XCTestCase {
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.6
    func testIfMoveValueInObjectReturnsExpectedValue() {
        let json = JSON(data: "{ \"foo\": { \"bar\": \"baz\", \"waldo\": \"fred\" }, \"qux\":{ \"corge\": \"grault\" } }".dataUsingEncoding(String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/qux/thud\", \"from\": \"/foo/waldo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\": { \"bar\": \"baz\" }, \"qux\": { \"corge\": \"grault\",\"thud\": \"fred\" } }".dataUsingEncoding(String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.7
    func testIfMoveIndizesInArrayReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : [\"all\", \"grass\", \"cows\", \"eat\"]} ".dataUsingEncoding(String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/foo/3\", \"from\": \"/foo/1\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : [\"all\", \"cows\", \"eat\", \"grass\"]} ".dataUsingEncoding(String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveOperationReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".dataUsingEncoding(String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/bar/1\", \"from\": \"/foo/1\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"foo\" : {  }, \"bar\" : { \"1\" : 2 }}".dataUsingEncoding(String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveToRootReplacesDocument() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".dataUsingEncoding(String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"move\", \"path\": \"\", \"from\": \"/foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"1\" : 2 }".dataUsingEncoding(String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfMissingParameterReturnsError() {
        do {
            let result = try JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/bar\"}") // 'from' parameter missing
            XCTFail(result.operations.last!.value.rawString()!)
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.InvalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
}
