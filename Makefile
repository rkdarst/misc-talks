build:
	./venv3/bin/sphinx-build -M dirhtml . _build $(SPHINXOPTS)
clean:
	rm -r _build/*

venv3:
	test -d venv3 || python3 -m virtualenv -p python3 venv3
	venv3/bin/pip install -r requirements.txt

SITE_DIR=www/
GITHUB_REPO=gh:rkdarst/misc-talks.git
GITHUB_BRANCH=gh-pages
CNAME=
#GITHUB_FORCE=--amend

deploy: copy gh-pages
copy:
	rsync -a --delete --exclude=.git _build/dirhtml/ $(SITE_DIR)/

gh-pages:
	test -d $(SITE_DIR)/.git || { cd $(SITE_DIR) && git clone $(GITHUB_REPO) tmp-git && mv tmp-git/.git . && rm -rf tmp-git ; }
	test -d $(SITE_DIR)/.git
	touch $(SITE_DIR)/.nojekyll
	test -n "$(CNAME)" && echo $(CNAME) > $(SITE_DIR)/CNAME || rm -f $(SITE_DIR)/CNAME
	cd $(SITE_DIR) && git add .
	cd $(SITE_DIR) && git commit $(GITHUB_FORCE) -a -m "deployment" || true
	cd $(SITE_DIR) && git push origin -f HEAD:$(GITHUB_BRANCH)
