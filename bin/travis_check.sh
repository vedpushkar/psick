#!/usr/bin/env bash
repo_dir="$(dirname $0)/.."
. "${repo_dir}/bin/functions"

global_exit=0

run_script() {
  status=${2:-'required'}
  $1
  if ([ $? = 0 ] || [ $status != 'required' ]); then
    echo_success "OK"
  else
    echo_failure "ERROR"
    global_exit=1
  fi
}

# Syntax tests
run_script "bundle exec rake validate"
#run_script bin/puppet_check_syntax_fast.sh

# Lint tests
run_script "bundle exec rake lint"
#run_script bin/puppet_lint.sh optional

# Spec tests
if $SKIP_SPEC_TESTS!="true" {
  # Control repo nodes spec tests
  run_script "bundle exec rake spec"
  # Site modules spec tests
  run_script "bin/puppet_check_rake.sh site"
  # Public modules spec tests
  # run_script "bin/puppet_check_rake.sh modules"
} else {
  echo "Skipping spec tests"
}

exit $global_exit
