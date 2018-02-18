const gulp = require('gulp');
const webpack = require('webpack');
const webpackStream = require('webpack-stream');
const ghPages = require('gulp-gh-pages');

const webpackConfig = require('./webpack.config');

gulp.task('webpack', () => {
    return gulp.src('./src/bootstrap.js')
        .pipe(webpackStream(webpackConfig, webpack))
        .pipe(gulp.dest('./dist'));
});

gulp.task('gh-pages', () => {
    return gulp.src('./dist/**/*')
        .pipe(ghPages());    
});

gulp.task('default', ['webpack']);