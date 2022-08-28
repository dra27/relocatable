/**************************************************************************/
/*                                                                        */
/*                                 OCaml                                  */
/*                                                                        */
/*                 David Allsopp, OCaml Labs, Cambridge.                  */
/*                                                                        */
/*   Copyright 2021 David Allsopp Ltd.                                    */
/*                                                                        */
/*   All rights reserved.  This file is distributed under the terms of    */
/*   the GNU Lesser General Public License version 2.1, with the          */
/*   special exception on linking described in the file LICENSE.          */
/*                                                                        */
/**************************************************************************/

/* XXX This is shared with sak.c */

#define CAML_INTERNALS
#include "caml/misc.h"

#include <string.h>
#ifdef _WIN32
#include <stdio.h>
#include <ctype.h>
#endif

/* Converts the supplied path (UTF-8 on Unix and UCS-2ish on Windows) to a valid
   malloc'd C string literal. On Windows, this is always a wchar_t* (L"..."). */
char * caml_emit_c_string(const char_os *path)
{
  char *buf, *p;
  char_os c;

  /* Worst case is every character represented with \x0000 + L"" + NUL */
  buf = (char *)malloc(strlen_os(path) * 6 + 4);
  if (buf == NULL)
    return NULL;

  p = buf;

#ifdef _WIN32
  *p++ = 'L';
#endif
  *p++ = '"';

  while ((c = *path++) != 0) {
    /* Escape \, " and \n */
    if (c == '\\') {
      *p++ = '"';
      *p++ = '"';
    } else if (c == '"') {
      *p++ = '\\';
      *p++ = '"';
    } else if (c == '\n') {
      *p++ = '\\';
      *p++ = 'n';
#ifndef _WIN32
    /* On Unix, nothing else needs escaping */
    } else {
      *p++ = c;
#else
    /* On Windows, allow 7-bit printable characters to be displayed literally
       and escape everything else (using the older \x notation for increased
       compatibility, rather than the newer \U. */
    } else if (c < 0x80 && iswprint(c)) {
      *p++ = c;
    } else {
      p += _snprintf(p, 7, "\\x%04x", c);
#endif
    }
  }

  *p++ = '"';
  *p = 0;

  return buf;
}
