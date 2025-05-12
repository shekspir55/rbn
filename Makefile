pull:
	git pull

# commit changes should contain the changed file names	
push:
	git add .
	git commit -m "update the code $(shell git log -1 --pretty=%h)"
	git push

.ONESHELL:
new:
	@read -p "Enter the new post title: " title; \
	title_dash=$$(echo $$title | sed 's/ /-/g'); \
	hugo new content posts/$$title_dash.md
	# make the draft be false
	sed -i 's/draft: true/draft: false/g' content/posts/$$title_dash.md

