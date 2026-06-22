#pragma once

// Full-screen, multi-line text editor.
//
//   run edit <file>
//
// Loads <file> (if it exists) into an in-RAM working buffer, then becomes the
// foreground process so every keystroke is routed to editorOnKey. Editing is
// end-of-buffer: printable keys append, ENTER inserts a newline, BACKSPACE
// deletes the last char (including across line breaks). ESC saves and returns
// to the shell. The keyboard has no arrow keys, so there is no free cursor.
extern void texteditor(int argc, int **argv);
