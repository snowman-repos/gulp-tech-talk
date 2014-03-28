# This does the same as the gulp file except:
# 	- it doesn't report the size of the files after optimisation, because:
# 		* the cssmin and uglify plugins don't include this
# 		* it would require using ANOTHER plugin to run ANOTHER task on the specific main.min.* files after the other tasks have run
# 	- livereload works (I just haven't figured out how to do it in gulp yet... but it should be doable)

module.exports = (grunt) ->

	grunt.initConfig

		# Project settings
		config:
			# configurable paths
			src: "src"
			dist: "public"
			tmp: ".tmp"

		clean:
			distandtmp:
				files: [
					dot: true
					src: [".tmp", "<%= config.dist %>/*"]
				]

		# compile jade to HTML
		# and place in public folder
		jade:
			compile:
				expand: true
				cwd: "<%= config.src%>/jade"
				src: "*.jade"
				dest: "<%= config.dist%>"
				ext: ".html"
			options:
				pretty: true
				data:
					title: "Grunt Example"
					text: "I guess grunt is ok..."

		# compile stylus to CSS
		# and place in temporary folder
		stylus:
			compile:
				expand: true
				cwd: "<%= config.src%>/stylus"
				src: "main.styl"
				dest: "<%= config.tmp%>"
				ext: ".css"

		# compile coffeescript to javascript
		# and place in temporary folder
		coffee:
			compile:
				expand: true
				cwd: "<%= config.src%>/coffeescript"
				src: "**/*.coffee"
				dest: "<%= config.tmp%>"
				ext: ".js"
				options:
					join: true
					preserve_dirs: true
					bare: true

		# concatonate compiled CSS and JS
		# NOTE: you have to remember what files you're
		# working with here, we're not done with them yet...
		concat:
			css:
				src: ["<%= config.tmp%>/*.css"]
				dest: "<%= config.tmp%>/styles/main.css"
			js:
				src: ["<%= config.tmp%>/*.js"]
				dest: "<%= config.tmp%>/scripts/main.js"

		# minify CSS
		# and now we can finally move it to the public folder
		# we also stick a banner in the file here to show the date it was generated
		cssmin:
			minify:
				expand: true
				cwd: "<%= config.tmp%>/styles"
				src: "main.css"
				dest: "<%= config.dist%>/styles"
				ext: ".min.css"
			options:
				banner: "/*" + new Date() + "*/"

		# minify JS
		# and now we can finally move it to the public folder
		# we also stick a banner in the file here to show the date it was generated
		uglify:
			minify:
				expand: true
				cwd: "<%= config.tmp%>/scripts"
				src: "main.js"
				dest: "<%= config.dist%>/scripts"
				ext: ".min.js"
			options:
				banner: "/*" + new Date() + "*/"

		# if ANY of these files change,
		# run ALL of these tasks (in order)...
		# this task also runs a livereload server
		watch:
			files: [
				"<%= config.src%>/stylus/**/*.styl"
				"<%= config.src%>/coffeescript/**/*.coffee"
				"<%= config.src%>/jade/**/*.jade"
			]
			tasks: [
				"jade"
				"stylus"
				"coffee"
				"concat"
				"cssmin"
				"uglify"
			]
			options:
				livereload: true

		# run a development server
		# and inject livereload script into the pages being served
		connect:
			server:
				options:
					port: 8080
					base: "<%= config.dist%>"
					keepalive: true

		# because 'watch' and 'connect' both hog the thread,
		# we need this hack to make them both run at the same time
		# (gulp doesn't need this)
		concurrent:
			serveandwatch: ["connect", "watch"]


	# initialise plugins
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-jade"
	grunt.loadNpmTasks "grunt-contrib-stylus"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-concat"
	grunt.loadNpmTasks "grunt-contrib-cssmin"
	grunt.loadNpmTasks "grunt-contrib-uglify"
	grunt.loadNpmTasks "grunt-contrib-connect"
	grunt.loadNpmTasks "grunt-concurrent"

	# Run 'watch' task when you run `grunt`
	grunt.registerTask "default", ["clean","jade", "stylus", "coffee", "concat", "cssmin", "uglify", "concurrent"]
	
	grunt.registerTask "reset", ["clean"]

	# Log everything that 'watch' does
	grunt.event.on "watch", (action, filepath) ->
		grunt.log.writeln filepath + " has " + action