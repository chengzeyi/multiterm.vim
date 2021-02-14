# Multiterm

Toggle and Switch Between Multiple Floating Terminals in NeoVim and Vim.

## Introduction

Some plugins have already provided the functionality to create a floating terminal window in NeoVim or Vim. But they only support one running instance, or they just cannot allow you to put the terminal session into background. And some of them are too complicated to use.

You might often need to open several terminal sessions in Vim. Let's suppose you need to create 2 terminal sessions, one for running tests and the other one for compiling. It is painful to switch between them as you have to switch between Vim modes and use tab or window switching commands.

With **Multiterm**, all pains just go off. You could use one single command `:Multiterm` and mapping `<Plug>(Multiterm)` with **count** to **create**, **hide** and **display** the floating terminal window you want.

## Screenshot

![Screenshot](https://i.postimg.cc/d0s17Pmn/2021-02-14-14-02-23.png)

## Prerequisites

Running `:echo has('nvim-0.4.0') || has('patch-8.2.191')` prints `1`, which means that you have at least version 0.4.0 of NeoVim or version 8.2.191 of Vim.

And you must have `:terminal` command. That is, running `:echo exists(':terminal')` prints `1`.

## Installation

If you use `vim-plug` as your plugin manager:

```viml
if exists(':terminal')
    if has('nvim-0.4.0') || has('patch-8.2.191')
        Plug 'chengzeyi/multiterm.vim'
    endif
endif
```

## Usage

If you do not have any floating terminal instance, run `:Multiterm [cmd]` will create a floating terminal with tag `1`. It is not suggested to run a non-interactive `cmd` as the terminal session will end and get destroyed as soon as `cmd` finishes if run `:Multiterm` without `!`.

If your cursor is in a floating terminal window, run `:Multiterm` will close that window and put the terminal session into background. Otherwise the **most recently used** floating terminal instance will be activated.

If you run `:3Multiterm` and do not have a floating terminal with tag `3` created, a new floating terminal window with tag `3` will be created and become the current active floating window.

If your tag `3` floating terminal is in the background, run `:3Multiterm` will put the session into foreground. You could then run `:Multiterm` to close the window and put it into background again.

## Commands & Mappings

A single command is provided:

```viml
:[count]Multiterm[!] [cmd]
```

- `[count]` could be a number between 1 and 9 and is the tag of the floating window that you want to activate. If it is not specified, the current active floating terminal session will be closed, or the tag `1` session will be activated in the condition that there is no active session.
- `[!]` forces the terminal window not to close when the terminal job exits. Otherwise, in NeoVim the window will be closed as immediately as the job exits with a zero exit code, and in Vim the window will be closed when the job is finished.
- `[cmd]` is the optional command to run. if not specified, the current `shell` option value will be used.

Mappings are provided to smooth the operation of toggling floating terminals and are the **SUGGESTED** way to use instead of the command. Using these mappings are just like run `:Multiterm` without any additional argument.

```viml
" Put the following lines in your configuration file to map <F12> to use Multiterm
nmap <F12> <Plug>(Multiterm)
" In terminal mode `count` is impossible to press, but you can still use <F12>
" to close the current floating terminal window without specifying its tag
tmap <F12> <Plug>(Multiterm)
" If you want to toggle in insert mode and visual mode
imap <F12> <Plug>(Multiterm)
xmap <F12> <Plug>(Multiterm)
```

Now you could press `<F12>` to toggle the tag `1` floating terminal instance or close the current active floating terminal window that your cursor is in. And press `3<F12>` to activate the tag `3` instance, etc.

**NOTE** in terminal mode it is impossible to press a number as the tag, but you can still use `<F12>` to close the current terminal window which your cursor is in without specifying its tag.

## Configuration

```viml
" Default options, do not put this in your configuration file
let g:multiterm_opts = {
            \ 'height': 'float2nr(&lines * 0.8)',
            \ 'width': 'float2nr(&columns * 0.8)',
            \ 'row': '(&lines - height) / 2',
            \ 'col': '(&columns - width) / 2',
            \ 'border_hl': 'Comment',
            \ 'border_chars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
            \ 'show_term_tag': 1,
            \ 'term_hl': 'Normal'
            \ }
" Your configuration should start here
if !exists('g:multiterm_opts')
    let g:multiterm_opts = {}
endif
" This option has a string value instead of number because it is uesd for eval()
let g:multiterm_opts.height = '30'
...
```

Refer to the doc file for a more detailed explanation.

## Thanks

This plugin is inspired by `Lenovsky/nuake`, a Quake style terminal panel for NeoVim and Vim.
