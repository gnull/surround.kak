# surround.kak

Surround pairs as-you-type for [Kakoune].

## Installation

Add [`surround.kak`](rc/surround.kak) to your autoload or source it manually.

## Usage

Enter surround mode with `surround`.  You can pass additional surrounding pairs
to the command, normally controlled by the `surround_pairs` option.  Useful to
surround `*words*`.

## Configuration

``` kak
map global user s ': surround<ret>' -docstring 'Enter surround mode'
map global user S ': surround _ _ * *<ret>' -docstring 'Enter surround mode with extra surrounding pairs'

# Optional
set-option global surround_begin auto-pairs-disable
set-option global surround_end auto-pairs-enable
```

## Surrounding pairs

By default, `surround_pairs` includes the following surrounding pairs:

```
Parenthesis block: ( )
Braces block: { }
Brackets block: [ ]
Angle block: < >
Double quote string: " "
Single quote string: ' '
Grave quote string: ` `
Double quotation mark: “ ”
Single quotation mark: ‘ ’
Double angle quotation mark: « »
Single angle quotation mark: ‹ ›
```

See also [auto-pairs.kak] and [manual-indent.kak].

[Kakoune]: https://kakoune.org
[auto-pairs.kak]: https://github.com/alexherbo2/auto-pairs.kak
[manual-indent.kak]: https://github.com/alexherbo2/manual-indent.kak
