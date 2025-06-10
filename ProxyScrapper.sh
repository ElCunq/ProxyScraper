#!/bin/bash

DB="proxy_database.json"
TMP="temp_proxy_list.txt"

# Proxy siteleri
SITES=(
  "https://api.proxyscrape.com/v2/?request=getproxies&protocol=http&timeout=5000&country=all&ssl=all&anonymity=all"
  "https://www.proxy-list.download/api/v1/get?type=http"
  "https://raw.githubusercontent.com/TheSpeedX/PROXY-List/master/http.txt"
  "https://free-proxy-list.net/"
  "https://www.sslproxies.org/"
  "https://spys.one/en/free-proxy-list/"
)

# 1. Proxy Scraper
scrape_proxies() {
  echo "Scraping proxies..."
  > "$TMP"
  for URL in "${SITES[@]}"; do
    curl -s "$URL" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]+' >> "$TMP"
  done
  sort -u "$TMP" > "$TMP.sorted"
  > "$DB"
  echo '{"proxies":[]}' > "$DB"
  while IFS= read -r line; do
    IP=$(echo $line | cut -d: -f1)
    PORT=$(echo $line | cut -d: -f2)
    jq --arg ip "$IP" --arg port "$PORT" \
      '.proxies += [{"ip":$ip, "port":$port, "protocol":"http", "last_checked":null, "working":null}]' \
      "$DB" > tmp.json && mv tmp.json "$DB"
  done < "$TMP.sorted"
  echo "Scraping completed. Total proxies: $(jq '.proxies | length' $DB)"
}

# 2. Proxy Controller
check_proxies() {
  echo "Checking proxies with Google..."
  NEW_JSON='{"proxies":[]}'
  for row in $(jq -c '.proxies[]' "$DB"); do
    IP=$(echo "$row" | jq -r .ip)
    PORT=$(echo "$row" | jq -r .port)
    PROXY="$IP:$PORT"
    if timeout 5 curl -s --proxy "$PROXY" https://www.google.com > /dev/null; then
      echo "✓ $PROXY"
      NEW_JSON=$(echo "$NEW_JSON" | jq --arg ip "$IP" --arg port "$PORT" \
        '.proxies += [{"ip":$ip, "port":$port, "protocol":"http", "last_checked":"'"$(date)"'", "working":true}]')
    else
      echo "✗ $PROXY"
    fi
  done
  echo "$NEW_JSON" > "$DB"
  echo "Validation complete. Working proxies: $(jq '[.proxies[] | select(.working==true)] | length' $DB)"
}

# 3. Proxy Updater
deduplicate_proxies() {
  echo "Removing duplicates..."
  jq '[.proxies[] | {ip, port, protocol, last_checked, working}] | unique' "$DB" > tmp.json && mv tmp.json "$DB"
  echo "Duplicates removed. Unique proxies: $(jq '.proxies | length' $DB)"
}


# Menü
while true; do
  echo -e "\n=== Proxy Manager Menu ==="
  echo "1. Proxy Scraper"
  echo "2. Proxy Controller"
  echo "3. Proxy Updater"
  echo "4. Exit"
  read -p "Seçiminiz: " choice
  case $choice in
    1) scrape_proxies ;;
    2) check_proxies ;;
    3) deduplicate_proxies ;;
    4) break ;;
    *) echo "Geçersiz seçim." ;;
  esac
done

