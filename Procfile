web: bundle exec thin start -p $PORT -e $RACK_ENV
log: tail -f log/development.log
worker:  bundle exec rake jobs:work