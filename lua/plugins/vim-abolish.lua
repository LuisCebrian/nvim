return {
    "tpope/vim-abolish",
    event = "BufReadPost",
    config = function()
        -- Usamos vim.cmd con corchetes dobles para escribir Vimscript puro.
        -- Esto asegura que las funciones se registren como Funcref y no como Strings.
        vim.cmd([[
            " 1. Definimos las funciones auxiliares en Vimscript local (s:)
            function! s:spacecase(word)
                let word = substitute(a:word, '\C\(\u\)', '_\1', 'g')
                let word = substitute(word, '_\+', '_', 'g')
                let word = substitute(word, '^_', '', '')
                return substitute(tolower(word), '_', ' ', 'g')
            endfunction

            function! s:titlecase(word)
                let word = s:spacecase(a:word)
                return substitute(word, '\(\<\w\)', '\=toupper(submatch(1))', 'g')
            endfunction

            " 2. Configuramos el diccionario de Coercions
            let g:Abolish = get(g:, 'Abolish', {})
            if !has_key(g:Abolish, 'Coercions')
                let g:Abolish.Coercions = {}
            endif

            " 3. Asignamos usando function(), esto crea el tipo de dato correcto (Funcref)
            let g:Abolish.Coercions[" "] = function('s:spacecase')
            let g:Abolish.Coercions.t   = function('s:titlecase')
        ]])
    end,
}
