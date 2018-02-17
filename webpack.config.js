const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextWebpackPlugin = require('extract-text-webpack-plugin');
const OptimizeCssAssetsWebpackPlugin = require('optimize-css-assets-webpack-plugin');

const resolve = relativepath => path.join(__dirname, relativepath);

const isProd = process.env.npm_lifecycle_event === 'build' ? true : false;

module.exports = {
    devtool: isProd ? 'none' : 'source-map',
    entry: resolve('src/bootstrap.js'),
    output: {
        path: resolve('dist'),
        filename: isProd ? '[hash].js' : 'scales.js'
    },
    resolve: {
        extensions: ['.js', '.elm']
    },
    module: {
        noParse: /\.elm$/,
        rules: [{
            test: /\.(eot|ttf|woff|woff2|svg)$/,
            loader: 'file-loader',
            options: {
                name(env) {
                    if (!isProd) {
                        return '[path][name].[ext]'
                    }
                    return '[hash].[ext]'
                }
            }
        },
        {
            test: /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            loader: 'elm-webpack-loader'
        },
        {
            test: /\.css$/,
            loader: ExtractTextWebpackPlugin.extract({
                fallback: 'style-loader',
                use: ['css-loader']
            })
        }]
    },
    plugins: [
        new ExtractTextWebpackPlugin({
            filename: isProd ? 'css/[hash].css' : 'css/[name].css',
            allChunks: true
        }),
        new HtmlWebpackPlugin({
            filename: 'index.html',
            inject: 'body',
            title: 'Elm-Scales'
        })
    ].concat(
        isProd ? [
            new webpack.optimize.UglifyJsPlugin({
                minimize: true,
                compressor: { warnings: true },
                mangle: true
            }),
            new OptimizeCssAssetsWebpackPlugin({
                cssProcessorOptions: {
                    discardComments: { removeAll: true }
                }
            })
        ] : []
    ),
    devServer: {
        historyApiFallback: true,
        contentBase: resolve('src'),
        hot: false
    }
};
