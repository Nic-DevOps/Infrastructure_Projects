# Explanation of Test Script Commands

This file explains key parts of the `curl_test.sh` script used to test the local HTTP server.

---

``` 
if curl -s --head "$URL" | grep "200 OK" > /dev/null; then
  echo "✅ Server is up and responding."
else
  echo "❌ Server is not responding as expected."
fi
````

This command checks if the server is up and responding.

- **`curl`** – Command-line tool to make HTTP requests. Find more information about curl [here](https://curl.se/docs/tooldocs.html)
- **`-s`** – Silent mode. Suppresses progress and error messages.
- **`--head`** – Fetches only the HTTP headers instead of the full content.
- **`"$URL"`** – The target URL to check, for this script it will be `http://localhost:8000`.
- This part alone would return headers like:
```
HTTP/1.0 200 OK
Content-Type: text/html
Content-Length: 123
```


`| grep "200 OK"`
- `|` – The pipe operator takes the output of the curl command and passes it to the next command.

- `grep "200 OK"` – Searches for the string "200 OK" in the headers.

- `"200 OK"` is the standard HTTP status code for success.

`> /dev/null`
- `>` – Redirects output.

- `/dev/null` – Is a special file that discards anything written to it (like a black hole). This hides the output of grep — we only care whether it found the text, not what it returned.

`if ...; then`
- This entire condition checks:
  - "Did curl get a 200 OK response?"
  - If yes, it proceeds with the code in the `then` block (e.g., echo "✅ Server is up").

The `fi` command marks the end of an if block in Bash.

