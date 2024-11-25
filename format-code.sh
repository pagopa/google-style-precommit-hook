#!/usr/bin/env sh

# Directory cache
mkdir -p .cache
cd .cache

# Scarica l'ultima versione del jar
if [ ! -f google-java-format.jar ]; then
    echo "Downloading the latest google-java-format jar..."
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/google/google-java-format/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    JAR_URL="https://github.com/google/google-java-format/releases/download/${LATEST_RELEASE}/google-java-format-${LATEST_RELEASE#v}-all-deps.jar"
    curl -LJO "$JAR_URL"
    mv "google-java-format-${LATEST_RELEASE#v}-all-deps.jar" google-java-format.jar
    chmod 755 google-java-format.jar
fi
cd ..

# Trova i file .java modificati
changed_java_files=$(git diff --cached --name-only --diff-filter=ACMR | grep ".*java$")
echo $changed_java_files

# Applica il formattatore ai file modificati
if [ -n "$changed_java_files" ]; then
    java -jar .cache/google-java-format.jar --replace $changed_java_files
else
    echo "No changed Java files to format."
fi
