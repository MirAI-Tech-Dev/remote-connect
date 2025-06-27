#!/bin/bash

OPTS="--listings -c pandoc.css"

# html
# pandoc $OPTS -o NAME.html NAME.md

# pdf
pandoc $OPTS -o pdf/root_access.pdf root_access.md
pandoc $OPTS -o pdf/server_setup.pdf server_setup.md
pandoc $OPTS -o pdf/ssh_remote_connect.pdf ssh_remote_connect.md
