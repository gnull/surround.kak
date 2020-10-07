# surround.kak

Surround mode for [Kakoune].

[Kakoune]: https://kakoune.org

## Installation

Add [`surround.kak`](rc/surround.kak) to your autoload or source it manually.

``` kak
require-module surround
```

## Usage

- Enter surround mode with `enter-user-mode surround`.
- Enter insert mode with `surround-enter-insert-mode`.

## Configuration

``` kak
# Quoting
map -docstring 'Surround' global normal q ': enter-user-mode surround<ret>'
map -docstring 'Surround insert' global normal Q ': surround-enter-insert-mode<ret>'

# Move macros to ^
map -docstring 'Play macro' global normal ^ q
map -docstring 'Record macro' global normal <a-^> Q
```

## Surrounding pairs

By default, surround.kak includes the following surrounding pairs:

```
Parenthesis block: b ( )
Braces block: B { }
Brackets block: r [ ]
Angle block: a < >
Double quote string: Q " "
Single quote string: q ' '
Grave quote string: g ` `
Double quotation mark: <a-Q> “ ”
Single quotation mark: <a-q> ‘ ’
Double angle quotation mark: <a-G> « »
Single angle quotation mark: <a-g> ‹ ›
Emphasis: _ _
Strong: ** **
Regular expression: / /
```

surround.kak has also support for free input on <kbd>i</kbd> and <kbd>m</kbd> (mirror), and tags on <kbd>t</kbd>.

See also [auto-pairs.kak] and [manual-indent.kak].

[auto-pairs.kak]: https://github.com/alexherbo2/auto-pairs.kak
[manual-indent.kak]: https://github.com/alexherbo2/manual-indent.kak
