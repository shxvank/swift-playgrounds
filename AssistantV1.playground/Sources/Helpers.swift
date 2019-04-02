
import AssistantV1

var assistant: Assistant = {
    let version = "2018-10-15"
    let apiKey = WatsonCredentials.AssistantV1APIKey

    let assistant = Assistant(version: version, apiKey: apiKey)

    // Set the URL for the service endpoint if needed
    if let serviceURL = WatsonCredentials.AssistantV1URL {
        assistant.serviceURL = serviceURL
    }

    return assistant
}()

public func setupAssistantV1() -> Assistant {
    return assistant
}

// Find or create a readWrite workspace
public func getWorkspaceID() -> String {
    var workspaceID: String?
    assistant.listWorkspaces() {
        response, error in

        guard let result = response?.result else {
            assertionFailure(error?.localizedDescription ?? "unexpected error")
            return
        }

        workspaceID = result.workspaces.first?.workspaceID
        if workspaceID == nil {
            assistant.createWorkspace(name: "my_environment", description: "My environment") {
                response, error in

                guard let workspace = response?.result else {
                    assertionFailure(error?.localizedDescription ?? "unexpected error")
                    return
                }

                workspaceID = workspace.workspaceID
            }
        }
    }

    while workspaceID == nil { sleep(1) }
    return workspaceID!
}

let sampleIntent = "hello"

public func createSampleIntent(workspaceID: String) {
    var created = false
    assistant.getIntent(workspaceID: workspaceID, intent: sampleIntent) {
        _, error in

        if let error = error {
            if case let .http(statusCode, _, _) = error, statusCode == 404 {
                // Not Found -- fall through to creation
            } else {
                print(error.localizedDescription)
                return
            }

            assistant.createIntent(
                workspaceID: workspaceID,
                intent: sampleIntent,
                examples: [
                    Example(text: "Good afternoon"),
                    Example(text: "Hi there")
                ])
            {
                _, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                created = true
            }
        }

        created = true
    }
    while !created { sleep(1) }
    return
}

public func deleteSampleIntent(workspaceID: String) {
    assistant.deleteIntent(workspaceID: workspaceID, intent: sampleIntent) {
        _, error in

        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
}

let sampleEntity = "beverage"

public func createSampleEntity(workspaceID: String) {
    var created = false
    assistant.getEntity(workspaceID: workspaceID, entity: sampleEntity) {
        _, error in

        if let error = error {
            if case let .http(statusCode, _, _) = error, statusCode == 404 {
                // Not Found -- fall through to creation
            } else {
                print(error.localizedDescription)
                return
            }

            assistant.createEntity(
                workspaceID: workspaceID,
                entity: sampleEntity,
                values: [
                    CreateValue(value: "water"),
                    CreateValue(value: "orange juice"),
                    CreateValue(value: "soda")
                ])
            {
                _, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }

                created = true
            }
        }

        created = true
    }
    while !created { sleep(1) }
    return
}

public func deleteSampleEntity(workspaceID: String) {
    assistant.deleteEntity(workspaceID: workspaceID, entity: sampleEntity) {
        _, error in

        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
}

public var encoder: JSONEncoder {
    let encoder = JSONEncoder()
    do {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        encoder.dateEncodingStrategy = .formatted(formatter)
    }
    encoder.outputFormatting = .prettyPrinted
    return encoder
}

func prettyPrint<T : Encodable>(object: T) -> String? {
    do {
        let data = try encoder.encode(object)
        return String(data: data, encoding: .utf8)
    } catch _ {
        return nil
    }
}

extension MessageResponse: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Workspaces

extension WorkspaceCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Workspace: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Intents

extension IntentCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Intent: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Examples

extension ExampleCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Example: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Counterexamples

extension CounterexampleCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Counterexample: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Entities

extension EntityCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Entity: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Mentions

extension EntityMentionCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Values

extension ValueCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Value: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Synonyms

extension SynonymCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension Synonym: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Dialog nodes

extension DialogNodeCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

extension DialogNode: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}

// Logs

extension LogCollection: CustomStringConvertible {
    public var description: String {
        return prettyPrint(object: self) ?? "broke"
    }
}
