// Copyright (c) 2021 The Cotowali Authors. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
module symbols

import cotowali.errors { unreachable }

pub struct MapTypeInfo {
pub:
	key   Type
	value Type
}

fn (info MapTypeInfo) typename(s &Scope) string {
	key := s.must_lookup_type(info.key).name
	value := s.must_lookup_type(info.value).name
	return 'map[$key]$value'
}

pub fn (ts &TypeSymbol) map_info() ?MapTypeInfo {
	return if ts.info is MapTypeInfo { ts.info } else { none }
}

pub fn (mut s Scope) lookup_or_register_map_type(info MapTypeInfo) &TypeSymbol {
	return s.lookup_or_register_type(name: info.typename(s), info: info)
}

pub fn (s Scope) lookup_map_type(info MapTypeInfo) ?&TypeSymbol {
	return s.lookup_type(info.typename(s))
}

pub fn (s Scope) must_lookup_map_type(info MapTypeInfo) &TypeSymbol {
	return s.lookup_map_type(info) or { panic(unreachable(err)) }
}