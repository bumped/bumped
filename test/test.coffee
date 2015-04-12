path    = require 'path'
should  = require 'should'
fs      = require 'fs-extra'
Bumped  = require '../lib/Bumped'

describe 'Bumped ::', ->

  before ->
    src = path.resolve(__dirname, 'fixtures/sample_directory')
    dest = path.resolve(__dirname, 'sample_directory')
    fs.copySync(src, dest)
    @bumped = new Bumped(scope: dest)

  it 'load a configuration file from a directory', ->
    @bumped.config.files[0].should.be.equal 'bower.json'
    @bumped.config.files[1].should.be.equal 'package.json'

  it 'synchronized the version of the files',  ->
    @bumped.version.should.be.equal('0.2.0')

  it 'increment the version', ->
    @bumped.increment('major').version.should.be.equal('1.0.0')

  it 'save the new version', (done) ->
    # start = new Date().getTime()
    @bumped.save (err) ->
      # end = new Date().getTime();
      # console.log "Execution time: #{end - start} ms"
      bower = require('./sample_directory/bower.json')
      bower.version.should.be.equal('1.0.0')
      done()
