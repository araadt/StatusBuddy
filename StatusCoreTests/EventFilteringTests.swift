import XCTest
@testable import StatusCore

final class EventFilteringTests: XCTestCase {

    func testFilteringRecentDeveloperEvents() throws {
        let response = try StatusResponse.developerOneResolvedIssue()
        
        XCTAssertEqual(response.services.filter({ $0.hasRecentEvents }).count, 1)
        XCTAssertEqual(response.services.filter({ $0.hasActiveEvents }).count, 0)
    }
    
    func testFilteringRecentConsumerEvents() throws {
        let response = try StatusResponse.customerThreeResolvedIssues()
        
        XCTAssertEqual(response.services.filter({ $0.hasRecentEvents }).count, 3)
        XCTAssertEqual(response.services.filter({ $0.hasActiveEvents }).count, 0)
    }
    
    func testFilteringMostRecentConsumerEvent() throws {
        let response = try StatusResponse.customerThreeResolvedIssues()
        let targetService = response.services.first(where: { $0.serviceName == "Apple Business Manager" })!
        
        XCTAssertEqual(targetService.latestEvent?.message, "Apple Business Manager was temporarily unavailable during system maintenance.")
    }
    
    func testFilteringActiveConsumerEvents() throws {
        let response = try StatusResponse.customerOneOngoingIssue()
        
        XCTAssertEqual(response.services.filter(\.hasActiveEvents).count, 1)
        XCTAssertEqual(response.services.filter(\.hasActiveEvents).first?.latestEvent?.message, "Users may be experiencing intermittent issues with this service.")
    }
    
    func testFilteringActiveDeveloperEvents() throws {
        let response = try StatusResponse.developerOneOngoingIssue()
        
        XCTAssertEqual(response.services.filter(\.hasActiveEvents).count, 1)
        XCTAssertEqual(response.services.filter(\.hasActiveEvents).first?.latestEvent?.message, "Due to maintenance, some services are unavailable.")
    }
}
