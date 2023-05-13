# Dependencies:
# 	- sudo dnf install uglify-js ImageMagick
# 	- pip install --user htmlmin cssmin

.PHONY: copy_files minify_all optimize_images

all: copy_files minify_all optimize_images 

define remove_files
    @rm -fv $(1) | tr -d \' | sed 's/^removed/ RM/'
endef

define copy_files
    @cp -f -v $(1) $(2) $(3) | tr -d \' | sed 's/^/ CP /'
endef


###############################################################################
#### FILE COPY ################################################################
###############################################################################

copy_files:
	$(call copy_files, favicon.ico, html/)
	$(call copy_files, -r, css, html/)
	$(call copy_files, -r, js, html/)
	$(call copy_files, -r, images, html/)
	$(call copy_files, -r, img, html/)

###############################################################################
#### MINIFICATION #############################################################
###############################################################################

.PHONY: uglify_js minify_html minify_css

minify_all: uglify_js minify_html minify_css

uglify_js: js/site.js
	$(call remove_files, html/$<)
	@echo "UGL $< -> ${<:.js=.min.js}"
	@uglifyjs $< -o html/${<:.js=.min.js} --compress --mangle --validate --warn

minify_css: css/style.css
	$(call remove_files, html/$<)
	@echo "MIN $< -> ${<:.css=.min.css}"
	@cssmin < $< > html/${<:.css=.min.css}

minify_html:
minify_html: index-fr.html index-en.html
	@echo "MIN index.html -> html/fr/index.html"
	@htmlmin --remove-empty-space --remove-comments index.html html/index.html

	@echo "MIN index-fr.html -> html/fr/index.html"
	@htmlmin --remove-empty-space --remove-comments index-fr.html html/fr/index.html

	@echo "MIN index-en.html -> html/en/index.html"
	@htmlmin --remove-empty-space --remove-comments index-en.html html/en/index.html


###############################################################################
#### IMAGE COMPRESSION ########################################################
###############################################################################

optimize_images:
	@find html/images -print -type f -exec mogrify -quality 40% '{}' \; | sed 's/^/OPT /'
