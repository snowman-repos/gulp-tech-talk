title: GulpJS - Profero Tech Talk
author:
  name: Darryl Snow
  email: darryl.snow@profero.com
output: index.html
style: presentation.css
controls: false

--

# Intro to GulpJS
## Profero Tech Talk
*Friday 28<sup>th</sup> March, 2014*

--

# ![Profero](profero-logo.png) + ![GulpJS](gulp-logo.png)

--

### What is a Task Runner?

> A configurable app to automate a set of predefined tasks, e.g.

* **Setting up** a new project, files &amp; directories
* Compiling Jade, Stylus, CoffeeScript (or their inferior equivalents)
* Concatonating &amp; minifying stylesheets, script files
* Inlining styles and scripts
* Bundling scripts with Browserify or RequireJS
* **Optimising** images
* Running a server (with livereload?)
* Generating a styleguide
* Generating icons from SVG Sprites (icon fonts are so yesterday...)
* Running unit **test**s
* Preparing **deployment** packages

--

### Task Runner Basics

* Codekit &amp; Hammer are GUI task runners, Grunt & Gulp run in the command line
* Codekit supports a limited set of tasks
* Grunt and Gulp use **plugins** to do different tasks:
	* 2,580 official Grunt plugins available _now_
	* 432 official Gulp plugins available _so far_
	* (Codekit can do about 20 different tasks)
* Anyone can write and publish plugins to accomplish different tasks at any time
* Grunt supported by the Google/Twitter/Yeoman/Angular team
* Gulp supported by Substack
* Codekit supported by a guy called Brian...

--

### Grunt

# ![Grunt](grunt-logo.png)

--

### Grunt

# ![Grunt is old](grunt-logo-old.png)

--

### Gruntfile.js (in project root)

	module.exports = function(grunt) {

		grunt.loadNpmTasks('grunt-contrib-watch');
		grunt.loadNpmTasks('grunt-contrib-stylus');

		grunt.initConfig({

			pkg: grunt.file.readJSON('package.json'),
			stylus: {
				compile: {
					expand: true,
					cwd: 'src/styles/',
					src: '**/*.styl',
					dest: 'public/styles/',
					ext: '.css'
				}
			},
			watch: {
				files: ["stylus/**/*.styl"],
				tasks: ["stylus"]
			}

		});
		
		grunt.registerTask('default', ['watch']);

	}

--

### What was wrong with that?

* Lots of complicated configuration
* Only really designed for small projects
* More files + more tasks = slooo0000ooow
* Tasks have to be run in a pre-defined sequence
* Plugins do multiple things... can be confusing

--

### Enter Gulp

# ![Gulp](gulp-logo.png)

--

### What's the same?

* Local install for each project
* Global command `grunt` or `gulp`
* Global command runs local project
* It's all plugins, no built-in tasks

--

### What's the difference?

* Stream-based build system (_think jQuery: $("#element").show().animate(...).hide()..._)
* Code over configuration
* Small, idiomatic Node modules
* Really simple, elegant API
* Gulp tasks run with maximum concurrency (not sequentially)
* No need for `.tmp` files or folders

--

### Pre-requisites

* NodeJS
* NPM
* Gulp
* Any plugins you want to use
* Command-line Fu

--

### Basic Gulpfile (in project root) - Streaming builds

	var gulp = require("gulp"),
		stylus = require("gulp-stylus");
		
	gulp.task("default", function() {
		
		return gulp.src("src/styles/*.styl") // <-- Read from FS
			.pipe(stylus()) // <-- do this to those files
			.pipe(gulp.dest("public/styles")); // <-- Write to FS
		
	});

--

### How to run it

	gulp taskname
	
or if you have defined a default task...

	gulp

--

### Want more? 
<small>_(Coffeescript is nicer :)_</small>

	date = new Date();

	gulp.src "src/**/*.styl" // <-- take these files
	
		// in-memory transforms:
		.pipe stylus()
		.pipe rename
			ext: "css"
		.pipe autoprefixer()
		.pipe cssmin()
		.pipe header("/* " + date.getDate() + date.getMonth() + date.getFullYear() + " */")
		.pipe gulp.dest("public/styles") // <-- put the result here

--

### The API - gulp.task

	gulp.task("name", ["deps"], function(done){
	
		return stream || promise;
		// ...or, call done()
	
	});

--

### The API - gulp.watch

	gulp.watch("src.ext", ["task1", "task2", ...]);

--

### The API - gulp.src

Returns a readable stream

	gulp.src(["src.ext", "src.ext",... ]);

--

### The API - gulp.dest

Returns a "through" stream

	gulp.src("src")
		.pipe(...)
		.pipe(gulp.dest("dist"));
		
Yes, that means you can keep piping! :)

--

### Workflow

* Install NodeJS
* Navigate to project folder
* Install Gulp globally (`sudo npm install -g gulp`)
* Install Gulp for your project (`npm install gulp --save-dev`)
* Find a Gulp plugin to do what you want ([http://gulpjs.com/plugins/](http://gulpjs.com/plugins/))
* ~~Learn the configuration style of that plugin~~
* Write your tasks into into `Gulpfile.js` (including one called "default")
* Task, watch, src, dest - **that's it**
* Run `gulp`

--

### Summary

* Gulp is more powerful &amp; versatile than GUI tools
* Gulp is new / bleeding edge - needs time to mature
* Gulp is easier to set up than Grunt
* Gulp is faster to use than Grunt
* Gulp keeps your workspace cleaner

--

### Further Reading & Resources

Check out the examples folder in this repo - there are both Grunt and Gulp implementations so you can compare - just navigate to each directory and run `grunt` or `gulp` to compile, or `grunt reset` or `gulp reset` to start over.

* [The Stream Handbook](https://github.com/substack/stream-handbook)
* [Gulp JS Plugins](http://gulpjs.com/plugins/)
* [Example Gulpfiles](https://github.com/search?q=gulpfile)
* [Gulp .NET Example](https://github.com/robrich/gulp_dotnet_example/blob/master/Gulpfile.js)

This presentation, including examples, is available on Github:
[https://github.com/darryl-snow/gulp-tech-talk](https://github.com/darryl-snow/gulp-tech-talk)

Any questions or problems, ask me.