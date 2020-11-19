#!/bin/bash

# Run xslt on all page files
for f in *.page; do
    xsltproc stripSeq.xslt "$f" | xsltproc tei2jsonl.xslt - > "json/${f%.page}.jsonl"
done
