" if buffer-local var current_syntax exists, just stop there
if exists("b:current_syntax")
  finish
endif

" define our syntax structures
syntax match extemporeFuncDecName "\w[^: ]*" contained
syntax match extemporeFuncDec /bind-func .\+$/ contains=extemporeKeyword,extemporeFuncDecName,extemporeClosureType

syntax keyword extemporeKeyword define lambda macro dotimes begin cond
syntax keyword extemporeKeyword let let* if
syntax match extemporeKeyword "\(bind-\(func\|type\|alias\)\|define-macro\|\)"
syntax match extemporeFuncName "\(pref\-ptr\|[tpav]ref\)"
syntax match extemporeFuncName "\([tpav]set!\|set!\)"
syntax match extemporeFuncName "\(i\(32\|64\)to\(d\|f\)\)"
syntax match extemporeFuncName "\(\(f\|d\)toi\(32\|64\)\)"
syntax match extemporeFuncName "\(sys\|impc\|cl\)\(:[a-zA-Z0-9-_]\+\)\+"
syntax match extemporeFuncName "\(z\|h\|\)alloc"
syn keyword extemporeKeyword lambda and or if cond case define let let* letrec
syn keyword extemporeKeyword begin do delay set! else =>
syn keyword extemporeKeyword quote quasiquote unquote unquote-splicing
syn keyword extemporeKeyword define-syntax let-syntax letrec-syntax syntax-rules
" R6RS
syn keyword extemporeKeyword define-record-type fields protocol

syn keyword extemporeFuncName not boolean? eq? eqv? equal? pair? cons car cdr set-car!
syn keyword extemporeFuncName set-cdr! caar cadr cdar cddr caaar caadr cadar caddr
syn keyword extemporeFuncName cdaar cdadr cddar cdddr caaaar caaadr caadar caaddr
syn keyword extemporeFuncName cadaar cadadr caddar cadddr cdaaar cdaadr cdadar cdaddr
syn keyword extemporeFuncName cddaar cddadr cdddar cddddr null? list? list length
syn keyword extemporeFuncName append reverse list-ref memq memv member assq assv assoc
syn keyword extemporeFuncName symbol? symbol->string string->symbol number? complex?
syn keyword extemporeFuncName real? rational? integer? exact? inexact? = < > <= >=
syn keyword extemporeFuncName zero? positive? negative? odd? even? max min + * - / abs
syn keyword extemporeFuncName quotient remainder modulo gcd lcm numerator denominator
syn keyword extemporeFuncName floor ceiling truncate round rationalize exp log sin cos
syn keyword extemporeFuncName tan asin acos atan sqrt expt make-rectangular make-polar
syn keyword extemporeFuncName real-part imag-part magnitude angle exact->inexact
syn keyword extemporeFuncName inexact->exact number->string string->number char=?
syn keyword extemporeFuncName char-ci=? char<? char-ci<? char>? char-ci>? char<=?
syn keyword extemporeFuncName char-ci<=? char>=? char-ci>=? char-alphabetic? char?
syn keyword extemporeFuncName char-numeric? char-whitespace? char-upper-case?
syn keyword extemporeFuncName char-lower-case?
syn keyword extemporeFuncName char->integer integer->char char-upcase char-downcase
syn keyword extemporeFuncName string? make-string string string-length string-ref
syn keyword extemporeFuncName string-set! string=? string-ci=? string<? string-ci<?
syn keyword extemporeFuncName string>? string-ci>? string<=? string-ci<=? string>=?
syn keyword extemporeFuncName string-ci>=? substring string-append vector? make-vector
syn keyword extemporeFuncName vector vector-length vector-ref vector-set! procedure?
syn keyword extemporeFuncName apply map for-each call-with-current-continuation
syn keyword extemporeFuncName call-with-input-file call-with-output-file input-port?
syn keyword extemporeFuncName output-port? current-input-port current-output-port
syn keyword extemporeFuncName open-input-file open-output-file close-input-port
syn keyword extemporeFuncName close-output-port eof-object? read read-char peek-char
syn keyword extemporeFuncName write display newline write-char call/cc
syn keyword extemporeFuncName list-tail string->list list->string string-copy
syn keyword extemporeFuncName string-fill! vector->list list->vector vector-fill!
syn keyword extemporeFuncName force with-input-from-file with-output-to-file
syn keyword extemporeFuncName char-ready? load transcript-on transcript-off eval
syn keyword extemporeFuncName dynamic-wind port? values call-with-values
syn keyword extemporeFuncName scheme-report-environment null-environment
syn keyword extemporeFuncName interaction-environment
" R6RS
syn keyword extemporeFuncName make-eq-hashtable make-eqv-hashtable make-hashtable
syn keyword extemporeFuncName hashtable? hashtable-size hashtable-ref hashtable-set!
syn keyword extemporeFuncName hashtable-delete! hashtable-contains? hashtable-update!
syn keyword extemporeFuncName hashtable-copy hashtable-clear! hashtable-keys
syn keyword extemporeFuncName hashtable-entries hashtable-equivalence-function hashtable-hash-function
syn keyword extemporeFuncName hashtable-mutable? equal-hash string-hash string-ci-hash symbol-hash
syn keyword extemporeFuncName find for-all exists filter partition fold-left fold-right
syn keyword extemporeFuncName remp remove remv remq memp assp cons*

syntax match extemporeComment ";.*$"
syntax match extemporeBoolean "#[ft]"
syntax match extemporeSymbol "'[^ (]\+"
syntax match extemporeNumber "[0-9\.]\+"
syntax match extemporeScientific "[0-9\.]\+e-\d\+"
syntax match extemporeOperator "[=&+/\-\*<>]"
syntax match extemporeConst "\*\(\w\|\-\)\+\*"

syntax region extemporeString start=/"/ skip=/\\./ end=/"/

syntax match extemporeType /:[a-zA-Z0-9_\*,\-\/<>|{}\[\]]\+/ contains=extemporeAtomicType,extemporeVecType,extemporeArrayType,extemporeTupleType,extemporeClosureType,extemporeAtomicType,extemporeNumber
syntax region extemporeQualifiedType start=/\w\+{/ end=/}/ contained contains=extemporeAtomicType
syntax match extemporeTupleType /<[^ ]\+>\*\+/ contained contains=extemporeType,extemporeAtomicType
syntax match extemporeVecType /\/[^ ]\+\/\*\+/ contained contains=extemporeNumber,extemporeType,extemporeAtomicType
syntax match extemporeArrayType /|[^ ]\+|\*\+/ contained contains=extemporeNumber,extemporeAtomicType,extemporeType
syntax match extemporeClosureType /\[[^ ]\+\]\*\+/ contained contains=extemporeType,extemporeAtomicType
syntax match extemporeAtomicType /\w[^ <>\[\]{}|\/,]*\*\?/ contained

syntax region extemporeTypeDecl start=/(bind-type/ end=/)/ contains=extemporeKeyword,extemporeTupleType
syntax region extemporeTypeAlias start=/(bind-alias/ end=/)/ contains=extemporeKeyword,extemporeTupleType

" link those structures to highlight structures
highlight link extemporeKeyword Keyword
highlight link extemporeComment Comment
highlight link extemporeString String
highlight link extemporeBoolean String
highlight link extemporeSymbol Special
highlight link extemporeConst Constant

highlight link extemporeFuncName Function
highlight link extemporeFuncDecName Function

highlight link extemporeNumber Number
highlight link extemporeScientific Number

highlight link extemporeOperator Operator

highlight link extemporeType          Type
highlight link extemporeArrayType     Type
highlight link extemporeVecType       Type
highlight link extemporeClosureType   Type
highlight link extemporeTupleType     Type
highlight link extemporeQualifiedType Type
highlight link extemporeAtomicType    Keyword


" and finally set the buffer's syntax to extempore
let b:current_syntax = "extempore"
