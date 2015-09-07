#!/usr/bin/env bash

# PEAR packages
if [ ! -d /usr/share/pear/Mail ]; then
  pear install Mail-1.2.0
  pear install Mail_Mime-1.8.9
  pear install Mail_mimeDecode-1.5.5
fi

if [ ! -d /usr/share/pear/Spreadsheet ]; then
  pear install OLE-1.0.0RC2
  pear install Spreadsheet_Excel_Writer-0.9.3
fi