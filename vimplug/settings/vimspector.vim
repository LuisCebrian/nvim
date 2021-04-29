let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = ['debugpy']

nmap <A-down> <Plug>VimspectorStepInto
nmap <A-right> <Plug>VimspectorStepOver
nmap <A-up> <Plug>VimspectorStepOut
