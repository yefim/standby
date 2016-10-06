module.exports = {
  context: __dirname,
  entry: {
    app: './static/scripts/index.js'
  },
  output: {
    path: './static/build',
    filename: 'bundle.js'
  },
  resolve: {
    root: __dirname,
    modulesDirectories: ['static/scripts', 'node_modules'],
    extensions: ['', '.js']
  },
  module: {
    loaders: [
      {
        loader: 'babel',
        exclude: /node_modules/,
        test: /\.js$/,
        query: {
          presets: ['es2015'],
          cacheDirectory: true,
          plugins: ['transform-strict-mode', 'transform-object-rest-spread', 'es6-promise']
        },
      }
    ]
  }
};
