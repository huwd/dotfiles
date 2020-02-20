# frozen_string_literal: true

require 'rake'
require 'fileutils'

desc 'Hook our dotfiles into system-standard positions.'
# task install: %i[submodule_init submodules] do
task :install do
  puts
  puts '======================================================'
  puts 'Welcome to Dotfiles Installation.'
  puts '======================================================'
  puts

  install_dependencies

  # this has all the runcoms from this directory.
  # if want_to_install?('git configs (color, aliases)')
  #   install_files(Dir.glob('git/*'))
  # end
  # if want_to_install?('irb/pry configs (more colorful)')
  #   install_files(Dir.glob('irb/*'))
  # end
  # if want_to_install?('rubygems config (faster/no docs)')
  #   install_files(Dir.glob('ruby/*'))
  # end
  # if want_to_install?('ctags config (better js/ruby support)')
  #   install_files(Dir.glob('ctags/*'))
  # end
  # install_files(Dir.glob('tmux/*')) if want_to_install?('tmux config')
  # if want_to_install?('vimification of command line tools')
  #   install_files(Dir.glob('vimify/*'))
  # end
  # if want_to_install?('vim configuration (highly recommended)')
  #   install_files(Dir.glob('{vim,vimrc}'))
  #   Rake::Task['install_vundle'].execute
  # end

  Rake::Task['install_prezto'].execute

  install_fonts
  install_term_theme

  # run_bundle_config

  success_msg('installed')
end

task :install_prezto do
  install_prezto if want_to_install?('zsh enhancements & prezto')
end

task default: 'install'

private

DEPENDENCIES = {
  all: %w[
    zsh
    tmux
    git
    wget
    curl
  ],
  mac: ['macvim'],
  linux: %w[
    neovim
    dconf-cli
    fontconfig
  ]
}.freeze

## @TODO consider adding:
# ctags
# hub
# reattach-to-user-namespace
# the_silver_searcher
# ghi

def platform_deps
  DEPENDENCIES[:all].concat(DEPENDENCIES[os_type.to_sym]).uniq.join(' ')
end

def run(cmd)
  puts "[Running] #{cmd}"
  system "#{cmd}" unless ENV['DEBUG']
end

def want_to_install? (section)
  if ENV["ASK"]=="true"
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true
  end
end

def mac?
  os_type == 'mac'
end

def linux?
  os_type == 'linux'
end

def os_type
  platform = RUBY_PLATFORM.downcase
  return 'mac' if platform.include?('darwin')
  return 'linux' if platform.include?('linux')

  raise 'Fatal unsupported operating system'
end

def install_dependencies
  puts
  puts
  if is_mac? do
    puts "======================================================"
    puts "Updating Homebrew."
    puts "======================================================"
    run "brew update"
    puts
    puts
    puts "======================================================"
    puts "Installing Homebrew packages...There may be some warnings."
    puts "======================================================"
    run "brew install #{platform_deps}"
    run "brew install macvim"
  end
  if is_linux? do
    puts "======================================================"
    puts "Updating Packages (apt)."
    puts "======================================================"
    run "apt update"
    puts
    puts
    puts "======================================================"
    puts "Installing apt packages...There may be some warnings."
    puts "======================================================"
    run "apt install #{playform_deps}"
    run "apt install neovim"
  end
  puts
  puts
end

def install_homebrew
  run %{which brew}
  unless $?.success?
    puts "======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
  end
  puts
  puts
  puts "======================================================"
  puts "Updating Homebrew."
  puts "======================================================"
  run %{brew update}
  puts
  puts
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline/Lightline."
  puts "======================================================"
  run %{ cp -f $HOME/.dotfiles/fonts/* $HOME/Library/Fonts } if is_mac?
  run %{ mkdir -p ~/.fonts && cp ~/.dotfiles/fonts/* ~/.fonts && fc-cache -vf ~/.fonts } if is_linux?
  puts
end



UnsupportedOsError < StandardError; end
