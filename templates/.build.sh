#!/bin/bash

echo "{ }" > "templates/.save.json"

function strip_quotes() {
  local r="${1%\"}"
  echo "${r#\"}"
}

for ((i=0; i<$(jq '.|length' "templates/manifest.json"); i++)); do
  value="$(jq ".[$i]" "templates/manifest.json")"
  type="$(jq '.|type' <(echo "$value"))"
  value="$(strip_quotes "$value")"
  if [ "$type" == "\"string\"" ]; then
    value="templates/$value"
    echo "Importing $value..."
    jq --slurpfile save "templates/.save.json" '[$save[],.]|add' "$value" > "templates/.temp.json"
    mv -f "templates/.temp.json" "templates/.save.json"
  elif [ "$type" == "\"object\"" ]; then
    name="$(jq '.as' <(echo "$value"))"
    name="$(strip_quotes "$name")"
    jq --arg name "$name" '[.,{($name|tostring):[]}]|add' ".save.json" > "templates/.temp.json"
    mv -f "templates/.temp.json" "templates/.save.json"
    echo "Building $name array..."
    for ((j=0; j<$(jq --arg i "$i" '.[($i|tonumber)].values|length' "templates/manifest.json"); j++)); do
      filename="$(jq --arg i "$i" --arg j "$j" '.[($i|tonumber)].values[($j|tonumber)]' "templates/manifest.json")"
      filename="templates/$(strip_quotes "$filename")"
      echo "  Importing $filename..."
      jq --slurpfile file "$filename" --arg name "$name" '($name|tostring) as $name|([.[$name],$file[]]|add) as $array|.[$name]=$array' "templates/.save.json" > templates/.temp.json
      mv -f "templates/.temp.json" "templates/.save.json"
    done
  fi
done
