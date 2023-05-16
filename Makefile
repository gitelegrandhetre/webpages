# Dependencies:
# 	- sudo dnf install uglify-js ImageMagick
# 	- pip install --user htmlmin cssmin

all: icon js html css

define remove_files
    @rm -fv $(1) | tr -d \' | sed 's/^removed/ RM/'
endef

define copy_files
    @cp -f -v $(1) $(2) $(3) | tr -d \' | sed 's/^/ CP /'
endef


###############################################################################
#### FILE COPY ################################################################
###############################################################################
.PHONY:icon 
icon:
	$(call copy_files, favicon.ico, html/)
	$(call copy_files, sitemap.xml, html/)
	$(call copy_files, robots.txt, html/)


###############################################################################
#### MINIFICATION #############################################################
###############################################################################

.PHONY: all js html css

js: js/site.js
	$(call copy_files, -r, js, html/)
	$(call remove_files, html/$<)
	@echo "UGL $< -> ${<:.js=.min.js}"
	@uglifyjs $< -o html/${<:.js=.min.js} --compress --mangle --validate --warn

css: css/style.css
	$(call copy_files, -r, css, html/)
	$(call remove_files, html/$<)
	@echo "MIN $< -> ${<:.css=.min.css}"
	@cssmin < $< > html/${<:.css=.min.css}

html:
html: index-fr.html index-en.html
	@echo "MIN index.html -> html/index.html"
	@htmlmin --remove-empty-space --remove-comments index.html html/index.html

	@echo "MIN index-fr.html -> html/fr/index.html"
	@htmlmin --remove-empty-space --remove-comments index-fr.html html/fr/index.html

	@echo "MIN index-en.html -> html/en/index.html"
	@htmlmin --remove-empty-space --remove-comments index-en.html html/en/index.html


###############################################################################
#### IMAGE COMPRESSION ########################################################
###############################################################################

.PHONY: images
images:
	$(call copy_files, -r, images, html/)
	$(call copy_files, -r, img, html/)
	@find html/images -print -type f -exec mogrify -quality 40% '{}' \; | sed 's/^/OPT /'
