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
set nocompatible
set viminfo='200,<1000,s100,h,!
set shortmess+=I
if filewritable(expand(s:root_dir.'/swap')) == 2 | execute 'set directory='.s:root_dir.'/swap' | endif
set splitright
set splitbelow
set wildmenu
set wildmode=longest,list,full
set virtualedit=block
set nojoinspaces
"set autochdir
augroup update_local_directory
	autocmd!
	autocmd BufEnter * silent! lcd %:p:h
augroup end
autocmd FileType netrw setl bufhidden=wipe

" Restore the previous cursor position when reopening a file:
augroup restore_cursor_position
	autocmd!
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal! g`"' | endif
augroup end

" Remember the window position when switching buffers:
augroup remember_view
	autocmd!
    autocmd BufLeave * call s:AutoSaveWinView()
    autocmd BufEnter * call s:AutoRestoreWinView()
augroup end

function! s:AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

function! s:AutoRestoreWinView()
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

	vnoremap <C-S-c> "+ygv<ESC>
	inoremap <C-S-v> <ESC>"+pa
end

""}}}


"" Raccourcis Généraux ""{{{

let mapleader = 'è'

inoremap jk <ESC>

nnoremap <C-q> :qa<CR>

nnoremap <C-w>t :tabnew<Bar>Bv<CR>
nnoremap <C-w>C :tabclose<CR>
nnoremap <C-Tab> :tabn<CR>
nnoremap <C-S-Tab> :tabp<CR>

nnoremap <C-w>n :enew<CR>
nnoremap <C-w><C-n> :enew<CR>

nnoremap ¨ :reg<CR>
inoremap ¨ <ESC>:reg<CR>

nnoremap § :browse oldfiles<CR>

vnoremap < <gv
vnoremap > >gv

vnoremap y ygv<ESC>
vnoremap p pgv<ESC>
vnoremap P Pgv<ESC>

nnoremap Y y$
nnoremap <C-p> D"0p

nnoremap vil _vg_
nnoremap val 0vg_
nnoremap yil _yg_
nnoremap yal 0yg_

nnoremap <C-o> o<ESC>

noremap gV `[v`]

nnoremap ° "0
vnoremap ° "0

vnoremap ç "+ygv<ESC>
nnoremap à "+p
vnoremap à "+p

nnoremap <silent> ù :noh<CR>
vnoremap <silent> ù :<C-u>call setreg('/',getreg('*'))<Bar>set hls<CR>gv<ESC>

" Complete with file and directory names if the previous character is '/':
inoremap <expr> <C-Space> getline('.')[col('.')-2] == '/' ? '<C-x><C-f>' : '<Space>'

" Tags:
nnoremap <leader>t <C-]>
nnoremap g<leader>t g<C-]>
inoremap <C-x><leader>t <C-x><C-]>

nnoremap <leader>l :redraw!<CR>

nnoremap <silent> <space>$ :sh<CR>

nnoremap <leader>b _i# <End> #<ESC>YP<C-v>j$r#p$
nnoremap <leader>- _i// <End> //<ESC>YPll<C-v>jg_hhr-p$

nnoremap vv viw
vnoremap <silent> v <ESC>:call VisualViW()<CR>

vnoremap <silent> <C-i> <ESC>:call BracketMode()<CR>

nnoremap <silent> zh :call HorizontalScrollMode('h')<CR>
nnoremap <silent> zl :call HorizontalScrollMode('l')<CR>
nnoremap <silent> zH :call HorizontalScrollMode('H')<CR>
nnoremap <silent> zL :call HorizontalScrollMode('L')<CR>

nnoremap <silent> <F8> :call SwitchList()<CR>
inoremap <silent> <F8> <ESC>:call SwitchList()<CR>a
vnoremap <silent> <F8> <ESC>:call SwitchList()<CR>gv

nnoremap <silent> <F9> :set cursorline!<CR>
inoremap <silent> <F9> <ESC>:set cursorline!<CR>a
vnoremap <silent> <F9> <ESC>:set cursorline!<CR>gv

nnoremap <silent> <F10> :set cursorcolumn!<CR>
inoremap <silent> <F10> <ESC>:set cursorcolumn!<CR>a
vnoremap <silent> <F10> <ESC>:set cursorcolumn!<CR>gv

nnoremap <silent> g" :call EditReg()<CR>

nnoremap <silent> <space>* :call HlSearch()<CR>

nnoremap <silent> g= viW:call MathEdit()<CR>
vnoremap <silent> g= :call MathEdit()<CR>

nnoremap <silent> <F1> :call FindCursor()<CR>
inoremap <silent> <F1> <ESC>:call FindCursor()<CR>a


function! FindCursor()
	if ! &cursorline || ! &cursorcolumn
		let s:cursorline_prev_state = &cursorline
		let s:cursorcolumn_prev_state = &cursorcolumn
		set cursorline
		set cursorcolumn
		hi CursorLine ctermfg=NONE ctermbg=17 cterm=NONE guifg=NONE guibg=#232a32 gui=NONE
	else
		let &cursorline = s:cursorline_prev_state
		let &cursorcolumn = s:cursorcolumn_prev_state
		hi CursorLine ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
	endif
endfunction


function! VisualViW()
	if match( getreg('*'), '[ \t\n]' ) == -1
		if index( [ ' ', '	', '' ], getline('.')[getpos("'<")[2]-2] ) == -1 || index( [ ' ', '	', '' ], getline('.')[getpos("'>")[2]] ) == -1
			normal! viW
		endif
	endif
endfunction


function! HorizontalScrollMode( call_char )
	if &wrap
		return
	endif

	echohl Title
	let typed_char = a:call_char
	while index( [ 'h', 'l', 'H', 'L' ], typed_char ) != -1
		execute 'normal! z'.typed_char
		redraws
		echon '-- Horizontal scrolling mode (h/l/H/L)'
		let typed_char = nr2char(getchar())
	endwhile
	echohl None | echo '' | redraws
endfunction


function! BracketMode()
	let autoindent_config = &autoindent
	let smartindent_config = &smartindent
	let cindent_config = &cindent
	let softtabstop_config = &softtabstop
	set noautoindent
	set nosmartindent
	set nocindent
	set softtabstop=0

	let line_1 = getpos("'<")[1]
	let line_2 = getpos("'>")[1]
	let col_1 = getpos("'<")[2]
	let col_2 = ( visualmode() == 'V' ? strwidth( getline( line_2 ) ) : getpos("'>")[2] ) + 1
	let len = 0

	if getpos('.')[2] == getpos("'>")[2] || visualmode() == 'V' && getpos('.')[1] == line_2
		let left = 0
		let cursor_line = line_2
		let cursor_col = col_2
	else
		let left = 1
		let cursor_line = line_1
		let cursor_col = col_1
	endif

	let orig_cursor_line = cursor_line
	let orig_line_1 = line_1
	let orig_col_1 = col_1

	let end_line = line_2
	let end_col = col_2 - 1

	call matchaddpos( 'Cursor', [ [ cursor_line, cursor_col ] ] )
	redraws
	echohl Title
	echon '-- BRACKET --'

	let typed_char = nr2char(getchar())
	while index( [ '', '', '	', '' ], typed_char ) == -1

		"TODO Identity the backspace key
		if typed_char == ''
			if cursor_line == orig_cursor_line && len <= 0
				let typed_char = nr2char(getchar())
				continue
			endif

			if cursor_col == 1
				let prev_line_len = strwidth( getline( line_2 - 1 ) )
			endif

			let col = ( left ? col_2 : col_2 + len ) - 1
			call setpos( '.', [ bufnr('%'), line_2, col ] )
			execute 'normal!' ( col > 0 ? 'a' : 'i' ).( left ? "\<Del>" : "\<BS>" )

			let col = ( left ? col_1 + len : col_1 ) - 1
			call setpos( '.', [ bufnr('%'), line_1, col ] )
			execute 'normal!' ( col > 0 ? 'a' : 'i' ).( left ? "\<BS>" : "\<Del>" )

			if cursor_col > 1
				let len -= 1
				if line_2 == line_1 | let col_2 -= 1 | endif
				let cursor_col -= left || line_2 > line_1 ? 1 : 2

				if !left || cursor_line == orig_cursor_line
					let end_col -= line_2 == line_1 ? 2 : 1
				endif
			else
				let len = prev_line_len
				if left
					let line_1 -= 1
					let line_2 -= 1
					let col_1 = 1
					let col_2 += prev_line_len
					let cursor_line = line_1
					let cursor_col = col_1 + len
				else
					let line_2 -= 2
					let col_2 = 1
					let cursor_line = line_2
					let cursor_col = col_2 + len
				endif
				if cursor_line == orig_cursor_line
					let col_1 = orig_col_1
					let col_2 = orig_col_2
					let len = orig_len
					let cursor_col = ( left ? col_1 : col_2 ) + len
				endif

				let end_line -= 2
				if cursor_line == orig_cursor_line
					let end_col = orig_col_2 + len - 1
				elseif !left
					let end_col = prev_line_len
				endif
			endif
		else
			if left
				let typed_char = s:InverseBrackets( typed_char )
			endif

			let col = ( left ? col_2 : col_2 + len ) - 1
			call setpos( '.', [ bufnr('%'), line_2, col ] )
			execute 'normal!' ( col > 0 ? 'a' : 'i' ).typed_char

			let typed_char = s:InverseBrackets( typed_char )

			let col = ( left ? col_1 + len : col_1 ) - 1
			call setpos( '.', [ bufnr('%'), line_1, col ] )
			execute 'normal!' ( col > 0 ? 'a' : 'i' ).typed_char

			if typed_char == ''
				let end_line += 2
				if left
					if cursor_line == orig_cursor_line
						let end_col = len
					endif
				else
					let end_col = 0
				endif

				if cursor_line == orig_cursor_line
					let orig_col_2 = col_2
					let orig_len = len
				endif
				if left
					let col_2 -= col_1 + len - 1
					let line_1 += 1
					let line_2 += 1
					let col_1 = 1
					let cursor_line = line_1
				else
					let line_2 += 2
					let col_2 = 1
					let cursor_line = line_2
				endif
				let len = 0
				let cursor_col = 1
			else
				if !left || cursor_line == orig_cursor_line
					let end_col += line_2 == line_1 ? 2 : 1
				endif

				let len += 1
				if line_2 == line_1 | let col_2 += 1 | endif
				let cursor_col += left || line_2 > line_1 ? 1 : 2
			endif
		endif

		call clearmatches()
		if cursor_line != orig_cursor_line && orig_len > 0
			let offset = ( cursor_line - orig_cursor_line - 1 )/( left ? 1 : 2 ) + 1
			if left
				call matchaddpos( 'MatchParen', [ [ orig_line_1, orig_col_1, orig_len ], [ line_2 + offset, 1, orig_len ] ] )
			else
				call matchaddpos( 'MatchParen', [ [ line_1 + offset, 1, orig_len ], [ line_1 + offset, orig_col_2 - orig_col_1 + 1, orig_len ] ] )
			endif
		endif
		for l in range( 1, max([ 0, ( cursor_line - orig_cursor_line - 1 )/( left ? 1 : 2 ) ]) )
			if strwidth( getline( line_1 + l ) ) > 0
				call matchaddpos( 'MatchParen', [ line_1 + l, line_2 - l ] )
			endif
		endfor
		if len > 0
			call matchaddpos( 'MatchParen', [ [ line_1, col_1, len ], [ line_2, col_2, len ] ] )
		endif
		call matchaddpos( 'Cursor', [ [ cursor_line, cursor_col ] ] )
		redraws
		echon '-- BRACKET --'

		let typed_char = nr2char(getchar())
	endwhile
	call clearmatches()
	echohl None
	echo ''
	redraws

	if end_col == 0
		let orig_line_1 +=1
		let orig_col_1 = 1
		let end_line -= 1
		let end_col = strwidth(getline(end_line))
	endif

	if left || typed_char == ''
		call setpos( '.', [ bufnr('%'), orig_line_1, orig_col_1 ] )
	else
		call setpos( '.', [ bufnr('%'), end_line, end_col ] )
	endif
	execute "normal! a\<ESC>"

	call setpos( "'<", [ bufnr('%'), orig_line_1, orig_col_1 ] )
	call setpos( "'>", [ bufnr('%'), end_line, end_col ] )

	let &autoindent = autoindent_config
	let &smartindent = smartindent_config
	let &cindent = cindent_config
	let &softtabstop = softtabstop_config
endfunction

function! s:InverseBrackets( char )
	if a:char == '(' | return ')'
	elseif a:char == ')' | return '('
	elseif a:char == '[' | return ']'
	elseif a:char == ']' | return '['
	elseif a:char == '{' | return '}'
	elseif a:char == '}' | return '{'
	elseif a:char == '<' | return '>'
	elseif a:char == '>' | return '<'
	else
		return a:char
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
	echohl Question
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

inoremap <C-j> <ESC>gEa
inoremap <C-k> <ESC>Ea
inoremap <C-h> <ESC>I
inoremap <C-l> <ESC>A

nnoremap <Space>o <C-o>
nnoremap <Space>i <C-i>

nnoremap <Space><Space> :marks<CR>
nnoremap <Space> `
nnoremap £ [`
nnoremap µ ]`
nnoremap <Space><BS> :Delmark<CR>

command! Delmark call Delmark()

function! Delmark()
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

nnoremap <leader>u :earlier 1f<CR>
nnoremap <leader>r :later 1f<CR>

inoremap <C-_> <C-o>u

" Define keys that start a new undoable edit:
inoremap <CR> <C-g>u<CR>
inoremap <C-r> <C-g>u<C-r>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

command! ClearUndo call s:ClearUndo()

function! s:ClearUndo()
	call delete(undofile(@%))
	let old_undolevels = &undolevels
	set undolevels=-1
	execute 'normal! a '
	let &undolevels = old_undolevels
endfunction

""}}}


"" Gestion des Tampons ""{{{

"nnoremap <Space><Tab> :ls<CR>
"nnoremap <Tab> :bn<CR>
"nnoremap <S-Tab> :bp<CR>

nnoremap <C-s> :Bv<CR>

nnoremap <C-w>b :bd<CR>
nnoremap <C-w><C-b> :bd<CR>

command! -bang Bvanish call s:VanishBuffer(<bang>0)

command! -bang DeleteHiddenBufs call s:DeleteHiddenBufs(<bang>0)

command! -bang -nargs=1 -complete=file SaveAs call s:SaveAs(<bang>0, '<args>')

function! s:VanishBuffer(bang)
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

function! s:DeleteHiddenBufs(bang)
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

function! s:SaveAs(bang, newfile)
    if !a:bang && !empty(glob(a:newfile))
        echohl ErrorMsg | echo 'Le fichier' a:newfile 'existe déjà (ajouter ! pour passer outre)' | echohl None
    else
        execute 'write!' a:newfile
        execute 'edit' a:newfile
        execute 'bdelete! #'
    endif
endfunction

""}}}


"" Buffer workspaces ""{{{

"DEBUG FUNCTIONS"
nnoremap <F2> :PrintBwsList<CR>
command! PrintBwsList echo s:bws_list

nnoremap <silent> <Space><Tab> :BufWorkspaces<CR>
nnoremap <silent> <Tab> :NextBuffer<CR>
nnoremap <silent> <S-Tab> :PrevBuffer<CR>

command! BufWorkspaces call s:BufWorkspaces()
command! NextBuffer exe 'b' s:GetNextBuffer( bufnr('%') )
command! PrevBuffer exe 'b' s:GetPrevBuffer( bufnr('%') )

augroup set_new_buffer_workspace
	autocmd!
	autocmd BufRead * call s:MoveBufferToWorkspace( bufnr('%'), s:GetBufferWorkspace(bufnr('#')) )
	autocmd BufAdd  * call s:MoveBufferToWorkspace( bufnr('$'), s:GetBufferWorkspace(bufnr('%')) )

	"autocmd BufRead * echo 'BufRead' bufnr('%') bufnr('#')
	"autocmd BufAdd * echo 'BufAdd' bufnr('$') bufnr('%')
augroup end

augroup clean_workspace
	autocmd!
	autocmd BufDelete * call s:RemoveBufferFromWorkspace( bufnr('#'), s:GetBufferWorkspace(bufnr('#')) )
augroup end

let s:bws_list = []

function! s:BufWorkspaces()
	call s:PrintWorkspaces()

	let ws_count = s:GetWorkspaceCount()
	let current_ws = s:GetBufferWorkspace( bufnr('%') )
	let prev_ws_buf = s:GetPrevBuffer( bufnr('%') )

	if ws_count > 1
		echo ' [1-'.ws_count."] change buffer's ws    "
	else
		echo ' '
	endif
	echon '[' ws_count + 1 '] create ws    [n] next ws    [p] prev ws    [D] delete all ws    [b] open buffer'
	echohl Question | echo '-- Enter a command or any other key to cancel --' | echohl None
	let answer = nr2char(getchar())
	if answer == 'n'
		redraw
		if ws_count == 1 | return | endif
		execute 'buffer' min( s:GetNextWorkspace( current_ws ) )
	elseif answer == 'p'
		redraw
		if ws_count == 1 | return | endif
		execute 'buffer' min( s:GetPrevWorkspace( current_ws ) )
	elseif match( answer, '[1-9]' ) != -1
		if answer > ws_count + 1
			redraw | echohl Error | echo 'Wrong workspace number' | echohl None
		elseif answer == current_ws
			redraw | echo 'The buffer' bufnr('%') 'is already in workspace' answer
		elseif answer == ws_count + 1
			if s:GetBufferCount( current_ws ) < 2
				redraw | echo 'The buffer' bufnr('%') 'is the only buffer in workspace' current_ws
			else
				" Create a new workspace with the current buffer:
				call s:CreateWorkspace( bufnr('%') )
				"silent execute 'buffer' prev_ws_buf
				redraw | echomsg 'New workspace created with buffer' bufnr('%')
			endif
		else
			" Move the current buffer to the given workspace number:
			call s:MoveBufferToWorkspace( bufnr('%'), answer )
			silent execute 'buffer' prev_ws_buf
			redraw | echomsg 'The buffer' bufnr('%') 'has been moved to the workspace' answer
		endif
	elseif answer == 'D'
		let s:bws_list = []
		redraw | echomsg 'All the workspaces have been deleted'
	elseif answer == 'b'
		redrawstatus
		call s:PrintWorkspaces()
		echohl Title | let buf = input( ':b ', '', 'buffer' ) | echohl None
		execute 'buffer' buf
	else
		redrawstatus
	endif
endfunction

function! s:GetWorkspaceCount()
	return len(s:bws_list) + 1
endfunction

function! s:GetBufferCount( workspace )
	return len(s:GetBufferList( a:workspace ))
endfunction

function! s:PrintWorkspaces()
	let bufname_widths = map( range( 1, bufnr('$') ), "buflisted(v:val) ? strwidth(expand('#'.v:val.':t')) : 0" )
	let maxwidth = max( bufname_widths )

	for workspace in range( 1, s:GetWorkspaceCount() )
		let buf_list = s:GetBufferList( workspace )
		echon "\n  " workspace '   ' | let post_spaces = ''
		for buf in range( 1, bufnr('$') )
			if buflisted(buf) && index( buf_list, buf ) != -1
				echon post_spaces | let post_spaces = '      '
				if buf == bufnr('%') | echohl Character | endif
				echon bufnr(buf)' '
				if buf == bufnr('%') | echon '%' | elseif buf == bufnr('#') | echon '#' | else | echon ' ' | endif
				if bufwinnr(buf) != -1 | echon 'a' | else | echon 'h' | endif
				if !getbufvar(buf, '&modifiable') | echon '-' | elseif getbufvar(buf, '&readonly') | echon '=' | else | echon ' ' | endif
				if getbufvar(buf, '&modified') | echon '+' | elseif getbufvar(buf, '&re') | echon 'x' | else | echon ' ' | endif
				if len(bufname(buf)) == 0 | echon ' [Untitled]' | else | echon ' 'expand('#'.buf.':t') | endif
				if expand('#'.buf.':h') != '.' | echon repeat( ' ', maxwidth - strwidth(expand('#'.buf.':t')) + 4 )'in 'expand('#'.buf.':h') | endif
				echon "\n"
				echohl None
			endif
		endfor
	endfor
	echon "\n"
endfunction

function! s:GetBufferWorkspace( buffer )
	for bws_index in range( len(s:bws_list) )
		if index( s:bws_list[bws_index], a:buffer ) != -1
			return bws_index + 2
		endif
	endfor
	return 1
endfunction

function! s:GetBufferList( workspace )
	if a:workspace == 1
		let buf_list = []
		"let ws_buffers = []
		"for blist in range( len(s:bws_list) )
			"call extend( ws_buffers, blist )
		"endfor
		for buf in range( 1, bufnr('$') )
			"if buflisted(buf) && index( ws_buffers, buf ) == -1
			if buflisted(buf) && match( join( s:bws_list ), '\(\[\| \)'.buf ) == -1
				call add( buf_list, buf )
			endif
		endfor
		return buf_list
	elseif a:workspace - 2 < len(s:bws_list) && a:workspace - 2 >= 0
		return s:bws_list[a:workspace - 2]
	else
		return []
	endif
endfunction

function! s:GetNextBuffer( buffer )
	let workspace = s:GetBufferWorkspace( a:buffer )
	let buf_list = s:GetBufferList( workspace )
	if len(buf_list) == 1
		return a:buffer
	endif
	let next_buf_index = index( buf_list, a:buffer ) + 1
	if next_buf_index > len(buf_list) - 1
		return buf_list[0]
	endif
	return buf_list[next_buf_index]
endfunction

function! s:GetPrevBuffer( buffer )
	let workspace = s:GetBufferWorkspace( a:buffer )
	let buf_list = s:GetBufferList( workspace )
	if len(buf_list) == 1
		return a:buffer
	endif
	let next_buf_index = index( buf_list, a:buffer ) - 1
	if next_buf_index < 0
		return buf_list[-1]
	endif
	return buf_list[next_buf_index]
endfunction

function! s:GetNextWorkspace( current_ws )
	let ws_count = s:GetWorkspaceCount()
	return s:GetBufferList( a:current_ws%ws_count + 1 )
endfunction

function! s:GetPrevWorkspace( current_ws )
	let ws_count = s:GetWorkspaceCount()
	return s:GetBufferList( ( a:current_ws + ws_count - 2 )%ws_count + 1 )
endfunction

function! s:RemoveBufferFromWorkspace( buffer, workspace )
	if a:workspace > 1
		call remove( s:bws_list[a:workspace - 2], index( s:bws_list[a:workspace - 2], a:buffer ) )
		if len(s:bws_list[a:workspace - 2]) == 0
			call remove( s:bws_list, a:workspace - 2 )
		endif
	elseif len(s:GetBufferList( 1 )) == 0
		call remove( s:bws_list, 0 )
	endif
endfunction

function! s:CreateWorkspace( buffer )
	let buffer_ws = s:GetBufferWorkspace( a:buffer )

	call s:RemoveBufferFromWorkspace( a:buffer, buffer_ws )

	call add( s:bws_list, [a:buffer] )
endfunction

function! s:MoveBufferToWorkspace( buffer, destination_ws )
	if a:destination_ws > s:GetWorkspaceCount()
		throw 'The destination workspace does not exist yet!'
	endif

	let buffer_ws = s:GetBufferWorkspace( a:buffer )

	if a:destination_ws == buffer_ws
		return
	endif

	if a:destination_ws > 1
		call add( s:bws_list[a:destination_ws - 2], a:buffer )
	endif

	call s:RemoveBufferFromWorkspace( a:buffer, buffer_ws )
endfunction


" Save and restore buffer workspaces "

function! s:SaveBufWorkspace( path, name )
	" Translate the list of list of buffer numbers to a list of strings:
	let bws_string_list = []
	for bws in s:bws_list
		call add( bws_string_list, join( map( copy( bws ), "expand('#'.v:val.':p')" ) ) )
	endfor

	call writefile( bws_string_list, expand( a:path.'/'.a:name.'.bws' ) )
endfunction

function! s:LoadBufWorkspace( path, name )
	let glob_path = glob( a:path.'/'.a:name.'.bws' )
	if empty( glob_path )
		return -1
	endif

	let bws_string_list = readfile( glob_path )

	" Translate the list of strings to a list of list of buffer numbers:
	let s:bws_list = []
	for bws_string in bws_string_list
		call add( s:bws_list, map( split( bws_string ), 'bufnr( v:val )' ) )
	endfor

	return 0
endfunction

function! s:DeleteBufWorkspace( path, name )
	call delete( expand( a:path.'/.'.a:name.'.bws' ) )
endfunction

""}}}


"" Gestion des Sessions ""{{{

"set sessionoptions=curdir,buffers,winsize,folds,blank,help,tabpages,options,localoptions,globals
set sessionoptions=buffers,winsize,folds,blank,help,tabpages,options,localoptions,globals

let g:sessions_path = s:root_dir.'/sessions/'
let g:default_session = '.latest'
let s:current_session = g:default_session

augroup autosave_session
	autocmd!
	autocmd VimLeave * execute 'mksession!' g:sessions_path.g:default_session
	autocmd VimLeave * call s:SaveBufWorkspace(g:sessions_path, g:default_session)
augroup end

command! RestoreSession call s:RestoreSession()
command! -bang -nargs=* -complete=customlist,FileCompletion NewSession call s:NewSession(<bang>0, '<args>')
command! SaveSession call s:SaveSession()
command! -nargs=1 -complete=customlist,FileCompletion OverwriteSession call s:OverwriteSession('<args>')
command! -nargs=1 -complete=customlist,FileCompletion OpenSession call s:OpenSession('<args>')
command! -nargs=+ -complete=customlist,FileCompletion DeleteSession call s:DeleteSession('<args>')

function! s:RestoreSession()
    if !empty(globpath(g:sessions_path, g:default_session))
        execute 'source' g:sessions_path.g:default_session
		call s:LoadBufWorkspace(g:sessions_path, g:default_session)
    else
        echohl ErrorMsg | echo 'Aucune session à restorer' | echohl None
    endif
endfunction

function! s:NewSession(bang, session_name)
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
			call s:SaveBufWorkspace(g:sessions_path, g:default_session)
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
			call s:SaveBufWorkspace(g:sessions_path, a:session_name)
			redraw
			echomsg 'Session' a:session_name 'créée'
			let s:current_session = a:session_name
		else
			echohl ErrorMsg | echo 'La session' a:session_name 'existe déjà (ajouter ! pour passer outre)' | echohl None
		endif
	endif
endfunction

function! s:SaveSession()
    if s:current_session !=# g:default_session && !empty(globpath(g:sessions_path, s:current_session))
        execute 'mksession!' g:sessions_path.s:current_session
		call s:SaveBufWorkspace(g:sessions_path, s:current_session)
		redraw
        echomsg 'Session' s:current_session 'enregistrée'
    else
        echohl ErrorMsg | echo "La session en cours n'a pas été créée : utilisez 'NewSession' pour en créer une" | echohl None
    endif
endfunction

function! s:OverwriteSession(session_name)
    if !empty(globpath(g:sessions_path, a:session_name))
        execute 'mksession!' g:sessions_path.a:session_name
		call s:SaveBufWorkspace(g:sessions_path, a:session_name)
		redraw
        echomsg 'Session' a:session_name 'écrasée'
        let s:current_session = a:session_name
    else
        echohl ErrorMsg | echo 'La session' a:session_name "n'existe pas" | echohl None
    endif
endfunction

function! s:OpenSession(session_name)
    if !empty(globpath(g:sessions_path, a:session_name))
        execute 'source' g:sessions_path.a:session_name
		call s:LoadBufWorkspace(g:sessions_path, a:session_name)
        let s:current_session = a:session_name
    else
        echohl ErrorMsg | echo 'La session' a:session_name "n'existe pas" | echohl None
    endif
endfunction

function! s:DeleteSession(session_name)
	for session in split(a:session_name)
		if !empty(globpath(g:sessions_path, session))
			call delete(expand(g:sessions_path.session))
			call s:DeleteBufWorkspace(g:sessions_path, a:session_name)
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
let g:netrw_liststyle = 3
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
	autocmd FileType text,markdown call s:Load_text_mode()
augroup end

function! s:Load_text_mode()
	setlocal wrap linebreak nolist

	nnoremap <buffer> j gj
	nnoremap <buffer> k gk
	nnoremap <buffer> <Down> gj
	nnoremap <buffer> <Up> gk
	nnoremap <buffer> 0 g0
	nnoremap <buffer> ^ g^
	nnoremap <buffer> $ g$

	inoremap <buffer> <C-h> <ESC>(a
	inoremap <buffer> <C-l> <ESC>:call Appendtext()<CR>a
	
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
	autocmd FileType c,cpp,sh,arduino setlocal foldmethod=marker | set foldmarker={,}
	"Ignore boost librairies for autocompletion:
	autocmd FileType c,cpp,arduino setlocal include=^\\s*#\\s*include\ \\(<boost/\\)\\@!
	autocmd FileType c,cpp,arduino set iskeyword-=:
	autocmd FileType c,cpp,arduino set smartindent
	autocmd FileType tex setlocal foldmethod=marker

	autocmd FileType vim let b:comment_char = '"'
	autocmd FileType sh,python,conf,make,cmake let b:comment_char = '#'
	autocmd FileType c,cpp,arduino let b:comment_char = '//'
	autocmd FileType tex,plaintex,matlab let b:comment_char = '%'
	autocmd FileType lua let b:comment_char = '--'

    autocmd Bufread,BufNewFile *.fpp{,i} set filetype=fpp
augroup end

nnoremap <silent> é :call SwitchComment(1)<CR>
vnoremap <silent> é :call SwitchComment(0)<CR>gv<ESC>
nnoremap <silent> <leader>f :Format<CR>
vnoremap <silent> <leader>f :Format<CR>gv<ESC>

command! -range Comment <line1>,<line2> call s:Comment()
command! -range UnComment <line1>,<line2> call s:UnComment()
command! -range Format <line1>,<line2> call s:Format()

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

function! s:Comment()
	if exists('b:comment_char')
		normal! ^
		if getline('.')[col('.')-1:col('.')-2+strlen(b:comment_char)] != b:comment_char
			execute 'normal! i'.b:comment_char
		endif
	else
        echohl ErrorMsg | echo "Aucun caractère n'a été défini pour les commentaires de ce type de fichier" | echohl None
	endif
endfunction

function! s:UnComment()
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

function! s:Format()
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
	autocmd FileType tex,plaintex call s:Load_latex_mode()
augroup end

function! s:Load_latex_mode()

	let g:auxdir = 'auxfiles'

	call s:Load_text_mode()

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

		let pdflatex_cmd = '!cd '.root.'&& mkdir -p '.g:auxdir.'&& pdflatex -output-directory '.g:auxdir.' '.file
		                 \.'&& mv '.g:auxdir.'/$(basename '.file.' .tex).pdf .'
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

		let pdflatex_cmd = ' && pdflatex -output-directory '.g:auxdir.' '.file
		let bibtex_cmd = '!cd '.root.'&& mkdir -p '.g:auxdir.'&& rm -f '.g:auxdir.'*.bbl'.pdflatex_cmd
		               \.'&& bibtex '.g:auxdir.'/$(basename '.file.' .tex)'.pdflatex_cmd.pdflatex_cmd
		               \.'&& mv '.g:auxdir.'/$(basename '.file.' .tex).pdf .'
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

		let pdflatex_cmd = '!cd '.root.'&& mkdir -p '.g:auxdir.'&& makeindex '.g:auxdir.'/$(basename '.file.' .tex).nlo -s nomencl.ist -o '.g:auxdir.'/$(basename '.file.' .tex).nls'
		                 \.'&& pdflatex -output-directory '.g:auxdir.' '.file
		                 \.'&& mv '.g:auxdir.'/$(basename '.file.' .tex).pdf .'
        if a:bang
            execute pdflatex_cmd '&&' g:netrw_browsex_viewer root.'$(basename' file '.tex).pdf'
		else
            execute pdflatex_cmd
        endif
    endfunction

	nnoremap <buffer> gl :call LatexLayout()<CR>

	nnoremap <buffer> gn /<??><CR>vf>o
	vnoremap <buffer> gn <ESC>/<??><CR>vf>o
	inoremap <buffer> <C-g>n <ESC>/<??><CR>vf>o
	inoremap <buffer> <C-g><C-n> <ESC>/<??><CR>vf>o

	nnoremap <buffer> gp ?<\?\?><CR>vf>o
	vnoremap <buffer> gp <ESC>?<\?\?><CR>vf>o
	inoremap <buffer> <C-g>p <ESC>?<\?\?><CR>vf>o
	inoremap <buffer> <C-g><C-p> <ESC>?<\?\?><CR>vf>o

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


"" Coloration Syntaxtique ""{{{

nmap <F5> :call SynStack()<CR>

function! SynStack()
	if exists('*synstack')
		echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
	endif
endfunction

""}}}


"" Correction Orthographique ""{{{

nnoremap <F6> :SpellEn<CR>
nnoremap <F7> :SpellFr<CR>

inoremap <F6> <ESC>:SpellEn<CR>a
inoremap <F7> <ESC>:SpellFr<CR>a

command! SpellFr call s:SpellFr()
command! SpellEn call s:SpellEn()

let g:languagetool_jar = '~/Bin/LanguageTool-3.0/languagetool-commandline.jar'

function! s:SpellFr()
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

function! s:SpellEn()
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


"" Git ""{{{

" Open a previous git version of the current file:
command! -nargs=? GitShow silent call s:GitShow('<args>')

function! s:GitShow(rev)
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

nnoremap <leader>e :FZF 

" Browse history:
nnoremap <space>! :call fzf#run({'source': v:oldfiles, 'sink': 'e', 'right': '80%'})<CR>
" Browse git files:
nnoremap <leader>g :call fzf#run({'source': 'git ls-files', 'sink': 'e', 'right': '80%'})<CR>

""}}}


"" Tabular ""{{{

augroup tabular_config
	autocmd!
	autocmd FileType * if exists(':AddTabularPattern') == 2 | AddTabularPattern! align_last /\S*$ | endif
augroup end

""}}}
