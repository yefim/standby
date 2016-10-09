var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  context: __dirname,
  entry: {
    app: './static/scripts/index.js'
  },
  output: {
    path: './static/build',
    filename: '[hash].bundle.js'
  },
  resolve: {
    root: __dirname,
    modulesDirectories: ['static/scripts', 'static/styles', 'node_modules'],
    extensions: ['', '.js', '.css', '.scss']
  },
  module: {
    loaders: [
      {
        loaders: ['style', 'css'],
        test: /\.css$/
      },
      {
        loaders: ['style', 'css', 'sass'],
        test: /\.scss$/
      },
      {
        loader: 'ejs',
        test: /\.ejs$/
      },
      {
        loader: 'babel',
        exclude: /node_modules/,
        test: /\.js$/,
        query: {
          presets: ['es2015'],
          cacheDirectory: true,
          plugins: ['transform-strict-mode', 'transform-object-rest-spread', 'es6-promise']
        }
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
        _: 'lodash'
    }),
    new HtmlWebpackPlugin({
      template: 'static/index.ejs'
    })
  ]
};
