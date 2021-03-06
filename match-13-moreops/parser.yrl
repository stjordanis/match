Nonterminals 
expr_list grammar literal expressions expression function_def argument_def
arguments block fun_expression function_call call_arguments call_argument
bool_expr comp_expr add_expr mul_expr unary_expr or_expr xor_expr and_expr.

Terminals 
bool_op comp_op add_op mul_op unary_op match var open close fn sep
open_block close_block integer float boolean endl atom and_op xor_op or_op.

Rootsymbol grammar.

grammar -> expr_list: '$1'.

expr_list -> fun_expression: ['$1'].
expr_list -> fun_expression expr_list: ['$1'|'$2'].

fun_expression -> var match function_def endl: {line('$1'), fun_def, unwrap('$1'), '$3'}.

expressions -> expression endl: ['$1'].
expressions -> expression endl expressions: ['$1'|'$3'].

expression -> bool_expr match bool_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
expression -> bool_expr : '$1'.

bool_expr -> comp_expr bool_op bool_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
bool_expr -> comp_expr : '$1'.

comp_expr -> or_expr comp_op comp_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
comp_expr -> or_expr : '$1'.

or_expr -> xor_expr or_op or_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
or_expr -> xor_expr : '$1'.

xor_expr -> and_expr xor_op xor_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
xor_expr -> and_expr : '$1'.

and_expr -> add_expr and_op and_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
and_expr -> add_expr : '$1'.

add_expr -> mul_expr add_op add_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
add_expr -> mul_expr : '$1'.

mul_expr -> unary_expr mul_op mul_expr : {line('$2'), unwrap('$2'), '$1', '$3'}.
mul_expr -> unary_expr: '$1'.

function_call -> var open call_arguments close: {line('$2'), call, '$1', '$3'}.
function_call -> atom open call_arguments close: {line('$2'), callatom, get_atom(unwrap('$1')), '$3'}.
function_call -> function_call open call_arguments close: {line('$2'), call, '$1', '$3'}.

call_arguments -> call_argument:  ['$1'].
call_arguments -> call_argument sep call_arguments:  ['$1'|'$3'].
call_argument -> expression: '$1'.

function_def 	-> fn argument_def block: {line('$1'), unwrap('$1'), '$2', '$3'}.
argument_def	-> open arguments close : {line('$1'), unwrap('$1'), '$2'}.
argument_def	-> open close : {line('$1'), '(', []}.

arguments	-> unary_expr: ['$1'].
arguments	-> unary_expr sep arguments : ['$1'|'$3'].

block		-> bool_expr:  {line('$1'), '{', ['$1']}.
block		-> open_block expressions close_block : {line('$1'), unwrap('$1'), '$2'}.

unary_expr -> unary_op literal: {line('$1'), unwrap('$1'), '$2'}.
unary_expr -> add_op literal: {line('$1'), unwrap('$1'), '$2'}.
unary_expr -> literal: '$1'.

literal -> integer : {integer, line('$1'), unwrap('$1')}.
literal -> float : {float, line('$1'), unwrap('$1')}.
literal -> boolean : {atom, line('$1'), unwrap('$1')}.
literal -> var : {var, line('$1'), unwrap('$1')}.
literal -> atom : {atom, line('$1'), get_atom(unwrap('$1'))}.
literal -> open expression close : '$2'.
literal -> function_call : '$1'.
literal -> function_def : '$1'.

Erlang code.

unwrap({_,V}) -> V;
unwrap({_,_,V}) -> V.

line({Line, _}) -> Line;
line({_, Line, _}) -> Line;
line({Line, _, _, _}) -> Line.

get_atom([_ | T]) -> list_to_atom(T).
