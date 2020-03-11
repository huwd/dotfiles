# frozen_string_literal: true

require 'rake'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'bin', 'dotfiles', 'vundle')

desc 'Hook our dotfiles into system-standard positions.'
task install: %i[submodule_init submodules] do
  puts '======================================================'
  puts 'Welcome to Dotfiles Installation.'
  puts '======================================================'
  puts

  install_dependencies

  # this has all the runcoms from this directory.
  if want_to_install?('git configs (color, aliases)')
    install_files(Dir.glob('git/*'))
  end

  if want_to_install?('irb/pry configs (more colorful)')
    install_files(Dir.glob('irb/*'))
  end

  if want_to_install?('rubygems config (faster/no docs)')
    install_files(Dir.glob('ruby/*'))
  end

  if want_to_install?('a terminal multiplexer')
    install_files(Dir.glob('tmux/*')) if want_to_install?('tmux config')
  end

  if want_to_install?('vimification of command line tools')
    install_files(Dir.glob('vimify/*'))
  end

  # if want_to_install?('nvim configuration (highly recommended)')
  #   install_files(Dir.glob('{nvim,vimrc}'))
  #   Rake::Task["install_vundle"].execute
  # end

  if profile_customisations_exist? && want_to_install?("work customisations (#{supported_profiles.join(' ')})")
    profile = select_a_profile_to_install
    install_files(Dir.glob("profiles/#{profile}/*"))
  end

  Rake::Task['install_prezto'].execute

  install_fonts
  install_term_theme
  run_bundle_config

  success_msg('installed')
end

desc 'Runs Vundle installer in a clean vim environment'
task :install_vundle do
  puts '======================================================'
  puts 'Installing and updating vundles.'
  puts 'The installer will now proceed to run PluginInstall to install vundles.'
  puts '======================================================'
  puts ''

  vundle_path = File.join('nvim', 'bundle', 'vundle')
  unless File.exist?(vundle_path)
    run %(
      cd $HOME/.dotfiles
      git clone https://github.com/gmarik/vundle.git #{vundle_path}
    )
  end

  Vundle.update_vundle
end

desc 'Updates the installation'
# TODO: for now, we do the same as install. But it would be nice
# not to clobber zsh files
task :update do
  Rake::Task['vundle_migration'].execute if needs_migration_to_vundle?
  Rake::Task['install'].execute
end

task :submodule_init do
  run %( git submodule update --init --recursive ) unless ENV['SKIP_SUBMODULES']
end

desc 'Init and update submodules.'
task :submodules do
  unless ENV['SKIP_SUBMODULES']
    puts '======================================================'
    puts 'Downloading Dotfiles submodules...please wait'
    puts '======================================================'

    run %(
      cd $HOME/.dotfiles
      git submodule update --recursive
      git clean -df
    )
    puts
  end
end

desc 'Performs migration from pathogen to vundle'
task :vundle_migration do
  puts '======================================================'
  puts 'Migrating from pathogen to vundle vim plugin manager. '
  puts 'This will move the old .vim/bundle directory to'
  puts '.vim/bundle.old and replacing all your vim plugins with'
  puts 'the standard set of plugins. You will then be able to '
  puts "manage your vim's plugin configuration by editing the "
  puts 'file .vim/vundles.vim'
  puts '======================================================'

  Dir.glob(File.join('nvim', 'bundle', '**')) do |sub_path|
    run %(git config -f #{File.join('.git', 'config')} --remove-section submodule.#{sub_path})
    # `git rm --cached #{sub_path}`
    FileUtils.rm_rf(File.join('.git', 'modules', sub_path))
  end
  FileUtils.mv(File.join('nvim', 'bundle'), File.join('nvim', 'bundle.old'))
end

task :install_prezto do
  install_prezto if want_to_install?('zsh enhancements & prezto')
end

task default: 'install'

private

DEPENDENCIES = {
  all: %w[
    ctags
    curl
    git
    neovim
    tmux
    wget
    silversearcher-ag
    zsh
  ],
  mac: %w[
    asdf
    the_silver_searcher
  ],
  linux: %w[
    dconf-cli
    fontconfig
  ]
}.freeze

def needs_migration_to_vundle?
  File.exist? File.join('nvim', 'bundle', 'tpope-vim-pathogen')
end

def profiles_directories
  Dir.glob('profiles/*')
end

def profile_customisations_exist?
  !profiles_directories.empty?
end

def supported_profiles
  profiles_directories.map { |profile_dir| profile_dir.split('/')[1] }
end

def platform_deps
  DEPENDENCIES[:all].concat(DEPENDENCIES[os_type.to_sym]).uniq.join(' ')
end

def run(cmd)
  puts "[Running] #{cmd}"
  system cmd.to_s unless ENV['DEBUG']
end

def select_a_profile_to_install
  return ENV['DEFAULT_PROFILE'] if ENV['ASK'] == 'true'
  return supported_profiles.count == 1 if supported_profiles[0]

  multiple_choice(
    'Which workplace would you like to install configuration files for: ',
    supported_profiles
  )
end

def multiple_choice(prompt, options)
  option_chosen = false
  until option_chosen
    list_choices(prompt, options)
    choice = STDIN.gets.chomp
    return choices[choice - 1] if (1..choices.count).include? STDIN.gets.chomp

    puts 'options not recognised, try again'
    puts
  end
end

def list_choices(prompt, options)
  puts 'Options'
  puts '======='
  options.each.with_index(1) { |option, i| puts "  #{i}) #{option}" }
  puts prompt
end

def want_to_install?(section)
  if ENV['ASK'] == 'true'
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
  update_mac_deps if mac?
  update_linux_deps if linux?
  puts
  puts
end

def update_linux_deps
  puts '======================================================'
  puts 'Updating Packages (apt).'
  puts '======================================================'
  run 'sudo apt-get update'
  puts
  puts
  puts '======================================================'
  puts 'Installing apt packages...There may be some warnings.'
  puts '======================================================'
  run "sudo apt-get install -yqq #{platform_deps}"
end

def update_mac_deps
  install_homebrew
  puts '======================================================'
  puts 'Updating Homebrew.'
  puts '======================================================'
  run 'brew update'
  puts
  puts
  puts '======================================================'
  puts 'Installing Homebrew packages...There may be some warnings.'
  puts '======================================================'
  run "brew install #{platform_deps}"
end

def install_homebrew
  return if run %(which brew)

  puts '======================================================'
  puts "Installing Homebrew, the OSX package manager...If it's"
  puts 'already installed, this will do nothing.'
  puts '======================================================'
  run %{ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
end

def install_fonts
  puts '======================================================'
  puts 'Installing patched fonts for Powerline/Lightline.'
  puts '======================================================'
  run %( cp -f $HOME/.dotfiles/fonts/* $HOME/Library/Fonts ) if mac?
  if linux?
    run %( mkdir -p ~/.fonts && cp ~/.dotfiles/fonts/* ~/.fonts && fc-cache -vf ~/.fonts )
  end
  puts
end

def install_prezto
  puts
  puts 'Installing Prezto (ZSH Enhancements)...'

  run %( ln -nfs "$HOME/.dotfiles/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto" )

  # The prezto runcoms are only going to be installed if zprezto has never been installed
  install_files(Dir.glob('zsh/prezto/runcoms/z*'), :symlink)

  puts
  puts "Overriding prezto ~/.zpreztorc with dotfiles' zpreztorc to enable additional modules..."
  override_preztorc

  puts
  puts 'Creating directories for your customizations'
  run %( mkdir -p $HOME/.zsh.before )
  run %( mkdir -p $HOME/.zsh.after )
  run %( mkdir -p $HOME/.zsh.prompts )

  if (ENV['SHELL']).to_s.include? 'zsh'
    puts 'Zsh is already configured as your shellzas of choice. Restart your session to load the new settings'
  else
    puts 'Setting zsh as your default shell'
    if File.exist?('/usr/local/bin/zsh')
      if File.readlines('/private/etc/shells').grep('/usr/local/bin/zsh').empty?
        puts 'Adding zsh to standard shell list'
        run %( echo "/usr/local/bin/zsh" | sudo tee -a /private/etc/shells )
      end
      run %( chsh -s /usr/local/bin/zsh )
    else
      run %( chsh -s /bin/zsh )
    end
  end
end

def override_preztorc
  run %( ln -nfs "$HOME/.dotfiles/zsh/prezto-override/zpreztorc-#{os_type}" "${ZDOTDIR:-$HOME}/.zpreztorc" )
end

def install_term_theme
  install_theme_linux_term if linux?
  install_theme_iterm if mac?
end

def install_theme_linux_term
  puts '======================================================'
  puts 'Installing Terminal solarized theme.'
  puts '======================================================'
  run %(git clone https://github.com/huwd/gnome-terminal-colors-solarized.git)
  run %(./gnome-terminal-colors-solarized/set_dark.sh)
  run %(rm -rf gnome-terminal-colors-solarized)
end

def install_theme_iterm
  puts '======================================================'
  puts 'Installing iTerm2 solarized theme.'
  puts '======================================================'
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Light' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Light.itermcolors' :'Custom Color Presets':'Solarized Light'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Add :'Custom Color Presets':'Solarized Dark' dict" ~/Library/Preferences/com.googlecode.iterm2.plist )
  run %( /usr/libexec/PlistBuddy -c "Merge 'iTerm2/Solarized Dark.itermcolors' :'Custom Color Presets':'Solarized Dark'" ~/Library/Preferences/com.googlecode.iterm2.plist )
  # If iTerm2 is not installed or has never run, we can't autoinstall the profile since the plist is not there
  unless File.exist?(File.join(ENV['HOME'], '/Library/Preferences/com.googlecode.iterm2.plist'))
    puts '======================================================'
    puts 'To make sure your profile is using the solarized theme'
    puts 'Please check your settings under:'
    puts 'Preferences> Profiles> [your profile]> Colors> Load Preset..'
    puts '======================================================'
    nil
  end
end

# Temporary solution until we find a way to allow customization
# This modifies zshrc to load all of dotfiles' zsh extensions.
# Eventually dotfiles' zsh extensions should be ported to prezto modules.
def load_zsh_extensions(file, path = '$HOME/.dotfiles/zsh/*.zsh')
  source_config_code = "for config_file (#{path}) source $config_file"
  target = "#{ENV['HOME']}/.#{file}"

  if file == 'zshrc'
    File.open(target, 'a+') do |zshrc|
      if zshrc.readlines.grep(/#{Regexp.escape(source_config_code)}/).empty?
        zshrc.puts(source_config_code)
      end
    end
  end
end

def install_files(files, method = :symlink)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV['PWD']}/#{f}"
    target = "#{ENV['HOME']}/.#{file}"

    next if file == 'README.md'

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exist?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %( mv "$HOME/.#{file}" "$HOME/.#{file}.backup" )
    end

    if method == :symlink
      run %( ln -nfs "#{source}" "#{target}" )
    else
      run %( cp -f "#{source}" "#{target}" )
    end

    load_zsh_extensions(file)

    puts '=========================================================='
    puts
  end
end

def run_bundle_config
  return unless system('which bundle')

  bundler_jobs = number_of_cores - 1
  puts '======================================================'
  puts 'Configuring Bundlers for parallel gem installation'
  puts '======================================================'
  run %( bundle config --global jobs #{bundler_jobs} )
  puts
end

def number_of_cores
  cores = if RUBY_PLATFORM.downcase.include?('darwin')
            `sysctl -n hw.ncpu`.chomp
          else
            `nproc`.chomp
          end
  puts
  cores.to_i
end

def success_msg(action)
  puts ''
  puts '  _____        _    __ _ _             '
  puts ' |  __ \      | |  / _(_) |            '
  puts ' | |  | | ___ | |_| |_ _| | ___  ___   '
  puts ' | |  | |/ _ \| __|  _| | |/ _ \/ __|  '
  puts ' | |__| | (_) | |_| | | | |  __/\__ \  '
  puts ' |_____/ \___/ \__|_| |_|_|\___||___/  '
  puts '                                       '
  puts ''
  puts "Dotfiles have been #{action}. Please restart your terminal and vim."
end
