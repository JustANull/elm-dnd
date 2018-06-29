const path = require('path');
const webpack = require('webpack')

const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const HtmlPlugin = require('html-webpack-plugin')
const HtmlExcludeAssetsPlugin = require('html-webpack-exclude-assets-plugin')
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const RemoveSourcePlugin = require('remove-source-webpack-plugin')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')

module.exports = {
    entry: {
        app: './app/app.js',
        style: './app/style.css'
    },
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].js'
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    "css-loader"
                ]
            }
        ]
    },
    optimization: {
        concatenateModules: true,
        minimize: true,
        minimizer: [
            new UglifyJsPlugin({
                uglifyOptions: {
                    compress: {
                        passes: 3,
                        ecma: 5, // Set to 6+ to enable the following
                        unsafe_arrows: true,
                        unsafe_methods: true,
                        properties: {
                            reserved: ['Main']
                        }
                    },
                    mangle: true,
                    toplevel: true
                }
            }),
            new OptimizeCssAssetsPlugin({})
        ]
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: '[name].css'
        }),
        new HtmlPlugin({
            title: "elm-dnd",
            minify: {
                collapseInlineTagWhitespace: true,
                collapseWhitespace: true,
                removeComments: true,
                removeRedundantAttributes: true,
                removeScriptTypeAttributes: true,
                removeStyleLinkTypeAttributes: true,
                sortAttributes: true,
                sortClassName: true,
                useShortDoctype: true
            },
            excludeAssets: [/style\.js/]
        }),
        new HtmlExcludeAssetsPlugin(),
        new RemoveSourcePlugin(/style\.js/)
    ]
};
