class ChatbotService {
  // Mock database of user's tickets
  final Map<String, Map<String, dynamic>> _userTickets = {
    "Tech Conference 2025": {
      "eventName": "Tech Conference 2025",
      "qrCodeUrl": "https://api.qrserver.com/v1/create-qr-code/?data=TICKET123"
    },
    "Music Fest 2025": {
      "eventName": "Music Fest 2025",
      "qrCodeUrl": "https://api.qrserver.com/v1/create-qr-code/?data=TICKET456"
    }
  };

  // function the AI will learn to call for QR codes
  Future<Map<String, dynamic>> findQrCode({required String eventName}) async {
    if (_userTickets.containsKey(eventName)) {

      return {
        "responseType": "qr_code_display",
        "data": _userTickets[eventName]
      };
    } else {
      return {
        "responseType": "error",
        "data": {"message": "Sorry, I couldn't find a ticket for '$eventName'."}
      };
    }
  }

  // function for searching events
  Future<Map<String, dynamic>> searchEvents({
    String? date,
    String? location,
    String? category,
  }) async {

    return {
      "responseType": "event_card_display",
      "data": [
        {
          "eventName": "Future of AI Summit",
          "date": "2025-10-15",
          "location": "San Francisco, CA"
        },
        {
          "eventName": "Flutter Forward Extended",
          "date": "2025-11-01",
          "location": "Online"
        }
      ]
    };
  }
}