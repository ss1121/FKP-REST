fs = require 'fs'
path = require 'path'
gulp = require 'gulp'
gutil = require 'gulp-util'
config = require '../configs/config.coffee'
browserSync = require 'browser-sync'
reload = browserSync.reload

# var exec = require('child_process').execSync;
# var cmd = 'nohup node --harmony ../index.js dev &'
# exec(cmd);

module.exports = (gulp,$,slime,env)->
    mapJson =
        version: config.version
        name: "sipin-webstore"
        createdAt: (new Date()).toString()
        commonDependencies: {
            css: {}
            js: {}
        } ,
        dependencies: {
            css: {}
            js: {}
        }

    gulp.task 'map:jsdev',()->
        gulp.src [config.staticPath + '/dev/js/**/*.js','!'+config.jsDevPath+'/_common.js']
            .pipe $.size()
            .pipe $.map (file)->
                _fileparse = path.parse(file.path)
                _filename = _fileparse.base
                filename = _fileparse.name.replace('-','/')
                if(filename == "common" || filename == "ie")
                    mapJson['commonDependencies']['js'][filename] = _filename;
                else
                    mapJson['dependencies']['js'][filename] = _filename;
                return;


    gulp.task 'map:cssdev',['map:jsdev'],()->
        gulp.src [config.staticPath + '/dev/css/**/*.css']
            .pipe $.size()
            .pipe $.map (file)->
                _fileparse = path.parse(file.path)
                _filename = _fileparse.base
                filename = _fileparse.name.replace('-','/')
                if(filename == "common" || filename == "ie")
                    mapJson['commonDependencies']['css'][filename] = _filename;
                else
                    mapJson['dependencies']['css'][filename] = _filename;

                fs.writeFileSync( config.staticPath + '/dev/map.json', JSON.stringify(mapJson)) ;
                return;

    gulp.task 'rebuild:html',['html:build']

    return ()->
        gulp.start 'map:cssdev'
        if env == 'pro'
            gulp.start 'rebuild:html'
        else
            browserSync(
                port: 9000
                ui:
                    port: 9001
                server:
                    baseDir: [ config.htmlDevPath, config.staticPath + '/dev']
                    index: "demoindex.html"
                files: [ config.htmlDevPath + '/**/*.html', config.staticPath+ '/dev/**']
                logFileChanges: false
            )
            #css and sprite
            # if encounter 'Error: watch ENOSPC': if in linux you must do this : https://github.com/gulpjs/gulp/issues/217
            # means edit max_user_watches number
            gulp.watch [config.dirs.src + '/css/**/*.?(less|scss|css)',config.dirs.src + '/images/slice/*.png'], ['pagecss:dev']
            #js
            gulp.watch config.dirs.src + '/js/?(modules|pages|widgets|mixins)/**/*.?(coffee|js|jsx|cjsx|hbs|scss|css)', ['buildCommon:dev']
            #html
            gulp.watch config.dirs.src + '/html/**/*.*', ['html']
