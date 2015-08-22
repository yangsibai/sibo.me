module.exports = (grunt)->
    zipPath = "output/*"
    grunt.initConfig
        clean:
            short: ['bin']
            options:
                force: true
        coffeelint:
            app: [
                "helper/*.coffee"
                "model/**/*.coffee"
                "site/**/**.coffee"
            ]
            options:
                "indentation":
                    "level": "ignore"
                "max_line_length":
                    "level": "ignore"

    grunt.loadNpmTasks('grunt-coffeelint')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.registerTask('default', ['coffeelint', 'clean'])
