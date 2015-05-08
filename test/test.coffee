path    = require 'path'
should  = require 'should'
fs      = require 'fs-extra'
pkg     = require '../package.json'
Bumped  = require '../lib/Bumped'

describe 'Bumped ::', ->

  describe 'core', ->

    before ->
      src = path.resolve(__dirname, 'fixtures/sample_directory')
      dest = path.resolve(__dirname, 'sample_directory')
      fs.copySync(src, dest)
      @bumped = new Bumped(cwd: dest, logger: {color: true})

    after ->
      fs.removeSync("#{process.cwd()}/.#{pkg.name}rc")

    it 'initialize a configuration file', (done) ->
      @bumped.init (err) ->
        config = fs.readFileSync('.bumpedrc', encoding: 'utf8')
        config = JSON.parse(config)
        config.files.length.should.be.equal 2
        done()

    it 'sync correctly the version between the files', ->
      @bumped.semver.version().should.be.equal('0.2.0')

    it 'increment the version', (done) ->
      @bumped.semver.increment 'major', =>
        @bumped.semver.version().should.be.equal('1.0.0')
        bower = require('./sample_directory/bower.json')
        bower.version.should.be.equal('1.0.0')
        done()
