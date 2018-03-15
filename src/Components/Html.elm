module Components.Html
    exposing
        ( Attribute
        , Html
        , a
        , abbr
        , address
        , article
        , aside
        , audio
        , b
        , bdi
        , bdo
        , blockquote
        , body
        , br
        , button
        , canvas
        , caption
        , cite
        , code
        , col
        , colgroup
        , datalist
        , dd
        , del
        , details
        , dfn
        , div
        , dl
        , dt
        , em
        , embed
        , fieldset
        , figcaption
        , figure
        , footer
        , form
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , header
        , hr
        , i
        , iframe
        , img
        , input
        , ins
        , kbd
        , keygen
        , label
        , legend
        , li
        , main_
        , mark
        , math
        , menu
        , menuitem
        , meter
        , nav
        , node
        , none
        , object
        , ol
        , optgroup
        , option
        , output
        , p
        , param
        , plain
        , pre
        , progress
        , q
        , rp
        , rt
        , ruby
        , s
        , samp
        , section
        , select
        , small
        , source
        , span
        , strong
        , sub
        , summary
        , sup
        , table
        , tbody
        , td
        , text
        , textarea
        , tfoot
        , th
        , thead
        , time
        , tr
        , track
        , u
        , ul
        , var
        , video
        , wbr
        )

{-| Build HTML views, just like with the `elm-lang/html` package.

Differences from `elm-lang/html`:

  - New functions: [`none`](#none) and [`plain`](#plain).
  - Functions for tags that can't contain children like [`input`](#input) or
    [`br`](#br) don't require a second argument.
  - No [`map`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html#map).
  - It supports [adding dynamic styles](Components-Html-Attributes#css)
    via the
    [`elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
    package.


# Primitives

@docs Html, Attribute, node, text, none, plain


# Tags


## Headers

@docs h1, h2, h3, h4, h5, h6


## Grouping Content

@docs div, p, hr, pre, blockquote


## Text

@docs span, a, code, em, strong, i, b, u, sub, sup, br


## Lists

@docs ol, ul, li, dl, dt, dd


## Emdedded Content

@docs img, iframe, canvas, math


## Inputs

@docs form, input, textarea, button, select, option


## Sections

@docs section, nav, article, aside, header, footer, address, main_, body


## Figures

@docs figure, figcaption


## Tables

@docs table, caption, colgroup, col, tbody, thead, tfoot, tr, td, th


## Less Common Elements


### Less Common Inputs

@docs fieldset, legend, label, datalist, optgroup, keygen, output, progress, meter


### Audio and Video

@docs audio, video, source, track


### Embedded Objects

@docs embed, object, param


### Text Edits

@docs ins, del


### Semantic Text

@docs small, cite, dfn, abbr, time, var, samp, kbd, s, q


### Less Common Text Tags

@docs mark, ruby, rt, rp, bdi, bdo, wbr


## Interactive Elements

@docs details, summary, menuitem, menu

-}

import Components
import Components.Internal.Core as Core
import VirtualDom


{-| -}
type alias Html msg parts =
    Components.Node msg parts


{-| -}
type alias Attribute msg parts =
    Core.Attribute msg parts


{-| General way to create HTML nodes. It is used to define all of the helper
functions in this library.

    div : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
    div attributes children =
        node "div" attributes children

You can use this to create custom nodes if you need to create something that
is not covered by the helper functions in this library.

-}
node :
    String
    -> List (Attribute msg parts)
    -> List (Html msg parts)
    -> Html msg parts
node =
    Core.Element


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"

-}
text : String -> Html msg parts
text =
    Core.Text


{-| Same as `text ""`.
-}
none : Html msg parts
none =
    text ""


{-| Embed a node that was created with another package like `elm-lang/html`.
-}
plain : VirtualDom.Node msg -> Html msg parts
plain =
    VirtualDom.map Core.LocalMsg
        >> Core.PlainNode



-- SECTIONS


{-| Represents the content of an HTML document. There is only one `body`
element in a document.
-}
body : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
body =
    node "body"


{-| Defines a section in a document.
-}
section : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
section =
    node "section"


{-| Defines a section that contains only navigation links.
-}
nav : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
nav =
    node "nav"


{-| Defines self-contained content that could exist independently of the rest
of the content.
-}
article : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
article =
    node "article"


{-| Defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
aside =
    node "aside"


{-| -}
h1 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h1 =
    node "h1"


{-| -}
h2 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h2 =
    node "h2"


{-| -}
h3 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h3 =
    node "h3"


{-| -}
h4 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h4 =
    node "h4"


{-| -}
h5 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h5 =
    node "h5"


{-| -}
h6 : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
h6 =
    node "h6"


{-| Defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.
-}
header : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
header =
    node "header"


{-| Defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
footer =
    node "footer"


{-| Defines a section containing contact information.
-}
address : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
address =
    node "address"


{-| Defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
main_ =
    node "main"



-- GROUPING CONTENT


{-| Defines a portion that should be displayed as a paragraph.
-}
p : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
p =
    node "p"


{-| Represents a thematic break between paragraphs of a section or article or
any longer content.
-}
hr : List (Attribute msg parts) -> Html msg parts
hr attributes =
    node "hr" attributes []


{-| Indicates that its content is preformatted and that this format must be
preserved.
-}
pre : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
pre =
    node "pre"


{-| Represents a content that is quoted from another source.
-}
blockquote : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
blockquote =
    node "blockquote"


{-| Defines an ordered list of items.
-}
ol : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
ol =
    node "ol"


{-| Defines an unordered list of items.
-}
ul : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
ul =
    node "ul"


{-| Defines a item of an enumeration list.
-}
li : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
li =
    node "li"


{-| Defines a definition list, that is, a list of terms and their associated
definitions.
-}
dl : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
dl =
    node "dl"


{-| Represents a term defined by the next `dd`.
-}
dt : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
dt =
    node "dt"


{-| Represents the definition of the terms immediately listed before it.
-}
dd : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
dd =
    node "dd"


{-| Represents a figure illustrated as part of the document.
-}
figure : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
figure =
    node "figure"


{-| Represents the legend of a figure.
-}
figcaption : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
figcaption =
    node "figcaption"


{-| Represents a generic container with no special meaning.
-}
div : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
div =
    node "div"



-- TEXT LEVEL SEMANTIC


{-| Represents a hyperlink, linking to another resource.
-}
a : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
a =
    node "a"


{-| Represents emphasized text, like a stress accent.
-}
em : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
em =
    node "em"


{-| Represents especially important text.
-}
strong : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
strong =
    node "strong"


{-| Represents a side comment, that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.
-}
small : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
small =
    node "small"


{-| Represents content that is no longer accurate or relevant.
-}
s : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
s =
    node "s"


{-| Represents the title of a work.
-}
cite : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
cite =
    node "cite"


{-| Represents an inline quotation.
-}
q : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
q =
    node "q"


{-| Represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
dfn =
    node "dfn"


{-| Represents an abbreviation or an acronym; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
abbr =
    node "abbr"


{-| Represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
time : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
time =
    node "time"


{-| Represents computer code.
-}
code : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
code =
    node "code"


{-| Represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
var =
    node "var"


{-| Represents the output of a program or a computer.
-}
samp : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
samp =
    node "samp"


{-| Represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.
-}
kbd : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
kbd =
    node "kbd"


{-| Represent a subscript.
-}
sub : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
sub =
    node "sub"


{-| Represent a superscript.
-}
sup : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
sup =
    node "sup"


{-| Represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
i =
    node "i"


{-| Represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
b =
    node "b"


{-| Represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
u =
    node "u"


{-| Represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
mark =
    node "mark"


{-| Represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
ruby =
    node "ruby"


{-| Represents the text of a ruby annotation.
-}
rt : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
rt =
    node "rt"


{-| Represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
rp =
    node "rp"


{-| Represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
bdi =
    node "bdi"


{-| Represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
bdo =
    node "bdo"


{-| Represents text with no specifim peaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like `class`, `lang`, or `dir`.
-}
span : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
span =
    node "span"


{-| Represents a line break.
-}
br : List (Attribute msg parts) -> Html msg parts
br attributes =
    node "br" attributes []


{-| Represents a line break opportunity, that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr : List (Attribute msg parts) -> Html msg parts
wbr attributes =
    node "wbr" attributes []



-- EDITS


{-| Defines an addition to the document.
-}
ins : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
ins =
    node "ins"


{-| Defines a removal from the document.
-}
del : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
del =
    node "del"



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : List (Attribute msg parts) -> Html msg parts
img attributes =
    node "img" attributes []


{-| Embedded an HTML document.
-}
iframe : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
iframe =
    node "iframe"


{-| Represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed : List (Attribute msg parts) -> Html msg parts
embed attributes =
    node "embed" attributes []


{-| Represents an external resource, which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
object =
    node "object"


{-| Defines parameters for use by plug-ins invoked by `object` elements.
-}
param : List (Attribute msg parts) -> Html msg parts
param attributes =
    node "param" attributes []


{-| Represents a video, the associated audio and captions, and controls.
-}
video : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
video =
    node "video"


{-| Represents a sound or audio stream.
-}
audio : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
audio =
    node "audio"


{-| Allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
source : List (Attribute msg parts) -> Html msg parts
source attributes =
    node "source" attributes []


{-| Allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
track : List (Attribute msg parts) -> Html msg parts
track attributes =
    node "track" attributes []


{-| Represents a bitmap area for graphics rendering.
-}
canvas : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
canvas =
    node "canvas"


{-| Defines a mathematical formula.
-}
math : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
math =
    node "math"



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
table =
    node "table"


{-| Represents the title of a table.
-}
caption : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
caption =
    node "caption"


{-| Represents a set of one or more columns of a table.
-}
colgroup : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
colgroup =
    node "colgroup"


{-| Represents a column of a table.
-}
col : List (Attribute msg parts) -> Html msg parts
col attributes =
    node "col" attributes []


{-| Represents the block of rows that describes the concrete data of a table.
-}
tbody : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
tbody =
    node "tbody"


{-| Represents the block of rows that describes the column labels of a table.
-}
thead : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
thead =
    node "thead"


{-| Represents the block of rows that describes the column summaries of a table.
-}
tfoot : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
tfoot =
    node "tfoot"


{-| Represents a row of cells in a table.
-}
tr : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
tr =
    node "tr"


{-| Represents a data cell in a table.
-}
td : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
td =
    node "td"


{-| Represents a header cell in a table.
-}
th : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
th =
    node "th"



-- FORMS


{-| Represents a form, consisting of controls, that can be submitted to a
server for processing.
-}
form : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
form =
    node "form"


{-| Represents a set of controls.
-}
fieldset : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
fieldset =
    node "fieldset"


{-| Represents the caption for a `fieldset`.
-}
legend : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
legend =
    node "legend"


{-| Represents the caption of a form pontrol.
-}
label : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
label =
    node "label"


{-| Represents a typed data field allowing the user to edit the data.
-}
input : List (Attribute msg parts) -> Html msg parts
input attributes =
    node "input" attributes []


{-| Represents a button.
-}
button : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
button =
    node "button"


{-| Represents a control allowing selection among a set of options.
-}
select : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
select =
    node "select"


{-| Represents a set of predefined options for other controls.
-}
datalist : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
datalist =
    node "datalist"


{-| Represents a set of options, logically grouped.
-}
optgroup : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
optgroup =
    node "optgroup"


{-| Represents an option in a `select` element or a suggestion of a `datalist`
element.
-}
option : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
option =
    node "option"


{-| Represents a multiline text edit control.
-}
textarea : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
textarea =
    node "textarea"


{-| Represents a key-pair generator control.
-}
keygen : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
keygen =
    node "keygen"


{-| Represents the result of a calculation.
-}
output : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
output =
    node "output"


{-| Represents the completion progress of a task.
-}
progress : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
progress =
    node "progress"


{-| Represents a scalar measurement (or a fractional value), within a known
range.
-}
meter : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
meter =
    node "meter"



-- INTERACTIVE ELEMENTS


{-| Represents a widget from which the user can obtain additional information
or controls.
-}
details : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
details =
    node "details"


{-| Represents a summary, caption, or legend for a given `details`.
-}
summary : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
summary =
    node "summary"


{-| Represents a command that the user can invoke.
-}
menuitem : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
menuitem =
    node "menuitem"


{-| Represents a list of commands.
-}
menu : List (Attribute msg parts) -> List (Html msg parts) -> Html msg parts
menu =
    node "menu"
