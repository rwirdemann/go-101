#!/bin/bash
cp $HOME/Documents/presentations-offline/go101/PITCHME/assets/md/PITCHME.md .
sed -i '.org' 's|./assets/md/assets/|assets/|g' PITCHME.md
rm PITCHME.md.org