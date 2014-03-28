# This does everything you want it to, except livereload isn't working yet (haven't had time to look into it, but it should be doable)

gulp		= require "gulp"
gutil		= require "gulp-util"
jade		= require "gulp-jade"
stylus		= require "gulp-stylus"
coffee		= require "gulp-coffee"
uglify		= require "gulp-uglify"
rename		= require "gulp-rename"
open		= require "open"
clean		= require "gulp-clean"
watch		= require "gulp-watch"
changed		= require "gulp-changed"
prefix		= require "gulp-autoprefixer"
header		= require "gulp-header"
concat		= require "gulp-concat"
size		= require "gulp-size"

express		= require "express"
path		= require "path"
lr			= require("tiny-lr")()

Config =
	port: 8080
	livereloadport: 35729
	src: "./src"
	dist: "./public"

gulp.task "reset", ->
	gulp.src Config.dist + "/*", read: false # get everything inside the build folder
		.pipe clean # "clean" those files (in the Nazi sense of the word...)
			force: true

gulp.task "jade", ->
	gulp.src Config.src + "/jade/index.jade" # get the main jade file (any imports will be included at compile time)
		.pipe jade # compile it
			pretty: true
			data:
				title: "Gulp Example"
				text: "welcome to a better workflow"
		.pipe gulp.dest Config.dist # put it in the public folder

gulp.task "stylus", ->
	gulp.src Config.src + "/stylus/main.styl" # get the main stylus file (any includes will be included at compile time)
		.pipe stylus # compile it
			set: ["compress"]
			# use: "nib"
		.pipe prefix "last 1 version", "> 1%", "ie 8", "ie 7" # add vendor prefixes
		.pipe rename "main.min.css" # rename the file
		.pipe header "/* " + new Date() + " */" # include a header showing the date the file was generated
		.pipe size # see how big the resulting file is
			showFiles: true
		.pipe gulp.dest Config.dist + "/styles" # ...and put it in its place

gulp.task "coffeescript", ->
	gulp.src Config.src + "/coffeescript/**/*.coffee" # get all coffeescript files
		.pipe coffee # compile them
			bare: true
		.pipe concat "main.js" # concatonate them into a single file (you'll want to use something like browserify or requireJS if the order matters to you)
		.pipe uglify # compress the file
			mangle: false
		.pipe rename "main.min.js" # rename it
		.pipe header "/* " + new Date() + " */" # include a header showing the date the file was generated
		.pipe size # see how big the resulting file is
			showFiles: true
		.pipe gulp.dest Config.dist + "/scripts" # and put it in the public/scripts folder

gulp.task "watch", ["jade", "stylus", "coffeescript"], ->

	gulp.watch Config.src + "/jade/**/*.jade", ["jade"]
	gulp.watch Config.src + "/stylus/**/*.styl", ["stylus"]
	gulp.watch Config.src + "/coffeescript/**/*.coffee", ["coffeescript"]

	gulp.watch Config.dist + "/*.html", notifyLivereload
	gulp.watch Config.dist + "/styles/main.min.css", notifyLivereload
	gulp.watch Config.dist + "/scripts/main.min.js", notifyLivereload

gulp.task "server", ->
	app = express()
	app.use require("connect-livereload")()
	app.use express.static(Config.dist)
	app.listen Config.port
	lr.listen Config.livereloadport
	gutil.log gutil.colors.yellow("Server listening on port " + Config.port)
	gutil.log gutil.colors.yellow("Livereload listening on port " + Config.livereloadport)

notifyLivereload = (event) ->

	fileName = "/" + path.relative Config.dist, event.path
	gulp.src event.path, read: false
		.pipe require("gulp-livereload")(lr)
	gutil.log gutil.colors.yellow("Reloading " + fileName)


gulp.task "default", ["reset", "watch", "server"]