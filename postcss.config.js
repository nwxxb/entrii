module.exports = {
  plugins: [
    // postcss doesn't play nicely with open-props
    // maybe we can re-enable it after upgrading rails and it's asset management
    // require('postcss-import'),
    // require('postcss-flexbugs-fixes'),
    // require('postcss-preset-env')({
    //   autoprefixer: {
    //     flexbox: 'no-2009'
    //   },
    //   stage: 3
    // }),
  ]
}
