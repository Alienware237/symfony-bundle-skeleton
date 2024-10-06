#! /bin/bash

case "$1" in
  "exec")
    shift; eval "$@";;

  "composer")
    shift; composer "$@";;

  "debug")
    shift; php -d "xdebug.start_with_request=yes" "$@";;

  "test")
    shift; php -d "xdebug.mode=coverage" vendor/bin/phpunit "$@";;

  *)
    [ $# -eq 0 ] && set -- "-a"; php "$@";;
esac
exit $?
