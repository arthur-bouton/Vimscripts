syntax sync fromstart

syntax spell toplevel

syntax match mytexComment '\\\@<!%.*$' containedin=ALL

syntax region mytexBraces start='{' end='}' contained transparent

for word in readfile(expand('<sfile>:p:h').'/latex_keywords/text_keywords.txt')
	execute 'syntax match mytexTextKeyword /\'.word.'/ nextgroup=mytexArgument,mytexOption skipwhite'
endfor
syntax region mytexArgument matchgroup=mytexTextKeyword start='{' end='}' nextgroup=mytexArgument,mytexOption skipwhite contained contains=mytexBraces,mytexTextKeyword,mytexMathZone
syntax region mytexOption matchgroup=mytexTextKeyword start='\[' end='\]' nextgroup=mytexArgument,mytexOption skipwhite contained contains=mytexTextKeyword,mytexMathZone

for word in readfile(expand('<sfile>:p:h').'/latex_keywords/math_keywords.txt')
	execute 'syntax match mytexMathKeyword /\'.word.'/ contained nextgroup=mytexMathArgument skipwhite'
endfor
syntax region mytexMathArgument matchgroup=mytexMathKeyword start='{' end='}' nextgroup=mytexMathArgument skipwhite contained contains=mytexBraces,mytexMathKeyword

syntax region mytexZoneType matchgroup=mytexTextKeyword start='\\\(begin\|end\)\s*{' end='}' nextgroup=mytexArgument,mytexOption skipwhite
syntax region mytexMathZoneType matchgroup=mytexMathKeyword start='\\\(begin\|end\)\s*{' end='}' nextgroup=mytexMathArgument skipwhite contained

syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\$' end='\$' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\$\$' end='\$\$' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\\[' end='\\\]' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\(' end='\\)' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*equation\s*}' end='\\end\s*{\s*equation\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*equation\*\s*}' end='\\end\s*{\s*equation\*\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*multline\s*}' end='\\end\s*{\s*multline\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*multline\*\s*}' end='\\end\s*{\s*multline\*\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*align\s*}' end='\\end\s*{\s*align\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*align\*\s*}' end='\\end\s*{\s*align\*\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*eqnarray\s*}' end='\\end\s*{\s*eqnarray\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat
syntax region mytexMathZone matchgroup=mytexMathDelimiter start='\\begin\s*{\s*eqnarray\*\s*}' end='\\end\s*{\s*eqnarray\*\s*}' contains=mytexMathKeyword,mytexMathZone,mytexMathFormat

syntax region mytexTextInMath matchgroup=mytexMathKeyword start='\\\(\(inter\)\=text\|mbox\)\s*{' end='}' containedin=mytexMathZone contains=@Spell,mytexBraces,mytexTextKeyword,mytexMathZone

syntax region mytexSectionTitle matchgroup=mytexSection start='\\\(chapter\|section\|subsection\)\*\?\s*{' end='}' contains=@Spell,mytexBraces,mytexTextKeyword,mytexMathZone

syntax region mytexCaption matchgroup=mytexTextKeyword start='\\caption\s*{' end='}' contains=@Spell,mytexBraces,mytexTextKeyword,mytexMathZone

syntax region mytexVertSpace matchgroup=mytexTextKeyword start='\\\\\[' end='\]'

for word in readfile(expand('<sfile>:p:h').'/latex_keywords/format_keywords.txt')
	execute "syntax region mytexTextFormat matchgroup=mytexTextKeyword start='\\".word."\s*{' end='}' containedin=ALLBUT,mytexComment,mytexMathZone contains=TOP"
	execute "syntax region mytexMathFormat matchgroup=mytexMathKeyword start='\\".word."\s*{' end='}' contained contains=TOP"
endfor

highlight link mytexComment       Comment
highlight link mytexTextKeyword   Keyword
highlight link mytexArgument      Normal
highlight link mytexOption        Character
highlight link mytexZoneType      String
highlight link mytexMathZoneType  String
highlight link mytexMathZone      Identifier
highlight link mytexMathDelimiter Tag
highlight link mytexMathKeyword   Tag
highlight link mytexMathArgument  mytexMathZone
highlight link mytexTextInMath    Normal
highlight link mytexSection       texSectionMarker
highlight link mytexSectionTitle  texSectionName
highlight link mytexCaption       Character
