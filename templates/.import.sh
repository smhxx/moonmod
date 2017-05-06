#!/bin/bash

src="$1"
if [ "$src" == "dist/global.lua" ]; then
  echo "Importing $src..."
  if jq --slurpfile script <(jq -Rs . dist/global.lua) '.LuaScript=$script[0]' dist/save.json > dist/.save.json; then
    mv -f dist/.save.json dist/save.json
  else
    echo "Error: Malformatted save template, unable to find global LuaScript."
    rm dist/.save.json
  fi
else
  echo "Importing $src..."
  filename="$(basename $src)"
  guid="${filename%%.*}"
  matches="$(jq --arg guid "$guid" '.ObjectStates|map(select(.GUID==$guid))|length' dist/save.json 2> /dev/null)"
  if [[ "$matches" == "1" ]]; then
    jq --slurpfile script <(jq -Rs . "$src") --arg guid "$guid" '(.ObjectStates[]|select(.GUID==$guid)|.LuaScript)=$script[0]' dist/save.json > dist/.save.json
    mv -f dist/.save.json dist/save.json
  elif [[ "$matches" == "0" ]]; then
    echo "Warning: No matching object found for script with GUID $guid."
  elif [[ "$matches" =~ '^[0-9]+$' ]]; then
    echo "Warning: GUID $guid is non-unique. Is this object in a collection?"
  else
    echo "Error: Malformatted save template, unable to find ObjectStates array."
  fi
fi
