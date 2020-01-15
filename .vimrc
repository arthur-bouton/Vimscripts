"" Propriétés ""{{{

" Racine "
let s:root_dir='~/.vim'

" Alarme "
"set noerrorbells visualbell t_vb=
"autocmd GUIEnter * set visualbell t_vb=

" Curseur "
set guicursor+=a:blinkon0
"set guicursor+=a:blinkwait400

" Affichage "
set number
set hidden
set statusline=%r%m\ %<%F\ %y%h%w%{LangFlag()}%{ListFlag()}%=\ %l\ /%L\ %c%V\ %P
set laststatus=2
set hlsearch
set listchars=tab:>\ ,trail:.,extends:>,precedes:<,nbsp:_,conceal:~
set linebreak
set nowrap

function! LangFlag()
	if exists('b:lang')
		return b:lang
	endif
	return ''
endfunction

function! ListFlag()
	if &list == 1
		return '[>.]'
	endif
	return ''
endfunction

" Indentation "
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Comportement "
set shortmess+=I
if filewritable(expand(s:root_dir.'/swap')) == 2
	execute 'set directory='.s:root_dir.'/swap'
endif
set splitright
set splitbelow
set wildmenu
set wildmode=longest,list,full
set autochdir
set virtualedit=block
set nojoinspaces

" Restore the previous cursor position when reopening a file:
augroup restore_cursor_position
	autocmd!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal! g`"' | endif
augroup end

" Remember the window position when switching buffers:
augroup remember_view
	autocmd!
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
augroup end

function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" Open help windows in a left pane:
augroup open_help_windows
	autocmd!
	autocmd FileType help wincmd L
augroup end

" Shell "
set shell=/bin/bash\ -i

""}}}

 
"" GUI ""{{{

if has('gui_running')
	set guifont=Monospace\ 12

	try
		colorscheme Mytheme
		set cursorline
	catch
	endtry

	set guioptions-=T
	set guioptions-=m

	nnoremap <F11> :if &go=~#'T'<Bar>set go-=T<Bar>el<Bar>set go+=T<Bar>en<CR>
	nnoremap <F12> :if &go=~#'m'<Bar>set go-=m<Bar>el<Bar>set go+=m<Bar>en<CR>

	set mousemodel=popup_setpos
	vmenu PopUp.Rechercher<Tab>ù ù
	nmenu PopUp.Masquer\ la\ recherche<Tab>ù ù

	vnoremap <C-S-c> "+ygv<Esc>
	inoremap <C-S-v> <Esc>"+pa
end

""}}}


"" Raccourcis Généraux ""{{{

let mapleader = 'è'

inoremap jk <Esc>

nnoremap <C-q> :qa<CR>

nnoremap <C-Tab> :tabn<CR>
nnoremap <C-S-Tab> :tabp<CR>

nnoremap <C-w>n :ene<CR>
nnoremap <C-w><C-n> :ene<CR>

nnoremap ¨ :reg<CR>
inoremap ¨ <ESC>:reg<CR>

nnoremap § :browse oldfiles<CR>

vnoremap < <gv
vnoremap > >gv

nnoremap Y y$
nnoremap <C-p> D"0p

noremap gV `[v`]

vnoremap y ygv<Esc>
vnoremap p pgv<Esc>
vnoremap P Pgv<Esc>

nnoremap ° "0
vnoremap ° "0

vnoremap ç "+ygv<Esc>
nnoremap à "+p
vnoremap à "+p

nnoremap <silent> ù :noh<CR>
vnoremap <silent> ù :<C-u>call setreg('/',getreg('*'))<Bar>set hls<CR>gv<Esc>

nnoremap <leader>r :redr!<CR>

nnoremap <silent> <space>$ :sh<CR>

nnoremap vv viw
vnoremap <silent> v <Esc>:call VisualViW()<CR>

nnoremap <silent> <F8> :call SwitchList()<CR>
inoremap <silent> <F8> <Esc>:call SwitchList()<CR>a
vnoremap <silent> <F8> <Esc>:call SwitchList()<CR>gv

nnoremap <silent> <F9> :set cursorline!<CR>
inoremap <silent> <F9> <Esc>:set cursorline!<CR>a
vnoremap <silent> <F9> <Esc>:set cursorline!<CR>gv

nnoremap <silent> <F10> :set cursorcolumn!<CR>
inoremap <silent> <F10> <Esc>:set cursorcolumn!<CR>a
vnoremap <silent> <F10> <Esc>:set cursorcolumn!<CR>gv

nnoremap <silent> g" :call EditReg()<CR>

nnoremap <silent> <space>* :call HlSearch()<CR>

nnoremap <silent> g= viW:call MathEdit()<CR>
vnoremap <silent> g= :call MathEdit()<CR>


function! VisualViW()
	if match( getreg('*'), ' \|\t\|\n' ) == -1
		if index( [ ' ', '	' ], getline('.')[getpos("'<")[2]-2] ) == -1 || index( [ ' ', '	', '' ], getline('.')[getpos("'>")[2]] ) == -1
			normal! viW
		endif
	endif
endfunction


function! SwitchList()
	if &list == 0
		set list
		echo 'Affichage des caractères spéciaux'
	else
		set nolist
		echo 'Masquage des caractères spéciaux'
	endif
endfunction


function! EditReg()
	echohl Title
	echo '-- Selectionnez un registre --'
	let s:edited_reg = nr2char(getchar())
	redraw
	if s:edited_reg != '' && s:edited_reg != ''
		echohl StatusLineNC
		execute "let input = input(' Registre @".s:edited_reg." ', '', 'custom,RegCompletion')"
		if !empty(input)
			call setreg(s:edited_reg, input)
		else
			redraw
			echohl None
			echo 'Annulé'
		endif
	else
		echohl WarningMsg | echo 'Mauvaise saisie' | echohl None
	endif
	echohl None
endfunction

function! RegCompletion(ArgLead, CmdLine, CursorPos)
	return getreg(s:edited_reg)
endfunction


" Search and highlight but don't jump to the next match:
function! HlSearch()
	echohl StatusLineNC
	let input = input(' / ', '', 'custom,SearchCompletion')
	echohl None
	if !empty(input)
		let @/=input
		call feedkeys(":set hls\<CR>:echo '/".input."'\<CR>")
	else
		redraw
		echo ''
	endif
endfunction

function! SearchCompletion(ArgLead, CmdLine, CursorPos)
	return getreg('/')
endfunction


function! MathEdit()
	let value = getreg('*')
	echohl StatusLineNC | execute "let input = input(' ".value." ')" | echohl None
	if !empty(input)
		try
			let floatdot = ''
			if value[strlen(value)-1] == '.'
				let floatdot = '.'
				let value = value[:strlen(value)-2]
				if string(str2nr(value)) != value
					throw 'floatdot'
				endif
			endif

			let powidx = match( value, '[eE]' )
			let dotidx = match( value, '\.' )
			if powidx != -1
					if dotidx == -1
						let value = value[:powidx-1].'.0'.value[powidx :]
					elseif dotidx == powidx - 1
						let value = value[:powidx-1].'0'.value[powidx :]
					endif
			endif

			let result = string(eval(value.input))
			if string(str2nr(result)) != result
				let floatdot = ''
			endif
			execute 'normal! gvs'.result.floatdot
			echo value.floatdot.input '=' result.floatdot
		catch
			redraw
			echohl ErrorMsg | echo 'Opération invalide :' value.input | echohl None
		endtry
	else
		normal! gv
	endif
endfunction

""}}}


"" Déplacements ""{{{

nnoremap <C-j> 3j
nnoremap <C-k> 3k
nnoremap <C-h> 10h
nnoremap <C-l> 10l

inoremap <C-j> <Esc>gEa
inoremap <C-k> <Esc>Ea
inoremap <C-h> <Esc>I
inoremap <C-l> <Esc>A

nnoremap <Space><Space> :marks<CR>
nnoremap <Space> `
nnoremap £ [`
nnoremap µ ]`
nnoremap <Space><BS> :Delmark<CR>

command! Delmark call Delmark()

function Delmark()
	marks
	echohl Title | echo '-- Selectionnez une marque à supprimer --' | echohl None
	let char = nr2char(getchar())
	if char == '' || char == ' ' || char == '' || char == ''
		redraw
		echo 'Annulé'
		return
	endif
	try
		execute 'delmarks' char
		redraw
		echo 'Marque' char 'supprimée'
	catch
		redraw
		echo 'Mauvaise saisie !'
	endtry
endfunction

""}}}


"" Fenêtres ""{{{

nnoremap <C-Left> <C-w><
nnoremap <C-Right> <C-w>>
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-

""}}}


"" Undo ""{{{

if filewritable(expand(s:root_dir.'/undo')) == 2
	set undofile
	execute 'set undodir='.s:root_dir.'/undo'
endif

inoremap <C-_> <C-o>u

" Define keys that start a new undoable edit:
inoremap <Space> <Space><C-g>u
inoremap <CR> <C-g>u<CR>
inoremap <C-r> <C-g>u<C-r>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

command! ClearUndo call ClearUndo()

function! ClearUndo()
	call delete(undofile(@%))
	let old_undolevels = &undolevels
	set undolevels=-1
	execute 'normal! a '
	let &undolevels = old_undolevels
	unlet old_undolevels
endfunction

""}}}


"" Gestion des Tampons ""{{{

nnoremap <Space><Tab> :ls<CR>

nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

nnoremap <C-s> :Bv<CR>

nnoremap <C-w>b :bd<CR>
nnoremap <C-w><C-b> :bd<CR>

command! -bang Bvanish call VanishBuffer(<bang>0)

command! -bang DeleteHiddenBufs call DeleteHiddenBufs(<bang>0)

command! -bang -nargs=1 -complete=file SaveAs call SaveAs(<bang>0, '<args>')

function! VanishBuffer(bang)
	let present_buffer_nb = bufnr('%')
	if !a:bang && getbufvar(present_buffer_nb, '&mod')
		let present_buffer_name = bufname(present_buffer_nb)
		if !empty(present_buffer_name)
			echohl WarningMsg | echo  present_buffer_name 'a été modifié (ajouter ! pour passer outre)' | echohl None
		else
			echohl WarningMsg | echo  'Le tampon' present_buffer_nb "n'a pas été enregistré (ajouter ! pour passer outre)" | echohl None
		endif
	else
		let present_window = winnr()
		for window in range(1, winnr('$'))
			if winbufnr(window) == present_buffer_nb
				execute window.'wincmd w'
				bprevious
			endif
		endfor
		execute present_window.'wincmd w'
		execute 'bdelete!' present_buffer_nb
	endif
endfunction

function! DeleteHiddenBufs(bang)
    let active_windows = []
    for tab in range(1, tabpagenr('$'))
        call extend(active_windows, tabpagebuflist(tab))
    endfor

    let nDeleted = 0
    for buf in range(1, bufnr('$'))
        if buflisted(buf) && index(active_windows, buf) == -1
			if !a:bang && getbufvar(buf, '&mod')
				let buffer_name = bufname(buf)
				if !empty(buffer_name)
					echohl WarningMsg | echo buffer_name 'a été modifié : suppression annulée (ajouter ! pour passer outre)' | echohl None
				else
					echohl WarningMsg | echo 'Le tampon' buf "n'a pas été enregistré : suppression annulée (ajouter ! pour passer outre)" | echohl None
				endif
			else
				execute 'bdelete!' buf
				let nDeleted += 1
			endif
        endif
    endfor

	if nDeleted > 1
		echomsg nDeleted 'tampons supprimés'
	else
		echomsg nDeleted 'tampon supprimé'
	endif
endfunction

function! SaveAs(bang, newfile)
    if !a:bang && !empty(glob(a:newfile))
        echohl ErrorMsg | echo 'Le fichier' a:newfile 'existe déjà (ajouter ! pour passer outre)' | echohl None
    else
        execute 'write!' a:newfile
        execute 'edit' a:newfile
        execute 'bdelete! #'
    endif
endfunction

""}}}


"" Gestion des Sessions ""{{{

set sessionoptions=curdir,buffers,winsize,folds,blank,help,tabpages,options,localoptions,globals

let g:sessions_path = s:root_dir.'/sessions/'
let g:default_session = '.latest'
let s:current_session = g:default_session

augroup autosave_session
	autocmd!
	autocmd VimLeave * execute 'mksession!' g:sessions_path.g:default_session
augroup end

command! RestoreSession call RestoreSession()
command! -bang -nargs=* -complete=customlist,FileCompletion NewSession call NewSession(<bang>0, '<args>')
command! SaveSession call SaveSession()
command! -nargs=1 -complete=customlist,FileCompletion OverwriteSession call OverwriteSession('<args>')
command! -nargs=1 -complete=customlist,FileCompletion OpenSession call OpenSession('<args>')
command! -nargs=+ -complete=customlist,FileCompletion DeleteSession call DeleteSession('<args>')

function! RestoreSession()
    if !empty(globpath(g:sessions_path, g:default_session))
        execute 'source' g:sessions_path.g:default_session
    else
        echohl ErrorMsg | echo 'Aucune session à restorer' | echohl None
    endif
endfunction

function! NewSession(bang, session_name)
	if empty(a:session_name)
		let modbufs = []
		for buf in range(1, bufnr('$'))
			if buflisted(buf) && getbufvar(buf, '&mod')
				call add(modbufs, buf)
			endif
		endfor
		if empty(modbufs) || a:bang == 1
			for buf in range(1, bufnr('$'))
				if bufexists(buf)
					execute 'bdelete!' buf
				endif
			endfor
			execute 'mksession!' g:sessions_path.g:default_session
			if s:current_session ==# g:default_session
				echo "Aucune session particulière n'était ouverte"
			else
				echomsg 'Session' s:current_session 'fermée'
				let s:current_session = g:default_session
			endif
		else
			if len(modbufs) == 1
				echohl WarningMsg | echo 'Le tampon' join(modbufs) 'a été modifié (ajouter ! pour passer outre)' | echohl None
			else
				echohl WarningMsg | echo 'Les tampons' join(modbufs, ', ') 'ont été modifiés (ajouter ! pour passer outre)' | echohl None
			endif
		endif
	else
		if empty(globpath(g:sessions_path, a:session_name))
			execute 'mksession' g:sessions_path.a:session_name
			redraw
			echomsg 'Session' a:session_name 'créée'
			let s:current_session = a:session_name
		else
			echohl ErrorMsg | echo 'La session' a:session_name 'existe déjà (ajouter ! pour passer outre)' | echohl None
		endif
	endif
endfunction

function! SaveSession()
    if s:current_session !=# g:default_session && !empty(globpath(g:sessions_path, s:current_session))
        execute 'mksession!' g:sessions_path.s:current_session
		redraw
        echomsg 'Session' s:current_session 'enregistrée'
    else
        echohl ErrorMsg | echo "La session en cours n'a pas été créée : utilisez 'NewSession' pour en créer une" | echohl None
    endif
endfunction

function! OverwriteSession(session_name)
    if !empty(globpath(g:sessions_path, a:session_name))
        execute 'mksession!' g:sessions_path.a:session_name
		redraw
        echomsg 'Session' a:session_name 'écrasée'
        let s:current_session = a:session_name
    else
        echohl ErrorMsg | echo 'La session' a:session_name "n'existe pas" | echohl None
    endif
endfunction

function! OpenSession(session_name)
    if !empty(globpath(g:sessions_path, a:session_name))
        execute 'source' g:sessions_path.a:session_name
        let s:current_session = a:session_name
    else
        echohl ErrorMsg | echo 'La session' a:session_name "n'existe pas" | echohl None
    endif
endfunction

function! DeleteSession(session_name)
	for session in split(a:session_name)
		if !empty(globpath(g:sessions_path, session))
			call delete(expand(g:sessions_path.session))
			if session ==# s:current_session
				let s:current_session = g:default_session
			endif
			redraw
			echomsg 'Session' session 'supprimée'
		else
			echohl ErrorMsg | echo 'La session' session "n'existe pas" | echohl None
		endif
	endfor
endfunction

function! FileCompletion(ArgLead, CmdLine, CursorPos)
    return map(split(globpath(g:sessions_path, '*'.a:ArgLead.'*'), '\n'), "fnamemodify(v:val, ':t')")
endfunction

""}}}


"" Explorateur de fichiers ""{{{

let g:netrw_bufsettings = 'noma nomod nonu nowrap ro bl'
let g:netrw_liststyle = 2
let g:netrw_winsize = 30
let g:netrw_browsex_viewer = 'kde-open'

""}}}


"" Fichiers Textes ""{{{

nnoremap <buffer> !I (a
nnoremap <buffer> !A :call Appendtext()<CR>a

nnoremap <buffer> !yy (y)
nnoremap <buffer> !dd (d)
nnoremap <buffer> !Y y)
nnoremap <buffer> !D d)
nnoremap <buffer> !C c)
nnoremap <buffer> !S (c)

augroup text_mode
	autocmd!
	autocmd FileType text call Load_text_mode()
augroup end

function! Load_text_mode()
	setlocal wrap linebreak nolist

	nnoremap <buffer> j gj
	nnoremap <buffer> k gk
	nnoremap <buffer> <Down> gj
	nnoremap <buffer> <Up> gk
	nnoremap <buffer> 0 g0
	nnoremap <buffer> ^ g^
	nnoremap <buffer> $ g$

	inoremap <buffer> <C-h> <Esc>(a
	inoremap <buffer> <C-l> <Esc>:call Appendtext()<CR>a
	
	inoremap <buffer> <C-u> <C-g>u<C-o>d(
endfunction

function! Appendtext()
	let initpos = getpos('.')
	normal! 2l
	if getpos('.')[2] == initpos[2]
		normal! +
	endif
	let initpos = getpos('.')
	normal! )
	if getpos('.')[1] != initpos[1]
		call setpos('.', initpos)
		normal! $
	elseif getpos('.')[1] != line('$') && getpos('.')[2] != strlen(getline('.'))
		normal! 2h
	endif
endfunction

""}}}


"" IDE ""{{{

set iskeyword+=:

set foldlevelstart=99

augroup ide_config
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker | set foldmarker={{{,}}}
	autocmd FileType python setlocal foldmethod=indent
	autocmd FileType python nnoremap gt oimport pdb; pdb.set_trace()<esc>
	"Ignore boost librairies for autocompletion:
	autocmd FileType c,cpp,sh,arduino setlocal include=^\\s*#\\s*include\ \\(<boost/\\)\\@!
	autocmd FileType c,cpp,sh,arduino setlocal foldmethod=marker | set foldmarker={,}
	autocmd FileType c,cpp,arduino set iskeyword+=:
	autocmd FileType tex setlocal foldmethod=marker

	autocmd FileType vim let b:comment_char = '"'
	autocmd FileType sh,python,conf,make,cmake let b:comment_char = '#'
	autocmd FileType c,cpp,arduino let b:comment_char = '//'
	autocmd FileType tex,plaintex,matlab let b:comment_char = '%'
	autocmd FileType lua let b:comment_char = '--'
augroup end

nnoremap <silent> é :call SwitchComment(1)<CR>
vnoremap <silent> é :call SwitchComment(0)<CR>gv<Esc>
nnoremap <silent> <leader>f :call Format()<CR>
vnoremap <silent> <leader>f :call Format()<CR>gv<Esc>

command! -range Comment <line1>,<line2> call Comment()
command! -range UnComment <line1>,<line2> call UnComment()
command! -range Format <line1>,<line2> call Format()

function! SwitchComment(pos)
	if exists('b:comment_char')
		if a:pos == 1
			let window_view = winsaveview()
		endif
		normal! ^
		if !empty(getline('.')) && getline('.')[col('.')-1:col('.')-2+strlen(b:comment_char)] != b:comment_char
			execute 'normal! i'.b:comment_char
		else
		execute 'normal!' strlen(b:comment_char).'x'
		endif
		if a:pos == 1
			call winrestview(window_view)
		endif
	else
        echohl ErrorMsg | echo "Aucun caractère n'a été défini pour les commentaires de ce type de fichier" | echohl None
	endif
endfunction

function! Comment()
	if exists('b:comment_char')
		normal! ^
		if getline('.')[col('.')-1:col('.')-2+strlen(b:comment_char)] != b:comment_char
			execute 'normal! i'.b:comment_char
		endif
	else
        echohl ErrorMsg | echo "Aucun caractère n'a été défini pour les commentaires de ce type de fichier" | echohl None
	endif
endfunction

function! UnComment()
	if exists('b:comment_char')
		normal! ^
		while getline('.')[col('.')-1:col('.')-2+strlen(b:comment_char)] == b:comment_char
			execute 'normal!' strlen(b:comment_char).'x'
		normal! ^
		endwhile
	else
        echohl ErrorMsg | echo "Aucun caractère n'a été défini pour les commentaires de ce type de fichier" | echohl None
	endif
endfunction

function! Format()
	normal! ^
	while search('(\|,', 'c', line('.'))
		if getline('.')[col('.')-1:col('.')] == '()'
			normal! l
			continue
		endif
		while getline('.')[col('.')] == ' '
			normal! lxh
		endwhile
		if col('.') == strlen(getline('.'))
			break
		endif
		normal! a 
	endwhile

	normal! ^
	while search(')', '', line('.'))
		if getline('.')[col('.')-2:col('.')-1] == '()'
			continue
		endif
		while getline('.')[col('.')-2] == ' '
			normal! hx
		endwhile
		normal! i l
	endwhile
endfunction

""}}}


"" LaTeX ""{{{

augroup latex_mode
	autocmd!
	autocmd FileType tex,plaintex call Load_latex_mode()
augroup end

function! Load_latex_mode()

	let s:auxdir = 'auxfiles'

	call Load_text_mode()

	if filereadable(expand(s:root_dir.'/syntax/latex.vim'))
		set syntax=latex
	endif

	execute 'setlocal complete+=k'.s:root_dir.'/syntax/latex_keywords/text_keywords.txt'
	execute 'setlocal complete+=k'.s:root_dir.'/syntax/latex_keywords/math_keywords.txt'
	setlocal iskeyword+=\

    command! -bang -nargs=? -complete=file PdfLatex call PdfLatex(<bang>0, '<args>')
    command! -bang -nargs=? -complete=file PdfLatexBib call PdfLatexBib(<bang>0, '<args>')
    command! -bang -nargs=? -complete=file PdfLatexNom call PdfLatexNom(<bang>0, '<args>')

    function! PdfLatex(bang, rootfile)
        if !empty(a:rootfile)
            let file = a:rootfile
        else
            let file = @%
        endif
		let root = join(split(file, '/', 1)[:-2], '/')
		if empty(root)
			let root = '.'
		endif
		let root = root.'/'

		let pdflatex_cmd = '!cd '.root.'&& mkdir -p '.s:auxdir.'&& pdflatex -output-directory '.s:auxdir.' '.file
		                 \.'&& mv '.s:auxdir.'/$(basename '.file.' .tex).pdf .'
        if a:bang
            execute pdflatex_cmd '&&' g:netrw_browsex_viewer root.'$(basename' file '.tex).pdf'
		else
            execute pdflatex_cmd
        endif
    endfunction

    function! PdfLatexBib(bang, rootfile)
        if !empty(a:rootfile)
            let file = a:rootfile
        else
            let file = @%
        endif
		let root = join(split(file, '/', 1)[:-2], '/')
		if empty(root)
			let root = '.'
		endif
		let root = root.'/'

		let pdflatex_cmd = ' && pdflatex -output-directory '.s:auxdir.' '.file
		let bibtex_cmd = '!cd '.root.'&& mkdir -p '.s:auxdir.'&& rm -f '.s:auxdir.'*.bbl'.pdflatex_cmd
		               \.'&& bibtex '.s:auxdir.'/$(basename '.file.' .tex)'.pdflatex_cmd.pdflatex_cmd
		               \.'&& mv '.s:auxdir.'/$(basename '.file.' .tex).pdf .'
        if a:bang
            execute bibtex_cmd '&&' g:netrw_browsex_viewer root.'$(basename' file '.tex).pdf'
		else
            execute bibtex_cmd
        endif
    endfunction

    function! PdfLatexNom(bang, rootfile)
        if !empty(a:rootfile)
            let file = a:rootfile
        else
            let file = @%
        endif
		let root = join(split(file, '/', 1)[:-2], '/')
		if empty(root)
			let root = '.'
		endif
		let root = root.'/'

		let pdflatex_cmd = '!cd '.root.'&& mkdir -p '.s:auxdir.'&& makeindex '.s:auxdir.'/$(basename '.file.' .tex).nlo -s nomencl.ist -o '.s:auxdir.'/$(basename '.file.' .tex).nls'
		                 \.'&& pdflatex -output-directory '.s:auxdir.' '.file
		                 \.'&& mv '.s:auxdir.'/$(basename '.file.' .tex).pdf .'
        if a:bang
            execute pdflatex_cmd '&&' g:netrw_browsex_viewer root.'$(basename' file '.tex).pdf'
		else
            execute pdflatex_cmd
        endif
    endfunction

	nnoremap <buffer> gl :call LatexLayout()<CR>

	nnoremap <buffer> gn /<??><CR>vf>o
	vnoremap <buffer> gn <Esc>/<??><CR>vf>o
	inoremap <buffer> <C-g>n <Esc>/<??><CR>vf>o
	inoremap <buffer> <C-g><C-n> <Esc>/<??><CR>vf>o

	nnoremap <buffer> gp ?<\?\?><CR>vf>o
	vnoremap <buffer> gp <Esc>?<\?\?><CR>vf>o
	inoremap <buffer> <C-g>p <Esc>?<\?\?><CR>vf>o
	inoremap <buffer> <C-g><C-p> <Esc>?<\?\?><CR>vf>o

	let s:latex_layouts = {
	\'document': '\begin{document}	\end{document}k',
	\'figure': '\begin{figure}	\centering\includegraphics[width=\textwidth]{<??>}\caption{<??>}\label{<??>}\end{figure}3-f<vf>o',
	\'equation': '\begin{equation}	\end{equation}k',
	\'system': '\left\lbrace \begin{array}{l}	<??> \\<??>\end{array} \right.2-f<vf>o',
	\'vector': '\left| \begin{array}{c} <??> \\ <??> \end{array} \right.0f<vf>o',
	\'itemize': '\begin{itemize}	\item \end{itemize}k$',
	\'myitem': '\newcommand{\myitem}{\item[$\bullet$]}',
    \'itemize spaced': '\begin{itemize}\setlength{\itemsep}{\baselineskip}\renewcommand{\labelitemi}{$\bullet$}	\item \end{itemize}k$',
    \'tableofcontents': '\renewcommand{\contentsname}{<??>}\tableofcontents2-f<vf>o',
	\'subfigure': '\begin{figure}	\centering\subfigure[<??>]{	\includegraphics[width=.45\textwidth]{<??>}\label{<??>}}\subfigure[<??>]{	\includegraphics[width=.45\textwidth]{<??>}\label{<??>}}\caption{<??>}\end{figure}9-f<vf>o',
	\'matrix33': '\left( \begin{array}{ccc}	<??> & <??> & <??> \\<??> & <??> & <??> \\<??> & <??> & <??>\end{array} \right)3-vf>o',
	\'matrix22': '\left( \begin{array}{cc}	<??> & <??> \\<??> & <??>\end{array} \right)2-vf>o',
	\'table': '\begin{table}\renewcommand{\arraystretch{1.5}}	\centering\begin{tabular}{|c|c|c|}	\hline<??> & <??> & <??> \\\hline<??> & <??> & <??> \\\hline\end{tabular}\caption{<??>}\label{<??>}\end{table}7-vf>o',
	\'multicolumn': '\multicolumn{2}{|c|}{<??>} & <??> \\\hline-f<vf>o',
	\'multirow': '<??> & \multirow{2}*{<??>} & <??> \\\cline{1-1} \cline{3-3}<??> && <??> \\\hline3-f<vf>o',
	\'frame': '\begin{frame}	\frametitle{<??>}\framesubtitle{<??>}\end{frame}3-f<vf>o',
	\'minipage': '\begin{minipage}	\centering\end{minipage}k',
	\'includegraphics': '\includegraphics[width=<??>\textwidth]{<??>}0f<vf>o',
	\'center': '\begin{center}	\end{center}k',
	\'vspace': '\vspace{\baselineskip}',
	\}

	function! LatexLayout()
		echohl StatusLineNC
		let input = input(' LaTeX ', '', 'customlist,LatexCompletion')
		if !empty(input)
			if has_key(s:latex_layouts, input)
				execute 'normal! o'.s:latex_layouts[input]
			else
				redraw
				echohl WarningMsg
				echo "Pas d'entrée pour" input
			endif
		endif
		echohl None
	endfunction

	function! LatexCompletion(ArgLead, CmdLine, CursorPos)
		let layouts = keys(s:latex_layouts)
		if len(a:ArgLead) == 0
			return layouts
		else
			let entries = []
			for layout in layouts
				if layout[0:len(a:ArgLead)-1] ==? a:ArgLead
					call add(entries, layout)
				endif
			endfor
			return entries
		endif
	endfunction

	nnoremap <buffer><silent> va$ :call VaMathBack()<CR>
	nnoremap <buffer><silent> ya$ m`:call VaMathBack()<CR>y``:echo @"<CR>

	nnoremap <buffer><silent> vi$ :call ViMath()<CR>
	nnoremap <buffer><silent> yi$ m`:call ViMath()<CR>y``:echo @"<CR>
	nnoremap <buffer><silent> ci$ :call ViMath()<CR>c

	function! VaMathBack()
		if search('\$', 'bc', line('.')) != 0
			if search('\$', '', line('.')) != 0
				normal! vF$o
			elseif search('\$', 'b', line('.')) != 0
				normal! vf$
			endif
		endif
	endfunction

	function! ViMath()
		if search('\$', 'c', line('.')) != 0
			if search('\$', 'b', line('.')) != 0
				normal! lvt$
			elseif search('\$', '', line('.')) != 0
				normal! hvT$o
			endif
		endif
	endfunction

endfunction

""}}}


"" Correction Orthographique ""{{{

nnoremap <F6> :SpellEn<CR>
nnoremap <F7> :SpellFr<CR>

inoremap <F6> <Esc>:SpellEn<CR>a
inoremap <F7> <Esc>:SpellFr<CR>a

command! SpellFr call SpellFr()
command! SpellEn call SpellEn()

let g:languagetool_jar = '~/Bin/LanguageTool-3.0/languagetool-commandline.jar'

function! SpellFr()
	if &spell==0 || &spelllang!='fr'
		setlocal spelllang=fr spell
		echo 'Correction orthographique française activée'
		let b:lang = '[fr]'
	else
		setlocal nospell
		echo 'Correction orthographique désactivée'
		let b:lang = ''
	endif
endfunction

function! SpellEn()
	if &spell==0 || &spelllang!='en'
		setlocal spelllang=en spell
		echo 'Correction orthographique anglaise activée'
		let b:lang = '[en]'
	else
		setlocal nospell
		echo 'Correction orthographique désactivée'
		let b:lang = ''
	endif
endfunction

""}}}


"" Coloration Syntaxtique ""{{{

nmap <F5> :call SynStack()<CR>

function! SynStack()
	if exists('*synstack')
		echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	endif
endfunction

""}}}


"" Git ""{{{

" Open a previous git version of the current file:
command! -nargs=? GitShow silent call GitShow('<args>')

function! GitShow(rev)
	if !empty(a:rev)
		let rev = a:rev
	else
		let file = '@'
	endif

	let file = @%
	let pos = getpos('.')
	let wd = getcwd()
	execute 'edit /tmp/'.rev.':'.expand('%:t')

	execute 'cd' wd
	execute 'read !git show' rev.':./'.file
	normal ggdd
	call setpos('.', pos)
endfunction

" Syntax highlighting for git:
augroup git_syntax
    autocmd!
	"autocmd Syntax * hi gitChunkMarker ctermfg=17 ctermbg=214 cterm=NONE guifg=#232a32 guibg=#ffb20d gui=NONE
	"autocmd Syntax * hi gitChunkRef ctermfg=214 ctermbg=17 cterm=NONE guifg=#ffb20d guibg=#232a32 gui=NONE
	autocmd Syntax * hi gitChunkMarker ctermfg=214 ctermbg=17 cterm=NONE guifg=#ffb20d guibg=#232a32 gui=NONE
	autocmd Syntax * hi gitChunkRef ctermfg=202 ctermbg=17 cterm=NONE guifg=#ff410d guibg=#232a32 gui=NONE

	autocmd Syntax * syntax region gitChunkRef matchgroup=gitChunkMarker start='\(^<<<<<<<\|^>>>>>>>\) ' end='$' containedin=ALL extend
	autocmd Syntax * syntax match gitChunkMarker '^=======$' containedin=ALL extend
augroup end
set syntax+=

""}}}


"" FZF ""{{{

set rtp+=~/.fzf

nnoremap <space>! :History<CR>
nnoremap <space>: :BLines<CR>
nnoremap <leader>e :FZF 
nnoremap <leader>g :GitFiles<CR> 

""}}}


"" Tabular ""{{{

augroup tabular_config
	autocmd!
	autocmd FileType * if exists(':AddTabularPattern') == 2 | call AllTypeTabPattern() | endif
augroup end

function! AllTypeTabPattern()
	AddTabularPattern! align_last /\S*$
endfunction

""}}}
