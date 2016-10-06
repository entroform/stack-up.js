// variables
var jsBuildName = 'stack-up.js';

var coffeeSourcePath = 'assets/coffee/';
var coffeeSources = [
  'num',
  'utils',
];

function coffeeSourcesArray() {
  return coffeeSources.map(function(coffee) {
    return coffeeSourcePath + coffee + '.coffee';
  });
}

// Gulp object declarations.
var gulp = require('gulp');

var coffee = require('gulp-coffee');
var coffeeConfig = {
  bare: true
};

var concat = require('gulp-concat');

var sass = require('gulp-sass');
var sassConfig = {
  outputStyle: 'compressed'
};

var uglify = require('gulp-uglify');
var uglifyConfig = {
  preserveComments: 'license'
};

var util = require('gulp-util');

// Gulp tasks.
gulp.task('default', function() {});

gulp.task('coffee', function() {
  gulp.src(coffeeSourcesArray())
    .pipe(coffee(coffeeConfig).on('error', util.log))
    .pipe(concat(jsBuildName).on('error', util.log))
    .pipe(uglify(uglifyConfig).on('error', util.log))
    .pipe(gulp.dest('build/assets/js'));
});

gulp.task('sass', function() {
  gulp.src('assets/sass/**/*.sass')
    .pipe(sass(sassConfig).on('error', util.log))
    .pipe(gulp.dest('build/assets/css'));
});

gulp.task('watch', function() {
  gulp.watch('assets/sass/**/*.sass', ['sass']);
  gulp.watch(coffeeSourcesArray(), ['coffee']);
});