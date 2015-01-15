// Copyright (C) 2013-2015 MetaMorph Software, Inc

// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this data, including any software or models in source or binary
// form, as well as any drawings, specifications, and documentation
// (collectively "the Data"), to deal in the Data without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Data, and to
// permit persons to whom the Data is furnished to do so, subject to the
// following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Data.

// THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

// =======================
// This version of the META tools is a fork of an original version produced
// by Vanderbilt University's Institute for Software Integrated Systems (ISIS).
// Their license statement:

// Copyright (C) 2011-2014 Vanderbilt University

// Developed with the sponsorship of the Defense Advanced Research Projects
// Agency (DARPA) and delivered to the U.S. Government with Unlimited Rights
// as defined in DFARS 252.227-7013.

// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this data, including any software or models in source or binary
// form, as well as any drawings, specifications, and documentation
// (collectively "the Data"), to deal in the Data without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Data, and to
// permit persons to whom the Data is furnished to do so, subject to the
// following conditions:

// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Data.

// THE DATA IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS, SPONSORS, DEVELOPERS, CONTRIBUTORS, OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE DATA OR THE USE OR OTHER DEALINGS IN THE DATA.  

#include "Cyber2SLC-gr_userinc.h"

template <class T>
bool StatementOrder( const T& lhs, const T& rhs) {
	__int64 l = lhs.statementIndex();
__int64 r = rhs.statementIndex();
return (l < r);
}

template <class BASE, class T>
bool StatementOrder_caster( const BASE& lhs, const BASE& rhs) {
	T lhs_casted= T::Cast( lhs);
	T rhs_casted= T::Cast( rhs);
	return StatementOrder( lhs_casted, rhs_casted);
}

template <class T>
bool PortOrder( const T& lhs, const T& rhs) {
	__int64 l = lhs.Number();
__int64 r = rhs.Number();
return l < r;

}

template <class BASE, class T>
bool PortOrder_caster( const BASE& lhs, const BASE& rhs) {
	T lhs_casted= T::Cast( lhs);
	T rhs_casted= T::Cast( rhs);
	return PortOrder( lhs_casted, rhs_casted);
}

template <class T>
bool TopologicalSort( const T& lhs, const T& rhs) {
	__int64 lp = lhs.Priority();
__int64 rp = rhs.Priority();
return lp < rp;
}

template <class BASE, class T>
bool TopologicalSort_caster( const BASE& lhs, const BASE& rhs) {
	T lhs_casted= T::Cast( lhs);
	T rhs_casted= T::Cast( rhs);
	return TopologicalSort( lhs_casted, rhs_casted);
}

template <class T>
bool UniqueIdSort( const T& lhs, const T& rhs) {
	__int64 l = lhs.uniqueId();
__int64 r = rhs.uniqueId();
return (l < r);
}

template <class BASE, class T>
bool UniqueIdSort_caster( const BASE& lhs, const BASE& rhs) {
	T lhs_casted= T::Cast( lhs);
	T rhs_casted= T::Cast( rhs);
	return UniqueIdSort( lhs_casted, rhs_casted);
}

template <class T>
bool PRCompare( const T& lhs, const T& rhs) {
	std::string lhsString = lhs.name();
std::string rhsString = rhs.name();
return (lhsString < rhsString);
}

template <class BASE, class T>
bool PRCompare_caster( const BASE& lhs, const BASE& rhs) {
	T lhs_casted= T::Cast( lhs);
	T rhs_casted= T::Cast( rhs);
	return PRCompare( lhs_casted, rhs_casted);
}
