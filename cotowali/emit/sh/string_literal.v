// Copyright (c) 2021 zakuro <z@kuro.red>. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module sh

import cotowali.ast { Expr, StringLiteral }
import cotowali.token { Token }
import cotowali.errors { unreachable }

const invalid_string_literal = unreachable('invalid string literal')

fn (mut e Emitter) single_quote_string_literal_value(expr StringLiteral) {
	for v in expr.contents {
		if v is Token {
			match v.kind {
				.string_literal_content_escaped_back_slash {
					e.write(r'\\')
				}
				.string_literal_content_escaped_single_quote {
					e.write(r"\'")
				}
				.string_literal_content_text {
					e.write("'$v.text'")
				}
				else {
					panic(sh.invalid_string_literal)
				}
			}
		} else {
			panic(sh.invalid_string_literal)
		}
	}
}

fn (mut e Emitter) double_quote_string_literal_value(expr StringLiteral) {
	e.write('"')
	{
		for v in expr.contents {
			if v is Token {
				e.write(v.text)
			} else if v is Expr {
				e.expr(v, quote: false)
			}
		}
	}
	e.write('"')
}

fn (mut e Emitter) single_quote_raw_string_literal_value(expr StringLiteral) {
	content := expr.contents[0]
	if content is Token {
		e.write("'$content.text'")
	} else {
		panic(sh.invalid_string_literal)
	}
}

fn (mut e Emitter) double_quote_raw_string_literal_value(expr StringLiteral) {
	content := expr.contents[0]
	if content is Token {
		text := content.text.replace("'", r"'\''") // r"a'b" -> 'a'\''b'
		e.write("'$text'")
	} else {
		panic(sh.invalid_string_literal)
	}
}

fn (mut e Emitter) string_literal(expr StringLiteral, opt ExprOpt) {
	e.write_echo_if_command(opt)

	if expr.contents.len == 0 {
		e.write("''")
		return
	}

	if expr.is_raw() {
		if expr.contents.len > 1 {
			panic(unreachable('invalid raw string'))
		}
	}

	tmp_var := e.new_tmp_ident()
	e.insert_at(e.stmt_head_pos(), fn (mut e Emitter, arg ExprWithValue<StringLiteral, string>) {
		expr := arg.expr
		tmp_var := arg.value
		e.write('$tmp_var=')
		match expr.open.kind {
			.single_quote { e.single_quote_string_literal_value(expr) }
			.double_quote { e.double_quote_string_literal_value(expr) }
			.single_quote_with_r_prefix { e.single_quote_raw_string_literal_value(expr) }
			.double_quote_with_r_prefix { e.double_quote_raw_string_literal_value(expr) }
			else { panic(unreachable('not a string')) }
		}
		e.writeln('')
	}, expr_with_value(expr, tmp_var))

	if opt.quote {
		e.write('"')
	}
	e.write('\$$tmp_var')
	if opt.quote {
		e.write('"')
	}
}
