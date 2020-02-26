# GOV.UK expects that all repos will sit as siblings in a single directory
# within home. If you don't do things like this, then govuk-docker and govuk-puppet
# will not be happy with you
GOVUK_ROOT_DIR=$HOME/govuk


# GOV.UK Docker
# https://github.com/alphagov/govuk-docker

# Run GOV.UK Docker like an executable
GOVUK_DOCKER_DIR=$GOVUK_ROOT_DIR/govuk-docker
GOVUK_DOCKER=$GOVUK_DOCKER_DIR/bin/govuk-docker

export PATH=$PATH:~/govuk/govuk-docker/exe

# Aliases to help quickly run repetative tasks
alias gd="govuk-docker"
alias gdr='govuk-docker-run'
alias gdu='govuk-docker-up'
alias gdbx='govuk-docker-run bundle exec'
alias gdbi='govuk-docker-run bundle install'
alias gdrake='govuk-docker-run bundle exec rake'

# Configure GPG for work
export GPG_TTY=$(tty)
