#!/bin/sh

curl -X POST http://localhost:8080/userinfo -H 'Content-Type: application/json' -d '{"PushToken":"poop", "Address": "lotus_16PSJMzCdB851yS4m59RUG5CKfjhJxTSWBo8EK1os", "Longitude": 100, "Latitude": 100}'