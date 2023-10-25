# Default port value
PORT ?= 8123

install:
	@bundle install

serve:
	@bundle exec jekyll serve --port $(PORT)
