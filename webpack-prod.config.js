var webpack = require('webpack');
var CompressionPlugin = require('compression-webpack-plugin');
var config = require('./webpack.config');

config.plugins = config.plugins.concat([
  new webpack.DefinePlugin({
    'process.env': {
      'NODE_ENV': JSON.stringify('production')
    }
  }),
  new webpack.optimize.UglifyJsPlugin({
    compress: {
      warnings: false
    }
  }),
  new CompressionPlugin({
		asset: '[path].gz[query]',
		algorithm: 'gzip',
		test: /\.js$|\.css$|\.html$/,
		threshold: 1024,
		minRatio: 0.8
	})
]);

module.exports = config;
