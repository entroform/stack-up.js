/**
 * Created by tommyZZM on 2015/6/9.
 */
var gulp = require("gulp");
var coffee = require("gulp-coffee");
var uglify = require("gulp-uglify");
var rename = require('gulp-rename');

gulp.task("default",["compile"],function(){
    gulp.watch("./stackgrid.adem.coffee",["compile"])
});

gulp.task("compile",function(){
    gulp.src("./stackgrid.adem.coffee")
        .pipe(coffee({bare: true}).on('error', console.log))
        .pipe(gulp.dest('./'))
        .pipe(uglify())
        .pipe(rename({
            suffix: '.min'
        }))
        .pipe(gulp.dest('./'));

    gulp.src("./example/js/example.coffee")
        .pipe(coffee({bare: true}).on('error', console.log))
        .pipe(gulp.dest('./example/js'));
});