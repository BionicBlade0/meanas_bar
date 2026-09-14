import requests

response: requests.models.Response = requests.get(
    "https://wttr.in/30.532295,-97.870949?u&format=1"
)
response.encoding = "utf-8"

if response.text[-3:-1] == "°F":
    print(response.text[:-1], end="")
