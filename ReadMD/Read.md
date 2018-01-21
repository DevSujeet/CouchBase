//to test out the app with sync gate way in walrus config.

{
  "interface":":4984",
  "log": ["HTTP", "Auth"],
  "databases": {
    "ask": {
      "server": "walrus:",
      "users": {
        "GUEST": {"disabled": false, "admin_channels": ["*"] }
      }
    },

    "track": {
      "server": "walrus:",
      "users": {
        "GUEST": {"disabled": false, "admin_channels": ["*"] }
      }
    },

    "alert": {
      "server": "walrus:",
      "users": {
        "GUEST": {"disabled": false, "admin_channels": ["*"] }
      }
    }

  }
}

////--------------sample data--- to insert in sync gateway.
curl -s -g  -vX PUT -H 'Content-Type: application/json' -d '{"name": "Test","owner": "usertest","type": "ask", "email": "sujeet@gmail.com"}' http://127.0.0.1:4984/ask/UUID1
curl -s -g  -vX PUT -H 'Content-Type: application/json' -d '{"name": "Test","owner": "usertest","type": "ask", "email": "sujeet@gmail.com"}' http://127.0.0.1:4984/track/UUID1
curl -s -g  -vX PUT -H 'Content-Type: application/json' -d '{"name": "Test","owner": "usertest","type": "ask", "email": "sujeet@gmail.com"}' http://127.0.0.1:4984/alert/UUID1


