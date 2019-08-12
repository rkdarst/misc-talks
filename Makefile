build:
	./venv3/bin/sphinx-build -M dirhtml . _build $(SPHINXOPTS)
clean:
	rm -r _build/*

venv3:
	test -d venv3 || python3 -m virtualenv -p python3 venv3
	venv3/bin/pip install sphinx sphinx_rtd_theme

SITE_DIR=www/
GITHUB_REPO=gh:rkdarst/misc-talks.git
GITHUB_BRANCH=gh-pages

deploy: copy gh-pages
copy:
	rsync -a --delete _build/dirhtml/ $(SITE_DIR)/

gh-pages:
        { cd $(SITE_DIR) && test ! -d .git && git clone $(GITHUB_REPO) tmp-git && mv tmp-git/.git . && rm -rf tmp-git ; } || true
	touch .nojekyll
	test -n "$(CNAME)" && echo $(CNAME) > $(SITE_DIR)/CNAME || true
	cd $(SITE_DIR) && git add .
	cd $(SITE_DIR) && git commit -a -m "deployment"
	cd $(SITE_DIR) && git push origin $(GITHUB_BRANCH)
