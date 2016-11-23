#!/bin/bash

# Any error must exit the script with a status code
set -e

cat /dev/fd/0 > /home/developer/com.zenika.aicdsl/DslFiles/test.aic

# XXX this never fails, check later
gradle generateJavaFile

# Did it create a file?
if [ ! -f /home/developer/com.zenika.aicdsl/DslFiles/Testing.java ]; then
   echo "ERROR: No Java file was generated"
   exit 10
fi

# Is there any test ?
if ! grep -q @Test /home/developer/com.zenika.aicdsl/DslFiles/Testing.java; then
    echo "ERROR: No @Test methods was generated"
    exit 20
fi

