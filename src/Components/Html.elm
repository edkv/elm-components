module Components.Html
    exposing
        ( Attribute
        , Component
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
        , slot
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

import Components exposing (Container, Slot)
import Components.Internal.Core as Core
import Components.Internal.Elements as Elements
import Components.Internal.Shared
    exposing
        ( HtmlAttribute(HtmlAttribute)
        , HtmlComponent(HtmlComponent)
        , HtmlNode(HtmlNode)
        )


type alias Html c m =
    HtmlNode c m


type alias Attribute c m =
    HtmlAttribute c m


type alias Component container c m =
    HtmlComponent container c m


{-| General way to create HTML nodes. It is used to define all of the helper
functions in this library.

    div : List (Attribute c m) -> List (Html c m) -> Html c m
    div attributes children =
        node "div" attributes children

You can use this to create custom nodes if you need to create something that
is not covered by the helper functions in this library.

-}
node : String -> List (Attribute c m) -> List (Html c m) -> Html c m
node tag attributes children =
    HtmlNode <|
        Elements.element tag
            (List.map (\(HtmlAttribute attr) -> attr) attributes)
            (List.map (\(HtmlNode node) -> node) children)


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"

-}
text : String -> Html c m
text =
    Elements.textElement >> HtmlNode


none : Html c m
none =
    text ""


slot :
    Slot (Container c m s) pC
    -> Component (Container c m s) pC pM
    -> Html pC pM
slot slot_ (HtmlComponent (Core.Component component)) =
    HtmlNode (component slot_)



-- SECTIONS


{-| Represents the content of an HTML document. There is only one `body`
element in a document.
-}
body : List (Attribute c m) -> List (Html c m) -> Html c m
body =
    node "body"


{-| Defines a section in a document.
-}
section : List (Attribute c m) -> List (Html c m) -> Html c m
section =
    node "section"


{-| Defines a section that contains only navigation links.
-}
nav : List (Attribute c m) -> List (Html c m) -> Html c m
nav =
    node "nav"


{-| Defines self-contained content that could exist independently of the rest
of the content.
-}
article : List (Attribute c m) -> List (Html c m) -> Html c m
article =
    node "article"


{-| Defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside : List (Attribute c m) -> List (Html c m) -> Html c m
aside =
    node "aside"


{-| -}
h1 : List (Attribute c m) -> List (Html c m) -> Html c m
h1 =
    node "h1"


{-| -}
h2 : List (Attribute c m) -> List (Html c m) -> Html c m
h2 =
    node "h2"


{-| -}
h3 : List (Attribute c m) -> List (Html c m) -> Html c m
h3 =
    node "h3"


{-| -}
h4 : List (Attribute c m) -> List (Html c m) -> Html c m
h4 =
    node "h4"


{-| -}
h5 : List (Attribute c m) -> List (Html c m) -> Html c m
h5 =
    node "h5"


{-| -}
h6 : List (Attribute c m) -> List (Html c m) -> Html c m
h6 =
    node "h6"


{-| Defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.
-}
header : List (Attribute c m) -> List (Html c m) -> Html c m
header =
    node "header"


{-| Defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer : List (Attribute c m) -> List (Html c m) -> Html c m
footer =
    node "footer"


{-| Defines a section containing contact information.
-}
address : List (Attribute c m) -> List (Html c m) -> Html c m
address =
    node "address"


{-| Defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : List (Attribute c m) -> List (Html c m) -> Html c m
main_ =
    node "main"



-- GROUPING CONTENT


{-| Defines a portion that should be displayed as a paragraph.
-}
p : List (Attribute c m) -> List (Html c m) -> Html c m
p =
    node "p"


{-| Represents a thematic break between paragraphs of a section or article or
any longer content.
-}
hr : List (Attribute c m) -> Html c m
hr attributes =
    node "hr" attributes []


{-| Indicates that its content is preformatted and that this format must be
preserved.
-}
pre : List (Attribute c m) -> List (Html c m) -> Html c m
pre =
    node "pre"


{-| Represents a content that is quoted from another source.
-}
blockquote : List (Attribute c m) -> List (Html c m) -> Html c m
blockquote =
    node "blockquote"


{-| Defines an ordered list of items.
-}
ol : List (Attribute c m) -> List (Html c m) -> Html c m
ol =
    node "ol"


{-| Defines an unordered list of items.
-}
ul : List (Attribute c m) -> List (Html c m) -> Html c m
ul =
    node "ul"


{-| Defines a item of an enumeration list.
-}
li : List (Attribute c m) -> List (Html c m) -> Html c m
li =
    node "li"


{-| Defines a definition list, that is, a list of terms and their associated
definitions.
-}
dl : List (Attribute c m) -> List (Html c m) -> Html c m
dl =
    node "dl"


{-| Represents a term defined by the next `dd`.
-}
dt : List (Attribute c m) -> List (Html c m) -> Html c m
dt =
    node "dt"


{-| Represents the definition of the terms immediately listed before it.
-}
dd : List (Attribute c m) -> List (Html c m) -> Html c m
dd =
    node "dd"


{-| Represents a figure illustrated as part of the document.
-}
figure : List (Attribute c m) -> List (Html c m) -> Html c m
figure =
    node "figure"


{-| Represents the legend of a figure.
-}
figcaption : List (Attribute c m) -> List (Html c m) -> Html c m
figcaption =
    node "figcaption"


{-| Represents a generic container with no special meaning.
-}
div : List (Attribute c m) -> List (Html c m) -> Html c m
div =
    node "div"



-- TEXT LEVEL SEMANTIC


{-| Represents a hyperlink, linking to another resource.
-}
a : List (Attribute c m) -> List (Html c m) -> Html c m
a =
    node "a"


{-| Represents emphasized text, like a stress accent.
-}
em : List (Attribute c m) -> List (Html c m) -> Html c m
em =
    node "em"


{-| Represents especially important text.
-}
strong : List (Attribute c m) -> List (Html c m) -> Html c m
strong =
    node "strong"


{-| Represents a side comment, that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.
-}
small : List (Attribute c m) -> List (Html c m) -> Html c m
small =
    node "small"


{-| Represents content that is no longer accurate or relevant.
-}
s : List (Attribute c m) -> List (Html c m) -> Html c m
s =
    node "s"


{-| Represents the title of a work.
-}
cite : List (Attribute c m) -> List (Html c m) -> Html c m
cite =
    node "cite"


{-| Represents an inline quotation.
-}
q : List (Attribute c m) -> List (Html c m) -> Html c m
q =
    node "q"


{-| Represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn : List (Attribute c m) -> List (Html c m) -> Html c m
dfn =
    node "dfn"


{-| Represents an abbreviation or an acronym; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr : List (Attribute c m) -> List (Html c m) -> Html c m
abbr =
    node "abbr"


{-| Represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
time : List (Attribute c m) -> List (Html c m) -> Html c m
time =
    node "time"


{-| Represents computer code.
-}
code : List (Attribute c m) -> List (Html c m) -> Html c m
code =
    node "code"


{-| Represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var : List (Attribute c m) -> List (Html c m) -> Html c m
var =
    node "var"


{-| Represents the output of a program or a computer.
-}
samp : List (Attribute c m) -> List (Html c m) -> Html c m
samp =
    node "samp"


{-| Represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.
-}
kbd : List (Attribute c m) -> List (Html c m) -> Html c m
kbd =
    node "kbd"


{-| Represent a subscript.
-}
sub : List (Attribute c m) -> List (Html c m) -> Html c m
sub =
    node "sub"


{-| Represent a superscript.
-}
sup : List (Attribute c m) -> List (Html c m) -> Html c m
sup =
    node "sup"


{-| Represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i : List (Attribute c m) -> List (Html c m) -> Html c m
i =
    node "i"


{-| Represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b : List (Attribute c m) -> List (Html c m) -> Html c m
b =
    node "b"


{-| Represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u : List (Attribute c m) -> List (Html c m) -> Html c m
u =
    node "u"


{-| Represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark : List (Attribute c m) -> List (Html c m) -> Html c m
mark =
    node "mark"


{-| Represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby : List (Attribute c m) -> List (Html c m) -> Html c m
ruby =
    node "ruby"


{-| Represents the text of a ruby annotation.
-}
rt : List (Attribute c m) -> List (Html c m) -> Html c m
rt =
    node "rt"


{-| Represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp : List (Attribute c m) -> List (Html c m) -> Html c m
rp =
    node "rp"


{-| Represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi : List (Attribute c m) -> List (Html c m) -> Html c m
bdi =
    node "bdi"


{-| Represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo : List (Attribute c m) -> List (Html c m) -> Html c m
bdo =
    node "bdo"


{-| Represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like `class`, `lang`, or `dir`.
-}
span : List (Attribute c m) -> List (Html c m) -> Html c m
span =
    node "span"


{-| Represents a line break.
-}
br : List (Attribute c m) -> Html c m
br attributes =
    node "br" attributes []


{-| Represents a line break opportunity, that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr : List (Attribute c m) -> Html c m
wbr attributes =
    node "wbr" attributes []



-- EDITS


{-| Defines an addition to the document.
-}
ins : List (Attribute c m) -> List (Html c m) -> Html c m
ins =
    node "ins"


{-| Defines a removal from the document.
-}
del : List (Attribute c m) -> List (Html c m) -> Html c m
del =
    node "del"



-- EMBEDDED CONTENT


{-| Represents an image.
-}
img : List (Attribute c m) -> Html c m
img attributes =
    node "img" attributes []


{-| Embedded an HTML document.
-}
iframe : List (Attribute c m) -> List (Html c m) -> Html c m
iframe =
    node "iframe"


{-| Represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed : List (Attribute c m) -> Html c m
embed attributes =
    node "embed" attributes []


{-| Represents an external resource, which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object : List (Attribute c m) -> List (Html c m) -> Html c m
object =
    node "object"


{-| Defines parameters for use by plug-ins invoked by `object` elements.
-}
param : List (Attribute c m) -> Html c m
param attributes =
    node "param" attributes []


{-| Represents a video, the associated audio and captions, and controls.
-}
video : List (Attribute c m) -> List (Html c m) -> Html c m
video =
    node "video"


{-| Represents a sound or audio stream.
-}
audio : List (Attribute c m) -> List (Html c m) -> Html c m
audio =
    node "audio"


{-| Allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
source : List (Attribute c m) -> Html c m
source attributes =
    node "source" attributes []


{-| Allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
track : List (Attribute c m) -> Html c m
track attributes =
    node "track" attributes []


{-| Represents a bitmap area for graphics rendering.
-}
canvas : List (Attribute c m) -> List (Html c m) -> Html c m
canvas =
    node "canvas"


{-| Defines a mathematical formula.
-}
math : List (Attribute c m) -> List (Html c m) -> Html c m
math =
    node "math"



-- TABULAR DATA


{-| Represents data with more than one dimension.
-}
table : List (Attribute c m) -> List (Html c m) -> Html c m
table =
    node "table"


{-| Represents the title of a table.
-}
caption : List (Attribute c m) -> List (Html c m) -> Html c m
caption =
    node "caption"


{-| Represents a set of one or more columns of a table.
-}
colgroup : List (Attribute c m) -> List (Html c m) -> Html c m
colgroup =
    node "colgroup"


{-| Represents a column of a table.
-}
col : List (Attribute c m) -> Html c m
col attributes =
    node "col" attributes []


{-| Represents the block of rows that describes the concrete data of a table.
-}
tbody : List (Attribute c m) -> List (Html c m) -> Html c m
tbody =
    node "tbody"


{-| Represents the block of rows that describes the column labels of a table.
-}
thead : List (Attribute c m) -> List (Html c m) -> Html c m
thead =
    node "thead"


{-| Represents the block of rows that describes the column summaries of a table.
-}
tfoot : List (Attribute c m) -> List (Html c m) -> Html c m
tfoot =
    node "tfoot"


{-| Represents a row of cells in a table.
-}
tr : List (Attribute c m) -> List (Html c m) -> Html c m
tr =
    node "tr"


{-| Represents a data cell in a table.
-}
td : List (Attribute c m) -> List (Html c m) -> Html c m
td =
    node "td"


{-| Represents a header cell in a table.
-}
th : List (Attribute c m) -> List (Html c m) -> Html c m
th =
    node "th"



-- FORMS


{-| Represents a form, consisting of controls, that can be submitted to a
server for processing.
-}
form : List (Attribute c m) -> List (Html c m) -> Html c m
form =
    node "form"


{-| Represents a set of controls.
-}
fieldset : List (Attribute c m) -> List (Html c m) -> Html c m
fieldset =
    node "fieldset"


{-| Represents the caption for a `fieldset`.
-}
legend : List (Attribute c m) -> List (Html c m) -> Html c m
legend =
    node "legend"


{-| Represents the caption of a form control.
-}
label : List (Attribute c m) -> List (Html c m) -> Html c m
label =
    node "label"


{-| Represents a typed data field allowing the user to edit the data.
-}
input : List (Attribute c m) -> Html c m
input attributes =
    node "input" attributes []


{-| Represents a button.
-}
button : List (Attribute c m) -> List (Html c m) -> Html c m
button =
    node "button"


{-| Represents a control allowing selection among a set of options.
-}
select : List (Attribute c m) -> List (Html c m) -> Html c m
select =
    node "select"


{-| Represents a set of predefined options for other controls.
-}
datalist : List (Attribute c m) -> List (Html c m) -> Html c m
datalist =
    node "datalist"


{-| Represents a set of options, logically grouped.
-}
optgroup : List (Attribute c m) -> List (Html c m) -> Html c m
optgroup =
    node "optgroup"


{-| Represents an option in a `select` element or a suggestion of a `datalist`
element.
-}
option : List (Attribute c m) -> List (Html c m) -> Html c m
option =
    node "option"


{-| Represents a multiline text edit control.
-}
textarea : List (Attribute c m) -> List (Html c m) -> Html c m
textarea =
    node "textarea"


{-| Represents a key-pair generator control.
-}
keygen : List (Attribute c m) -> List (Html c m) -> Html c m
keygen =
    node "keygen"


{-| Represents the result of a calculation.
-}
output : List (Attribute c m) -> List (Html c m) -> Html c m
output =
    node "output"


{-| Represents the completion progress of a task.
-}
progress : List (Attribute c m) -> List (Html c m) -> Html c m
progress =
    node "progress"


{-| Represents a scalar measurement (or a fractional value), within a known
range.
-}
meter : List (Attribute c m) -> List (Html c m) -> Html c m
meter =
    node "meter"



-- INTERACTIVE ELEMENTS


{-| Represents a widget from which the user can obtain additional information
or controls.
-}
details : List (Attribute c m) -> List (Html c m) -> Html c m
details =
    node "details"


{-| Represents a summary, caption, or legend for a given `details`.
-}
summary : List (Attribute c m) -> List (Html c m) -> Html c m
summary =
    node "summary"


{-| Represents a command that the user can invoke.
-}
menuitem : List (Attribute c m) -> List (Html c m) -> Html c m
menuitem =
    node "menuitem"


{-| Represents a list of commands.
-}
menu : List (Attribute c m) -> List (Html c m) -> Html c m
menu =
    node "menu"
