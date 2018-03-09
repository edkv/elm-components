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

import Components
import Components.Internal.Core as Core
import VirtualDom


type alias Html m p =
    Components.Node m p


type alias Attribute m p =
    Components.Attribute m p


{-| General way to create HTML nodes. It is used to define all of the helper
functions in this library.

    div : List (Attribute m p) -> List (Html m p) -> Html m p
    div attributes children =
        node "div" attributes children

You can use this to create custom nodes if you need to create something that
is not covered by the helper functions in this library.

-}
node : String -> List (Attribute m p) -> List (Html m p) -> Html m p
node =
    Core.Element


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"

-}
text : String -> Html m p
text =
    Core.Text


plain : VirtualDom.Node m -> Html m p
plain =
    VirtualDom.map Core.LocalMsg
        >> Core.PlainNode


none : Html m p
none =
    text ""



-- SECTIONS


{-| Represents the content of an HTML document. There is only one `body`
element in a document.
-}
body : List (Attribute m p) -> List (Html m p) -> Html m p
body =
    node "body"


{-| Defines a section in a document.
-}
section : List (Attribute m p) -> List (Html m p) -> Html m p
section =
    node "section"


{-| Defines a section that contains only navigation links.
-}
nav : List (Attribute m p) -> List (Html m p) -> Html m p
nav =
    node "nav"


{-| Defines self-contained content that could exist independently of the rest
of the content.
-}
article : List (Attribute m p) -> List (Html m p) -> Html m p
article =
    node "article"


{-| Defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside : List (Attribute m p) -> List (Html m p) -> Html m p
aside =
    node "aside"


{-| -}
h1 : List (Attribute m p) -> List (Html m p) -> Html m p
h1 =
    node "h1"


{-| -}
h2 : List (Attribute m p) -> List (Html m p) -> Html m p
h2 =
    node "h2"


{-| -}
h3 : List (Attribute m p) -> List (Html m p) -> Html m p
h3 =
    node "h3"


{-| -}
h4 : List (Attribute m p) -> List (Html m p) -> Html m p
h4 =
    node "h4"


{-| -}
h5 : List (Attribute m p) -> List (Html m p) -> Html m p
h5 =
    node "h5"


{-| -}
h6 : List (Attribute m p) -> List (Html m p) -> Html m p
h6 =
    node "h6"


{-| Defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.
-}
header : List (Attribute m p) -> List (Html m p) -> Html m p
header =
    node "header"


{-| Defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer : List (Attribute m p) -> List (Html m p) -> Html m p
footer =
    node "footer"


{-| Defines a section containing contact information.
-}
address : List (Attribute m p) -> List (Html m p) -> Html m p
address =
    node "address"


{-| Defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : List (Attribute m p) -> List (Html m p) -> Html m p
main_ =
    node "main"



-- GROUPING CONTENT


{-| Defines a portion that should be displayed as a paragraph.
-}
p : List (Attribute m p) -> List (Html m p) -> Html m p
p =
    node "p"


{-| Represents a thematic break between paragraphs of a section or article or
any longer content.
-}
hr : List (Attribute m p) -> Html m p
hr attributes =
    node "hr" attributes []


{-| Indicates that its content is preformatted and that this format must be
preserved.
-}
pre : List (Attribute m p) -> List (Html m p) -> Html m p
pre =
    node "pre"


{-| Represents a content that is quoted from another source.
-}
blockquote : List (Attribute m p) -> List (Html m p) -> Html m p
blockquote =
    node "blockquote"


{-| Defines an ordered list of items.
-}
ol : List (Attribute m p) -> List (Html m p) -> Html m p
ol =
    node "ol"


{-| Defines an unordered list of items.
-}
ul : List (Attribute m p) -> List (Html m p) -> Html m p
ul =
    node "ul"


{-| Defines a item of an enumeration list.
-}
li : List (Attribute m p) -> List (Html m p) -> Html m p
li =
    node "li"


{-| Defines a definition list, that is, a list of terms and their associated
definitions.
-}
dl : List (Attribute m p) -> List (Html m p) -> Html m p
dl =
    node "dl"


{-| Represents a term defined by the next `dd`.
-}
dt : List (Attribute m p) -> List (Html m p) -> Html m p
dt =
    node "dt"


{-| Represents the definition of the terms immediately listed before it.
-}
dd : List (Attribute m p) -> List (Html m p) -> Html m p
dd =
    node "dd"


{-| Represents a figure illustrated as part of the document.
-}
figure : List (Attribute m p) -> List (Html m p) -> Html m p
figure =
    node "figure"


{-| Represents the legend of a figure.
-}
figcaption : List (Attribute m p) -> List (Html m p) -> Html m p
figcaption =
    node "figcaption"


{-| Represents a generic container with no special meaning.
-}
div : List (Attribute m p) -> List (Html m p) -> Html m p
div =
    node "div"



-- TEXT LEVEL SEMANTIC


{-| Represents a hyperlink, linking to another resource.
-}
a : List (Attribute m p) -> List (Html m p) -> Html m p
a =
    node "a"


{-| Represents emphasized text, like a stress accent.
-}
em : List (Attribute m p) -> List (Html m p) -> Html m p
em =
    node "em"


{-| Represents especially important text.
-}
strong : List (Attribute m p) -> List (Html m p) -> Html m p
strong =
    node "strong"


{-| Represents a side comment, that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.
-}
small : List (Attribute m p) -> List (Html m p) -> Html m p
small =
    node "small"


{-| Represents content that is no longer accurate or relevant.
-}
s : List (Attribute m p) -> List (Html m p) -> Html m p
s =
    node "s"


{-| Represents the title of a work.
-}
cite : List (Attribute m p) -> List (Html m p) -> Html m p
cite =
    node "cite"


{-| Represents an inline quotation.
-}
q : List (Attribute m p) -> List (Html m p) -> Html m p
q =
    node "q"


{-| Represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn : List (Attribute m p) -> List (Html m p) -> Html m p
dfn =
    node "dfn"


{-| Represents an abbreviation or an acronym; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr : List (Attribute m p) -> List (Html m p) -> Html m p
abbr =
    node "abbr"


{-| Represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
time : List (Attribute m p) -> List (Html m p) -> Html m p
time =
    node "time"


{-| Represents computer code.
-}
code : List (Attribute m p) -> List (Html m p) -> Html m p
code =
    node "code"


{-| Represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var : List (Attribute m p) -> List (Html m p) -> Html m p
var =
    node "var"


{-| Represents the output of a program or a computer.
-}
samp : List (Attribute m p) -> List (Html m p) -> Html m p
samp =
    node "samp"


{-| Represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.
-}
kbd : List (Attribute m p) -> List (Html m p) -> Html m p
kbd =
    node "kbd"


{-| Represent a subscript.
-}
sub : List (Attribute m p) -> List (Html m p) -> Html m p
sub =
    node "sub"


{-| Represent a superscript.
-}
sup : List (Attribute m p) -> List (Html m p) -> Html m p
sup =
    node "sup"


{-| Represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i : List (Attribute m p) -> List (Html m p) -> Html m p
i =
    node "i"


{-| Represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b : List (Attribute m p) -> List (Html m p) -> Html m p
b =
    node "b"


{-| Represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u : List (Attribute m p) -> List (Html m p) -> Html m p
u =
    node "u"


{-| Represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark : List (Attribute m p) -> List (Html m p) -> Html m p
mark =
    node "mark"


{-| Represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby : List (Attribute m p) -> List (Html m p) -> Html m p
ruby =
    node "ruby"


{-| Represents the text of a ruby annotation.
-}
rt : List (Attribute m p) -> List (Html m p) -> Html m p
rt =
    node "rt"


{-| Represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp : List (Attribute m p) -> List (Html m p) -> Html m p
rp =
    node "rp"


{-| Represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi : List (Attribute m p) -> List (Html m p) -> Html m p
bdi =
    node "bdi"


{-| Represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo : List (Attribute m p) -> List (Html m p) -> Html m p
bdo =
    node "bdo"


{-| Represents text with no specifim peaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like `class`, `lang`, or `dir`.
-}
span : List (Attribute m p) -> List (Html m p) -> Html m p
span =
    node "span"


{-| Represents a line break.
-}
br : List (Attribute m p) -> Html m p
br attributes =
    node "br" attributes []


{-| Represents a line break opportunity, that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr : List (Attribute m p) -> Html m p
wbr attributes =
    node "wbr" attributes []



-- EDITS


{-| Defines an addition to the document.
-}
ins : List (Attribute m p) -> List (Html m p) -> Html m p
ins =
    node "ins"


{-| Defines a removal from the document.
-}
del : List (Attribute m p) -> List (Html m p) -> Html m p
del =
    node "del"



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : List (Attribute m p) -> Html m p
img attributes =
    node "img" attributes []


{-| Embedded an HTML document.
-}
iframe : List (Attribute m p) -> List (Html m p) -> Html m p
iframe =
    node "iframe"


{-| Represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed : List (Attribute m p) -> Html m p
embed attributes =
    node "embed" attributes []


{-| Represents an external resource, which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object : List (Attribute m p) -> List (Html m p) -> Html m p
object =
    node "object"


{-| Defines parameters for use by plug-ins invoked by `object` elements.
-}
param : List (Attribute m p) -> Html m p
param attributes =
    node "param" attributes []


{-| Represents a video, the associated audio and captions, and controls.
-}
video : List (Attribute m p) -> List (Html m p) -> Html m p
video =
    node "video"


{-| Represents a sound or audio stream.
-}
audio : List (Attribute m p) -> List (Html m p) -> Html m p
audio =
    node "audio"


{-| Allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
source : List (Attribute m p) -> Html m p
source attributes =
    node "source" attributes []


{-| Allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
track : List (Attribute m p) -> Html m p
track attributes =
    node "track" attributes []


{-| Represents a bitmap area for graphics rendering.
-}
canvas : List (Attribute m p) -> List (Html m p) -> Html m p
canvas =
    node "canvas"


{-| Defines a mathematical formula.
-}
math : List (Attribute m p) -> List (Html m p) -> Html m p
math =
    node "math"



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : List (Attribute m p) -> List (Html m p) -> Html m p
table =
    node "table"


{-| Represents the title of a table.
-}
caption : List (Attribute m p) -> List (Html m p) -> Html m p
caption =
    node "caption"


{-| Represents a set of one or more columns of a table.
-}
colgroup : List (Attribute m p) -> List (Html m p) -> Html m p
colgroup =
    node "colgroup"


{-| Represents a column of a table.
-}
col : List (Attribute m p) -> Html m p
col attributes =
    node "col" attributes []


{-| Represents the block of rows that describes the concrete data of a table.
-}
tbody : List (Attribute m p) -> List (Html m p) -> Html m p
tbody =
    node "tbody"


{-| Represents the block of rows that describes the column labels of a table.
-}
thead : List (Attribute m p) -> List (Html m p) -> Html m p
thead =
    node "thead"


{-| Represents the block of rows that describes the column summaries of a table.
-}
tfoot : List (Attribute m p) -> List (Html m p) -> Html m p
tfoot =
    node "tfoot"


{-| Represents a row of cells in a table.
-}
tr : List (Attribute m p) -> List (Html m p) -> Html m p
tr =
    node "tr"


{-| Represents a data cell in a table.
-}
td : List (Attribute m p) -> List (Html m p) -> Html m p
td =
    node "td"


{-| Represents a header cell in a table.
-}
th : List (Attribute m p) -> List (Html m p) -> Html m p
th =
    node "th"



-- FORMS


{-| Represents a form, consisting of controls, that can be submitted to a
server for processing.
-}
form : List (Attribute m p) -> List (Html m p) -> Html m p
form =
    node "form"


{-| Represents a set of controls.
-}
fieldset : List (Attribute m p) -> List (Html m p) -> Html m p
fieldset =
    node "fieldset"


{-| Represents the caption for a `fieldset`.
-}
legend : List (Attribute m p) -> List (Html m p) -> Html m p
legend =
    node "legend"


{-| Represents the caption of a form pontrol.
-}
label : List (Attribute m p) -> List (Html m p) -> Html m p
label =
    node "label"


{-| Represents a typed data field allowing the user to edit the data.
-}
input : List (Attribute m p) -> Html m p
input attributes =
    node "input" attributes []


{-| Represents a button.
-}
button : List (Attribute m p) -> List (Html m p) -> Html m p
button =
    node "button"


{-| Represents a control allowing selection among a set of options.
-}
select : List (Attribute m p) -> List (Html m p) -> Html m p
select =
    node "select"


{-| Represents a set of predefined options for other controls.
-}
datalist : List (Attribute m p) -> List (Html m p) -> Html m p
datalist =
    node "datalist"


{-| Represents a set of options, logically grouped.
-}
optgroup : List (Attribute m p) -> List (Html m p) -> Html m p
optgroup =
    node "optgroup"


{-| Represents an option in a `select` element or a suggestion of a `datalist`
element.
-}
option : List (Attribute m p) -> List (Html m p) -> Html m p
option =
    node "option"


{-| Represents a multiline text edit control.
-}
textarea : List (Attribute m p) -> List (Html m p) -> Html m p
textarea =
    node "textarea"


{-| Represents a key-pair generator control.
-}
keygen : List (Attribute m p) -> List (Html m p) -> Html m p
keygen =
    node "keygen"


{-| Represents the result of a calculation.
-}
output : List (Attribute m p) -> List (Html m p) -> Html m p
output =
    node "output"


{-| Represents the completion progress of a task.
-}
progress : List (Attribute m p) -> List (Html m p) -> Html m p
progress =
    node "progress"


{-| Represents a scalar measurement (or a fractional value), within a known
range.
-}
meter : List (Attribute m p) -> List (Html m p) -> Html m p
meter =
    node "meter"



-- INTERACTIVE ELEMENTS


{-| Represents a widget from which the user can obtain additional information
or controls.
-}
details : List (Attribute m p) -> List (Html m p) -> Html m p
details =
    node "details"


{-| Represents a summary, caption, or legend for a given `details`.
-}
summary : List (Attribute m p) -> List (Html m p) -> Html m p
summary =
    node "summary"


{-| Represents a command that the user can invoke.
-}
menuitem : List (Attribute m p) -> List (Html m p) -> Html m p
menuitem =
    node "menuitem"


{-| Represents a list of commands.
-}
menu : List (Attribute m p) -> List (Html m p) -> Html m p
menu =
    node "menu"
