pull:
	git pull

# commit changes should contain the changed file names	
commit-and-push:
	git add .
	git commit -m "update the code $(shell git status -s)"
	git push

.ONESHELL:
new:
	@read -p "Enter the new post title: " title; \
	title_dash=$$(echo $$title | sed 's/ /-/g'); \
	hugo new content posts/$$title_dash.md
	# make the draft be false
	sed -i 's/draft: true/draft: false/g' content/posts/$$title_dash.md

