#!/bin/bash

docker run -i aic.dslcc bash scripts/compile.sh >/dev/null 2>&1 <<EOT
Feature: "Best feature ever"
   Scenario: "Best scenario ever"
      Set sensor TYPE_LIGHT at 42
      Take a screenshot
   End

   Scenario: "Worst scenario ever"
      Set battery level at 1
   End
End
EOT

if [ $? -eq 0 ]; then
    echo Test passsed
else
    echo Test failed
fi

