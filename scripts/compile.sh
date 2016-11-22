#!/bin/bash

set -e

cat /dev/fd/0 > /home/developer/com.zenika.aicdsl/DslFiles/test.aic
gradle generateJavaFile
[ -f /home/developer/com.zenika.aicdsl/DslFiles/Testing.java ] || exit 10

