#!/usr/bin/env python3

import urllib.parse
import urllib.request

input = []
for line in open("/srv/docker/postoffice/forwards.txt"):
    if not line.strip() or line.strip().startswith("#"):
        continue
    alias, dests = line.strip().split(None, 1)
    alias, host = alias.split("@", 1)
    if host != "sibr.dev":
        continue
    for dest in dests.split(","):
        input.append(f"{alias}:{dest}")

data = urllib.parse.urlencode({"input": ",".join(input)}).encode("ascii")
response = urllib.request.urlopen("https://api.forwardemail.net/v1/encrypt", data=data)
encrypted = response.read().decode("ascii")
chunks = ['"' + encrypted[i : i + 255] + '"' for i in range(0, len(encrypted), 255)]
print(f"@ 300 IN TXT {" ".join(chunks)}")
