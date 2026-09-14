import argparse
import json
import requests


parser = argparse.ArgumentParser()
parser.add_argument("url", metavar="url", type=str)
arg = parser.parse_args()

url: str = arg.url

response: requests.models.Response = requests.get(url)

# response: requests.models.Response = requests.get(
#     "https://wallhaven.cc/api/v1/search?q=nature&page=1"
# )

loadout: dict = json.loads(response.text)
data: list[dict] = loadout["data"]
last_page: list[dict] = loadout["meta"]["last_page"]


element: dict
output: list[str] = [
    element["thumbs"]["large"] + "|" + element["path"] for element in data
]

print("||".join(output) + "|||" + str(last_page), end="")
