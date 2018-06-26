{ pkgs, lib, config, ... }:

let
  modifier = "Mod4";
  move = "50px";
in
{
  home.keyboard.layout = "de";

    home.packages = [
      pkgs.htop
      pkgs.git
      pkgs.terminator
      pkgs.firefox
      pkgs.thunderbird
      pkgs.gnupg
      pkgs.parcellite
      pkgs.redshift
      pkgs.vlc
      pkgs.youtubeDL
      pkgs.hugo
      pkgs.borgbackup
      pkgs.keybase-gui
      pkgs.meld
      pkgs.hstr
      pkgs.gimp
      pkgs.yubikey-personalization-gui
      pkgs.yubioath-desktop
      pkgs.lm_sensors
      pkgs.keepassxc
      pkgs.dropbox
      pkgs.blueman
      pkgs.ranger
      pkgs.powerline-fonts
      pkgs.wget
      pkgs.usbutils
      pkgs.gnome3.gnome-keyring
      pkgs.gnome3.dconf
      pkgs.pavucontrol
      pkgs.lsof
      pkgs.xorg.xev
      pkgs.xorg.xbacklight
      pkgs.feh
      pkgs.libnotify
      pkgs.bluez
      pkgs.bash-completion
      pkgs.unzip
    ];

  programs.vim = {
    enable = true;
    plugins = [
      "Tabular"
      "vim-indent-guides"
      "syntastic"
      "fugitive"
      "nerdtree"
      "ctrlp"
#      "vim-gnupg"
      "vim-airline"
#      "SudoEdit.vim"
      "vim-multiple-cursors"
      "surround"
      "editorconfig-vim"
#      "vim-better-whitespace"
#      "Dockerfile.vim"
#      "vim-vagrant"
#      "Vim-Jinja2-Syntax"
      "neocomplete"
      "neosnippet"
      "neosnippet-snippets"
      "vim-snippets"
      "vim-airline-themes"
      "molokai"
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
set nocompatible
filetype off
"----------------------------------------------------------------------
" Gvim
"----------------------------------------------------------------------

if has("gui_running")
  if has("gui_gtk2")
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
  endif
endif

"----------------------------------------------------------------------
" Basic Options
"----------------------------------------------------------------------
" Automatically detect file types.
filetype plugin indent on
scriptencoding utf-8
set encoding=utf-8

" breaks vimgrep
" set shell=/bin/bash\ -i

" Reads the file again if a change outside vim happened
set autoread

set cursorline " Highlight the line the cursor is on
set laststatus=2 " Always show the status bar
set number
set t_Co=256 " Use 256 colors
set showmatch " Highlight matching braces

syntax on " Enable filetype detection by syntax

" Search settings
set hlsearch " Highlight results
set incsearch " Start showing results as you type
set ignorecase " Case insensitiv search

" history
set history=1000

"----------------------------------------------------------------------
" swap, backup, undo
"----------------------------------------------------------------------
set backup " tell vim to keep a backup file
set backupdir=$HOME/.vim/backup " tell vim where to put its backup files
set dir=$HOME/.vim/swap " tell vim where to put swap files

set undofile
set undodir=$HOME/.vim/undo

"----------------------------------------------------------------------
" colorschemes
"----------------------------------------------------------------------
colorscheme molokai

augroup vimrc
augroup END

"----------------------------------------------------------------------
" Autocommands
"----------------------------------------------------------------------
if has("autocmd")
  " Clear whitespace at the end of lines automatically
  autocmd BufWritePre * :%s/\s\+$//e

  autocmd bufwritepost .vimrc source $MYVIMRC

  filetype on
  autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
  autocmd BufNewFile,BufRead *.erb set filetype=ruby
  autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
  autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType sh   setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType ino  setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType rst  setlocal ts=4 sts=4 sw=4 list

  " https://github.com/jamessan/vim-gnupg/issues/58
  autocmd User GnuPG set t_Co=256
endif

"----------------------------------------------------------------------
" Split navigation
"----------------------------------------------------------------------
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

"----------------------------------------------------------------------
" Different styles of tab mode
"----------------------------------------------------------------------
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

"----------------------------------------------------------------------
" Help properties
"----------------------------------------------------------------------
set helpheight=40

"----------------------------------------------------------------------
" Spell checking
"----------------------------------------------------------------------
" See: http://vimcasts.org/episodes/spell-checking/

" Toggle spell checking on and off with `,s`
let mapleader = ","
nmap <silent> <leader>s :set spell!<CR>

" Set region to British English
set spelllang=en_us

"----------------------------------------------------------------------
" Plugin settings
"----------------------------------------------------------------------

" GPG
let g:GPGExecutable = 'gpg2'

" Indent Guides
" https://github.com/nathanaelkane/vim-indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Neocomplete
" https://github.com/Shougo/neocomplete.vim
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15
let g:neocomplete#force_overwrite_completefunc = 1

" always use completions from all buffers
if !exists('g:neocomplete#same_filetypes')
  let g:neocomplete#same_filetypes = {}
endif
let g:neocomplete#same_filetypes._ = '_'

"let g:acp_enableAtStartup = 0
"let g:neocomplete#enable_at_startup = 1
"let g:neocomplete#enable_smart_case = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<TAB>" : "\<Plug>(neosnippet_expand_or_jump)"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
" TODO
" check why this is here!
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/personal_snippits'

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = "wombat"
let g:airline#extensions#tabline#enabled = 1

" Tagbar
nmap <F8> :TagbarOpenAutoClose<CR>
let g:tagbar_autopreview = 1
let g:tagbar_show_linenumbers = 1

" SudoEdit
let g:sudo_no_gui=1

set conceallevel=0 " 0 = Text is shown normally
    '';
  };

    xsession.enable = true;

    xsession.windowManager.i3 = {
      enable = true;
      extraConfig = ''
        set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown, (Shift+p) Presenter Modus
        mode "$mode_system" {
          bindsym l exec --no-startup-id ~/.config/i3/i3-exit lock, mode "default"
          bindsym e exec --no-startup-id ~/.config/i3/i3-exit logout, mode "default"
          bindsym s exec --no-startup-id ~/.config/i3/i3-exit suspend, mode "default"
          bindsym h exec --no-startup-id ~/.config/i3/i3-exit hibernate, mode "default"
          bindsym r exec --no-startup-id ~/.config/i3/i3-exit reboot, mode "default"
          bindsym Shift+s exec --no-startup-id ~/.config/i3/i3-exit shutdown, mode "default"
          bindsym Shift+p exec --no-startup-id ~/.config/i3/i3-exit present, mode "default"

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
        }
      '';
      config = {
        modifier = "${modifier}";
        focus.forceWrapping = true;
        keybindings =
          lib.mkOptionDefault {
            "${modifier}+1" = "workspace 1:Web";
            "${modifier}+2" = "workspace 2:Email";
            "${modifier}+3" = "workspace 3:Terminal";
            "${modifier}+Shift+1" = "move container to workspace 1:Web";
            "${modifier}+Shift+2" = "move container to workspace 2:Email";
            "${modifier}+Shift+3" = "move container to workspace 3:Terminal";
            "${modifier}+Shift+Left" = "move left ${move}";
            "${modifier}+Shift+Down" = "move down ${move}";
            "${modifier}+Shift+Up" = "move up ${move}";
            "${modifier}+Shift+Right" = "move right ${move}";
            "${modifier}+space" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+SHIFT+plus" = "move scratchpad";
            "${modifier}+plus" = "scratchpad show";
            "${modifier}+x" = "move workspace to output right";
            "${modifier}+y" = "move workspace to output up";
            "Control+${modifier}+a" = "workspace prev";
            "Control+${modifier}+s" = "workspace next";
            "Control+${modifier}+q" = "workspace back_and_forth";
            "${modifier}+Tab" = "exec rofi -show combi run -threads 0";
            "${modifier}+Shift+e" = "mode \"\$mode_system\"";
            "XF86AudioRaiseVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 5%+ unmute";
            "XF86AudioLowerVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 5%- unmute";
            "XF86AudioMute" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 1+ toggle";
            "XF86MonBrightnessUp" = "exec xbacklight -inc 10";
            "XF86MonBrightnessDown" = "exec xbacklight -dec 10";
          };
        modes = {
          resize = {
            j = "resize shrink left width 10 px or 10 ppt";
            "Shift+J" = "resize grow left width 10 px or 10 ppt";
            k = "resize shrink down 10 px or 10 ppt";
            "Shift+K" = "resize grow down 10 px or 10 ppt";
            l = "resize shrink up 10 px or 10 ppt";
            "Shift+L" = "resize grow up 10 px or 10 ppt";
            odiaeresis = "resize shrink right 10 px or 10 ppt";
            "Shift+Odiaeresis" = "resize grow right 10 px or 10 ppt";
            Left = "resize shrink left 10 px or 10 ppt";
            "Shift+Left" = "resize grow left 10 px or 10 ppt";
            Down = "resize shrink down 10 px or 10 ppt";
            "Shift+Down" = "resize grow down 10 px or 10 ppt";
            Up = "resize shrink up 10 px or 10 ppt";
            "Shift+Up" = "resize grow up 10 px or 10 ppt";
            Right = "resize shrink right 10 px or 10 ppt";
            "Shift+Right" = "resize grow right 10 px or 10 ppt";
            Return = "mode \"default\"";
            Escape = "mode \"default\"";
          };
        };
        startup = [
          {
            command = "feh --bg-scale '/home/tuxinaut/pictures/wallpaper.png'";
            notification = false;
          }
          {
            command = "blueman-applet";
            notification = false;
          }
          {
            command = "xset dpms 600";
            notification = false;
          }
          {
            command = "gtk-redshift";
          }
          {
            command = "parcellite";
          }
          {
            command = "dropbox start";
          }
#          {
#            command = "nm-applet";
#          }
        ];
        bars = [
          {
            id = "bar-0";
            position = "top";
          }
        ];
      };
    };

    programs.git = {
      enable = true;
      userName = "Denny Schäfer";
      userEmail = "denny.schaefer@tuxinaut.de";
      signing = {
        key = "23DB861B";
        signByDefault = true;
        gpgPath = "gpg2";
      };
      extraConfig = {
        color.ui = "auto";
        merge.tool = "meld";
        core.editor = "vim";
        core.excludesfile = "~/.gitignore";
      };
    };

    programs.rofi = {
      enable = true;
      padding = 1;
      lines = 10;
      borderWidth = 1;
      location = "bottom";
      width = 100;
      xoffset = 0;
      yoffset = 0;
      colors = {
        window = {
          background = "#2f1e2e";
          border = "argb:36ef6155";
          separator = "argb:2fef6155";
        };
        rows = {
          normal = {
            background = "argb:a02f1e2e";
            foreground = "#b4b4b4";
            backgroundAlt = "argb:a02f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#ffffff";
            };
          };
          urgent = {
            background = "argb:272f1e2e";
            foreground = "#ef6155";
            backgroundAlt = "argb:2f2f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#ef6155";
            };
          };
          active = {
            background = "argb:272f1e2e";
            foreground = "#815ba4";
            backgroundAlt = "argb:2f2f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#815ba4";
            };
          };
        };
      };
      separator = "dash";
    };

    programs.autorandr = {
      enable = true;
      profiles = {
        "normal" = {
          fingerprint = {
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP1.enable = false;
            DP2.enable = false;
            VIRTUAL1.enable = false;
            eDP1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
        "dell_vertical" = {
          fingerprint = {
            DP1 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP2.enable = false;
            VIRTUAL1.enable = false;
            DP1 = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
              #rotate = "left";
            };
            eDP1 = {
              enable = true;
              primary = true;
              position = "0x2560";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
        "dell_horizontal" = {
          fingerprint = {
            DP1 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP2.enable = false;
            VIRTUAL1.enable = false;
            DP1 = {
              enable = true;
              mode = "2560x1440";
              position = "0x1440";
              rate = "59.95";
            };
            eDP1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
      };
    };

    home.file = {
      ".gitignore".source = ./gitignore;
      ".config/i3/i3-exit".source = ./i3/i3-exit;
      ".i3status.conf".source = ./i3/i3status.conf;
      ".bashrc".source = ./bash/bashrc;
      "pictures/wallpaper.png".source = ./wallpaper.png;
    };

    programs.home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    };

    services.screen-locker = {
      enable = true;
      inactiveInterval = 1;
      lockCmd = "/home/tuxinaut/.config/i3/i3-exit lock";
    };

    services.dunst = {
      enable = true;
    };

    services.network-manager-applet = {
      enable = true;
    };

    services.blueman-applet = {
      enable = true;
    };

    services.parcellite = {
      enable = true;
    };

    services.redshift = {
      enable = true;
      tray = true;
      latitude = "53.551086";
      longitude = "9.993682";
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
    };
}
