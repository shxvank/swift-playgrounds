//:## Sessions

import AssistantV2

let assistant = setupAssistantV2()
let assistantID = WatsonCredentials.AssistantV2ID

//:### Create a session

var sessionID = ""

assistant.createSession(assistantID: assistantID) {
    response, error in

    guard let session = response?.result else {
        print(error?.localizedDescription ?? "unknown error")
        return
    }

    sessionID = session.sessionID
    print(session)
}

//:### Delete session

assistant.deleteSession(assistantID: assistantID, sessionID: sessionID) {
    _, error in

    if let error = error {
        print(error.localizedDescription)
        return
    }

    print("session deleted")
}
