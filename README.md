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
```

## Surrounding pairs

By default, `surround_pairs` includes the following surrounding pairs.

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

[Kakoune]: https://kakoune.org
