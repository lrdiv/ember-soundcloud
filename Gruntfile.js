hostName = '';

module.exports = function(grunt) {

  grunt.initConfig({

    shell: {
      build: {
        command: function(environment) {
          return 'ember build --environment=' + environment;
        }
      }
    },
    
    rsync: {
      options: {
        args: ['--verbose'],
        recursive: true
      },
      prod: {
        options: {
          src: 'dist/*',
          dest: '/var/www/ember/soundcloud/',
          host: hostName
        }
      }
    }

  });

  var env = grunt.option('env') || 'production'; 

  grunt.loadNpmTasks('grunt-shell');
  grunt.loadNpmTasks('grunt-rsync');

  grunt.registerTask('sync', ['shell:build:' + env, 'rsync'])

};
