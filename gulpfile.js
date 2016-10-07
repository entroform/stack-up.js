var license = "// licensed under the MIT license - http://opensource.org/licenses/MIT \n// copyright (C) 2016 Andrew Prasetya \n// version: Thu 6 Oct 12:44:15 2016\n"

// gulp object declarations
var gulp = require('gulp');

var coffee = require('gulp-coffee');
var coffeeConfig = {
  bare: true
};

var concat = require('gulp-concat');

var header = require('gulp-header');

var sass = require('gulp-sass');
var sassConfig = {
  outputStyle: 'compressed'
};

var uglify = require('gulp-uglify');
var uglifyConfig = {
  preserveComments: 'license'
};

var util = require('gulp-util');

// gulp tasks
gulp.task('default', function() {});

gulp.task('coffee', function() {
  gulp.src('./*.coffee')
    .pipe(coffee(coffeeConfig).on('error', util.log))
    .pipe(uglify(uglifyConfig).on('error', util.log))
    .pipe(header(license).on('error', util.log))
    .pipe(gulp.dest('./'));
});

gulp.task('sass', function() {
  gulp.src('example/sass/*.sass')
    .pipe(sass(sassConfig).on('error', util.log))
    .pipe(gulp.dest('example/css'));
});

gulp.task('watch', function() {
  gulp.watch('example/sass/*.sass', ['sass']);
  gulp.watch('./*.coffee', ['coffee']);
});