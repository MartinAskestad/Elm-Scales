const gulp = require('gulp');
const concat = require('gulp-concat');
const elm = require('gulp-elm');
const inject = require('gulp-inject');
const minifyCss = require('gulp-minify-css');
const minifyHtml = require('gulp-htmlmin');
const uglify = require('gulp-uglify');
const ghPages = require('gulp-gh-pages');

gulp.task('elm', () => {
    return gulp.src('src/main.elm', { optimize: true })
        .pipe(elm())
        // .pipe(uglify())
        .pipe(gulp.dest('dist/'));
});

gulp.task('css', () => {
    return gulp.src(['node_modules/purecss/build/base.css', 'node_modules/purecss/build/forms.css', 'node_modules/purecss/build/grids.css'])
        .pipe(concat('style.css'))
        .pipe(minifyCss())
        .pipe(gulp.dest('dist/'));
})

gulp.task('html',['elm', 'css'], () => {
    const target = gulp.src('src/index.html');
    const sources = gulp.src(['./dist/*.js', './dist/*.css'], { read: false });
    return target
        .pipe(inject(sources, { ignorePath: '/dist' }))
        .pipe(minifyHtml({collapseWhitespace: true, removeComments: true }))
        .pipe(gulp.dest('./dist'));
});



gulp.task('gh-pages', () => {
    return gulp.src('./dist/**/*')
        .pipe(ghPages());    
});

gulp.task('default', ['html']);