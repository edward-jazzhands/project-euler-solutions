[no-cd]
cleanup file:
	sed -i \
	-e 's|\$||g' \
	-e 's|\\to|->|g' \
	-e 's|\\dots|...|g' \
	-e 's|\\times|*|g' \
	-e 's|\\mathbf||g' \
	-e 's|{align}||g' \
	-e 's|\\begin||g' \
	-e 's|\\end||g' \
	-e 's|&amp;\\colon|:|g' \
	-e 's|<img[^>]*>|* see image *|g' \
	-e 's|<[^>]*>||g' \
	"{{file}}"

create puzzle_number:
	#!/usr/bin/env bash
	set -euxo pipefail
	# first we gotta extract the puzzle name
	puzzle_name=$(wget -qO- https://projecteuler.net/problem={{puzzle_number}} | grep -oP '(?<=<h2>).*?(?=</h2>)')
	puzzle_name_clean=$(echo "$puzzle_name" | tr '[:upper:] ' '[:lower:]_')
	mkdir -p "{{puzzle_number}}_$puzzle_name_clean"
	cd "{{puzzle_number}}_$puzzle_name_clean"
	echo "pwd:   $(pwd)"
	echo '"""' > {{puzzle_number}}.py
	wget -O - https://projecteuler.net/minimal={{puzzle_number}} >> {{puzzle_number}}.py && \
	echo '"""' >> {{puzzle_number}}.py
	# Extract and download any images (if any exist)
	if grep -q '<img src=' "{{puzzle_number}}.py"; then \
		grep -oP '(?<=<img src=")[^"]+?\.(png|gif|jpg|jpeg)' "{{puzzle_number}}.py" | \
		while read img_url; do \
			wget "https://projecteuler.net/$img_url"; \
		done; \
	fi
	just cleanup "{{puzzle_number}}.py"

