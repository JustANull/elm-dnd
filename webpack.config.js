const glob = require("glob");
const path = require("path");

const history = require("koa-connect-history-api-fallback");
const whitelister = require("purgecss-whitelister");

const webpack = require("webpack");
const merge = require("webpack-merge");

const CleanPlugin = require("clean-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin");
const HtmlPlugin = require("html-webpack-plugin");
const OptimizeCssAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const PurgeCssPlugin = require("purgecss-webpack-plugin");
const TerserPlugin = require("terser-webpack-plugin");

const mode = process.env.npm_lifecycle_event === "prod" ? "production" : "development";
const filename = mode === "production" ? "[contenthash:8]" : "index";
const resourceFilename = mode === "production" ? "[hash:8].[ext]" : "[name].[ext]";

const common = {
  mode: mode,
  entry: path.join(__dirname, "apps/web/src/index.js"),
  output: {
    path: path.join(__dirname, "dist"),
    publicPath: "./",
    filename: filename + ".js"
  },
  plugins: [
    new HtmlPlugin({
      title: "elm-dnd",
      inject: "body",
      minify: mode === "production" && {
        collapseWhitespace: true,
        minifyURLs: true,
        removeComments: true,
        removeEmptyAttributes: true,
        removeRedundantAttributes: true,
        removeScriptTypeAttributes: true,
        removeStyleLinkTypeAttributes: true,
        sortAttributes: true,
        sortClassName: true,
        useShortDoctype: true
      }
    })
  ],
  resolve: {
    modules: [
      path.join(__dirname, "apps/web/src"),
      path.join(__dirname, "node_modules")
    ],
    extensions: [".css", ".elm", ".js"]
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        exclude: [/\belm\-stuff\b/],
        loaders: [
          mode === "production" ? MiniCssExtractPlugin.loader : "style-loader",
          "css-loader",
          "postcss-loader"
        ]
      },
      {
        test: /\.js$/,
        exclude: /\bnode_modules\b/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"]
          }
        }
      },
      {
        test: /\.(woff2?|eot|ttf)(\?[a-z0-9=.]+)?$/,
        use: {
          loader: "url-loader",
          options: {
            limit: 4096,
            fallback: "file-loader",
            name: resourceFilename
          }
        }
      }
    ]
  }
};

if (mode === "development") {
  module.exports = merge(common, {
    plugins: [
      new webpack.NamedModulesPlugin(),
      new webpack.NoEmitOnErrorsPlugin()
    ],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/\belm\-stuff\b/, /\bnode_modules\b/],
          use: [
            {
              loader: "elm-hot-webpack-loader"
            },
            {
              loader: "elm-webpack-loader",
              options: {
                debug: true,
                forceWatch: true
              }
            }
          ]
        }
      ]
    },
    serve: {
      inline: true,
      stats: "errors-only",
      content: [path.join(__dirname, "apps/web/assets")],
      add: (app, middleware, options) => {
        app.use(history());
      }
    }
  });
} else if (mode === "production") {
  module.exports = merge(common, {
    optimization: {
      concatenateModules: true,
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            compress: {
              keep_fargs: false,
              pure_funcs: ["F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9",
                           "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9"],
              pure_getters: true,
              unsafe_comps: true,
              unsafe: true
            },
            mangle: true
          },
          cache: true,
          parallel: true,
          sourceMap: false
        }),
        new OptimizeCssAssetsPlugin({
          cssProcessorOptions: {
            cssDeclarationSorter: true,
            discardUnused: true,
            mergeIdents: true,
            reduceIdents: true,
            zindex: true
          }
        })
      ]
    },
    plugins: [
      new CleanPlugin(["dist"], {
        root: __dirname,
        exclude: [],
        verbose: true,
        dry: false
      }),
      new CopyPlugin([
        {
          from: "apps/web/assets"
        }
      ]),
      new MiniCssExtractPlugin({
        filename: filename + ".css"
      }),
      new PurgeCssPlugin({
        whitelist: whitelister([
          path.join(__dirname, "apps/web/src/global.css"),
          path.join(__dirname, "node_modules/tailwindcss/css/preflight.css")
        ]),
        paths: glob.sync(path.join(__dirname, "apps/web/src/**/*.elm"), { nodir: true }),
        extractors: [
          {
            extractor: class {
              static extract(content) {
                return content.match(/(?<=")(?:[^"\n]|\\.)*(?=")/g) || [];
              }
            },
            extensions: [".elm"]
          }
        ]
      })
    ],
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/\belm\-stuff\b/, /\bnode_modules\b/],
          use: [
            {
              loader: "elm-webpack-loader",
              options: {
                optimize: true
              }
            }
          ]
        }
      ]
    }
  });
} else {
  throw "Unknown mode: " + mode;
}
