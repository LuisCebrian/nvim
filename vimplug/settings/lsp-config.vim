" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

autocmd CursorHold *.py :silent! lua vim.lsp.buf.document_highlight()
autocmd CursorMoved *.py :silent! lua vim.lsp.buf.clear_references()

call sign_define('LspDiagnosticsSignError',       { 'text': "", 'texthl': 'LspDiagnosticsSignError'       })
call sign_define('LspDiagnosticsSignWarning',     { 'text': "", 'texthl': 'LspDiagnosticsSignWarning'     })
call sign_define('LspDiagnosticsSignInformation', { 'text': "", 'texthl': 'LspDiagnosticsSignInformation' })
call sign_define('LspDiagnosticsSignHint',        { 'text': "", 'texthl': 'LspDiagnosticsSignHint'        })
