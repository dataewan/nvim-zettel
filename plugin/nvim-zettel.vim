if exists("g:loaded_nvimzettel")
    finish
endif
let g:loaded_nvimzettel = 1

command! -nargs=1 NewZettel lua require"nvim-zettel".NewZettel(<f-args>)
command! -nargs=1 RelatedZettel lua require"nvim-zettel".RelatedZettel(<f-args>)
