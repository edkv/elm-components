module Components.Html.Attributes
    exposing
        ( accept
        , acceptCharset
        , accesskey
        , action
        , align
        , alt
        , async
        , attribute
        , autocomplete
        , autofocus
        , autoplay
        , challenge
        , charset
        , checked
        , cite
        , class
        , classList
        , cols
        , colspan
        , content
        , contenteditable
        , contextmenu
        , controls
        , coords
        , datetime
        , default
        , defaultValue
        , defer
        , dir
        , disabled
        , download
        , downloadAs
        , draggable
        , dropzone
        , enctype
        , for
        , form
        , formaction
        , headers
        , height
        , hidden
        , href
        , hreflang
        , httpEquiv
        , id
        , inlineStyles
        , ismap
        , itemprop
        , keytype
        , kind
        , lang
        , language
        , list
        , loop
        , manifest
        , max
        , maxlength
        , media
        , method
        , min
        , minlength
        , multiple
        , name
        , novalidate
        , pattern
        , ping
        , placeholder
        , poster
        , preload
        , property
        , pubdate
        , readonly
        , rel
        , required
        , reversed
        , rows
        , rowspan
        , sandbox
        , scope
        , scoped
        , seamless
        , selected
        , shape
        , size
        , spellcheck
        , src
        , srcdoc
        , srclang
        , start
        , step
        , styles
        , tabindex
        , target
        , title
        , type_
        , usemap
        , value
        , width
        , wrap
        )

{-| Helper functions for HTML attributes. They are organized roughly by
category. Each attribute is labeled with the HTML tags it can be used with, so
just search the page for `video` if you want video stuff.


# Primitives

@docs property, attribute


# CSS

@docs styles, inlineStyles


# Super Common Attributes

@docs class, classList, id, title, hidden


# Inputs

@docs type_, value, defaultValue, checked, placeholder, selected


## Input Helpers

@docs accept, acceptCharset, action, autocomplete, autofocus, disabled, enctype, formaction, list, maxlength, minlength, method, multiple, name, novalidate, pattern, readonly, required, size, for, form


## Input Ranges

@docs max, min, step


## Input Text Areas

@docs cols, rows, wrap


# Links and Areas

@docs href, target, download, downloadAs, hreflang, media, ping, rel


## Maps

@docs ismap, usemap, shape, coords


# Embedded Content

@docs src, height, width, alt


## Audio and Video

@docs autoplay, controls, loop, preload, poster, default, kind, srclang


## iframes

@docs sandbox, seamless, srcdoc


# Ordered Lists

@docs reversed, start


# Tables

@docs align, colspan, rowspan, headers, scope


# Header Stuff

@docs async, charset, content, defer, httpEquiv, language, scoped


# Less Common Global Attributes

Attributes that can be attached to any HTML tag but are less commonly used.

@docs accesskey, contenteditable, contextmenu, dir, draggable, dropzone, itemprop, lang, spellcheck, tabindex


# Key Generation

@docs challenge, keytype


# Miscellaneous

@docs cite, datetime, pubdate, manifest

-}

import Components.Html exposing (Attribute)
import Components.Internal.Elements as Elements
import Components.Internal.Shared exposing (HtmlAttribute(HtmlAttribute))
import Css
import Json.Encode


{-| Create _properties_, like saying `domNode.className = 'greeting'` in
JavaScript.

    import Json.Encode

    class : String -> Attribute c m
    class name =
        property "className" (Json.Encode.string name)

Read more about the difference between properties and attributes [here].
[here]: <https://github.com/elm-lang/html/blob/master/properties-vs-attributes.md>

-}
property : String -> Json.Encode.Value -> Attribute c m
property name value =
    HtmlAttribute (Elements.property name value)


stringProperty : String -> String -> Attribute c m
stringProperty name string =
    property name (Json.Encode.string string)


boolProperty : String -> Bool -> Attribute c m
boolProperty name bool =
    property name (Json.Encode.bool bool)


{-| Create _attributes_, like saying `domNode.setAttribute('class', 'greeting')`
in JavaScript.

    class : String -> Attribute c m
    class name =
        attribute "class" name

Read more about the difference between properties and attributes [here].
[here]: <https://github.com/elm-lang/html/blob/master/properties-vs-attributes.md>

-}
attribute : String -> String -> Attribute c m
attribute name value =
    HtmlAttribute (Elements.attribute name value)


{-| Apply styles to an element. See the
[`Css` module documentation](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
for an overview of how to use this function.
-}
styles : List Css.Style -> Attribute c m
styles =
    Elements.htmlStyles >> HtmlAttribute


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.

    myStyle : Attribute c m
    myStyle =
        inlineStyles
            [ ( "backgroundColor", "red" )
            , ( "height", "90px" )
            , ( "width", "100%" )
            ]

    greeting : Html c m
    greeting =
        div [ myStyle ] [ text "Hello!" ]

-}
inlineStyles : List ( String, String ) -> Attribute c m
inlineStyles =
    Elements.inlineStyles >> HtmlAttribute


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with. For example, maybe we want a way to view notices:

    viewNotice : Notice -> Html c m
    viewNotice notice =
        div
            [ classList
                [ ( "notice", True )
                , ( "notice-important", notice.isImportant )
                , ( "notice-seen", notice.isSeen )
                ]
            ]
            [ text notice.content ]

-}
classList : List ( String, Bool ) -> Attribute c m
classList list =
    list
        |> List.filter Tuple.second
        |> List.map Tuple.first
        |> String.join " "
        |> class



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.
-}
class : String -> Attribute c m
class name =
    stringProperty "className" name


{-| Indicates the relevance of an element.
-}
hidden : Bool -> Attribute c m
hidden bool =
    boolProperty "hidden" bool


{-| Often used with CSS to style a specific element. The value of this
attribute must be unique.
-}
id : String -> Attribute c m
id name =
    stringProperty "id" name


{-| Text to be displayed in a tooltip when hovering over the element.
-}
title : String -> Attribute c m
title name =
    stringProperty "title" name



-- LESS COMMON GLOBAL ATTRIBUTES


{-| Defines a keyboard shortcut to activate or add focus to the element.
-}
accesskey : Char -> Attribute c m
accesskey char =
    stringProperty "accessKey" (String.fromChar char)


{-| Indicates whether the element's content is editable.
-}
contenteditable : Bool -> Attribute c m
contenteditable bool =
    boolProperty "contentEditable" bool


{-| Defines the ID of a `menu` element which will serve as the element's
context menu.
-}
contextmenu : String -> Attribute c m
contextmenu value =
    attribute "contextmenu" value


{-| Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl
(Right-To-Left).
-}
dir : String -> Attribute c m
dir value =
    stringProperty "dir" value


{-| Defines whether the element can be dragged.
-}
draggable : String -> Attribute c m
draggable value =
    attribute "draggable" value


{-| Indicates that the element accept the dropping of content on it.
-}
dropzone : String -> Attribute c m
dropzone value =
    stringProperty "dropzone" value


{-| -}
itemprop : String -> Attribute c m
itemprop value =
    attribute "itemprop" value


{-| Defines the language used in the element.
-}
lang : String -> Attribute c m
lang value =
    stringProperty "lang" value


{-| Indicates whether spell checking is allowed for the element.
-}
spellcheck : Bool -> Attribute c m
spellcheck bool =
    boolProperty "spellcheck" bool


{-| Overrides the browser's default tab order and follows the one specified
instead.
-}
tabindex : Int -> Attribute c m
tabindex n =
    attribute "tabIndex" (toString n)



-- HEADER STUFF


{-| Indicates that the `script` should be executed asynchronously.
-}
async : Bool -> Attribute c m
async bool =
    boolProperty "async" bool


{-| Declares the character encoding of the page or script. Common values include:

  - UTF-8 - Character encoding for Unicode
  - ISO-8859-1 - Character encoding for the Latin alphabet
    For `meta` and `script`.

-}
charset : String -> Attribute c m
charset value =
    attribute "charset" value


{-| A value associated with http-equiv or name depending on the context. For
`meta`.
-}
content : String -> Attribute c m
content value =
    stringProperty "content" value


{-| Indicates that a `script` should be executed after the page has been
parsed.
-}
defer : Bool -> Attribute c m
defer bool =
    boolProperty "defer" bool


{-| This attribute is an indicator that is paired with the `content` attribute,
indicating what that content means. `httpEquiv` can take on three different
values: content-type, default-style, or refresh. For `meta`.
-}
httpEquiv : String -> Attribute c m
httpEquiv value =
    stringProperty "httpEquiv" value


{-| Defines the script language used in a `script`.
-}
language : String -> Attribute c m
language value =
    stringProperty "language" value


{-| Indicates that a `style` should only apply to its parent and all of the
parents children.
-}
scoped : Bool -> Attribute c m
scoped bool =
    boolProperty "scoped" bool



-- EMBEDDED CONTENT


{-| The URL of the embeddable content. For `audio`, `embed`, `iframe`, `img`,
`input`, `script`, `source`, `track`, and `video`.
-}
src : String -> Attribute c m
src value =
    stringProperty "src" value


{-| Declare the height of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
height : Int -> Attribute c m
height value =
    attribute "height" (toString value)


{-| Declare the width of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
width : Int -> Attribute c m
width value =
    attribute "width" (toString value)


{-| Alternative text in case an image can't be displayed. Works with `img`,
`area`, and `input`.
-}
alt : String -> Attribute c m
alt value =
    stringProperty "alt" value



-- AUDIO and VIDEO


{-| The `audio` or `video` should play as soon as possible.
-}
autoplay : Bool -> Attribute c m
autoplay bool =
    boolProperty "autoplay" bool


{-| Indicates whether the browser should show playback controls for the `audio`
or `video`.
-}
controls : Bool -> Attribute c m
controls bool =
    boolProperty "controls" bool


{-| Indicates whether the `audio` or `video` should start playing from the
start when it's finished.
-}
loop : Bool -> Attribute c m
loop bool =
    boolProperty "loop" bool


{-| Control how much of an `audio` or `video` resource should be preloaded.
-}
preload : String -> Attribute c m
preload value =
    stringProperty "preload" value


{-| A URL indicating a poster frame to show until the user plays or seeks the
`video`.
-}
poster : String -> Attribute c m
poster value =
    stringProperty "poster" value


{-| Indicates that the `track` should be enabled unless the user's preferences
indicate something different.
-}
default : Bool -> Attribute c m
default bool =
    boolProperty "default" bool


{-| Specifies the kind of text `track`.
-}
kind : String -> Attribute c m
kind value =
    stringProperty "kind" value


{-| A two letter language code indicating the language of the `track` text data.
-}
srclang : String -> Attribute c m
srclang value =
    stringProperty "srclang" value



-- IFRAMES


{-| A space separated list of security restrictions you'd like to lift for an
`iframe`.
-}
sandbox : String -> Attribute c m
sandbox value =
    stringProperty "sandbox" value


{-| Make an `iframe` look like part of the containing document.
-}
seamless : Bool -> Attribute c m
seamless bool =
    boolProperty "seamless" bool


{-| An HTML document that will be displayed as the body of an `iframe`. It will
override the content of the `src` attribute if it has been specified.
-}
srcdoc : String -> Attribute c m
srcdoc value =
    stringProperty "srcdoc" value



-- INPUT


{-| Defines the type of a `button`, `input`, `embed`, `object`, `script`,
`source`, `style`, or `menu`.
-}
type_ : String -> Attribute c m
type_ value =
    stringProperty "type" value


{-| Defines a default value which will be displayed in a `button`, `option`,
`input`, `li`, `meter`, `progress`, or `param`.
-}
value : String -> Attribute c m
value value =
    stringProperty "value" value


{-| Defines an initial value which will be displayed in an `input` when that
`input` is added to the DOM. Unlike `value`, altering `defaultValue` after the
`input` element has been added to the DOM has no effect.
-}
defaultValue : String -> Attribute c m
defaultValue value =
    stringProperty "defaultValue" value


{-| Indicates whether an `input` of type checkbox is checked.
-}
checked : Bool -> Attribute c m
checked bool =
    boolProperty "checked" bool


{-| Provides a hint to the user of what can be entered into an `input` or
`textarea`.
-}
placeholder : String -> Attribute c m
placeholder value =
    stringProperty "placeholder" value


{-| Defines which `option` will be selected on page load.
-}
selected : Bool -> Attribute c m
selected bool =
    boolProperty "selected" bool



-- INPUT HELPERS


{-| List of types the server accepts, typically a file type.
For `form` and `input`.
-}
accept : String -> Attribute c m
accept value =
    stringProperty "accept" value


{-| List of supported charsets in a `form`.
-}
acceptCharset : String -> Attribute c m
acceptCharset value =
    stringProperty "acceptCharset" value


{-| The URI of a program that processes the information submitted via a `form`.
-}
action : String -> Attribute c m
action value =
    stringProperty "action" value


{-| Indicates whether a `form` or an `input` can have their values automatically
completed by the browser.
-}
autocomplete : Bool -> Attribute c m
autocomplete bool =
    stringProperty "autocomplete"
        (if bool then
            "on"
         else
            "off"
        )


{-| The element should be automatically focused after the page loaded.
For `button`, `input`, `keygen`, `select`, and `textarea`.
-}
autofocus : Bool -> Attribute c m
autofocus bool =
    boolProperty "autofocus" bool


{-| Indicates whether the user can interact with a `button`, `fieldset`,
`input`, `keygen`, `optgroup`, `option`, `select` or `textarea`.
-}
disabled : Bool -> Attribute c m
disabled bool =
    boolProperty "disabled" bool


{-| How `form` data should be encoded when submitted with the POST method.
Options include: application/x-www-form-urlencoded, multipart/form-data, and
text/plain.
-}
enctype : String -> Attribute c m
enctype value =
    stringProperty "enctype" value


{-| Indicates the action of an `input` or `button`. This overrides the action
defined in the surrounding `form`.
-}
formaction : String -> Attribute c m
formaction value =
    attribute "formAction" value


{-| Associates an `input` with a `datalist` tag. The datalist gives some
pre-defined options to suggest to the user as they interact with an input.
The value of the list attribute must match the id of a `datalist` node.
For `input`.
-}
list : String -> Attribute c m
list value =
    attribute "list" value


{-| Defines the minimum number of characters allowed in an `input` or
`textarea`.
-}
minlength : Int -> Attribute c m
minlength n =
    attribute "minLength" (toString n)


{-| Defines the maximum number of characters allowed in an `input` or
`textarea`.
-}
maxlength : Int -> Attribute c m
maxlength n =
    attribute "maxlength" (toString n)


{-| Defines which HTTP method to use when submitting a `form`. Can be GET
(default) or POST.
-}
method : String -> Attribute c m
method value =
    stringProperty "method" value


{-| Indicates whether multiple values can be entered in an `input` of type
email or file. Can also indicate that you can `select` many options.
-}
multiple : Bool -> Attribute c m
multiple bool =
    boolProperty "multiple" bool


{-| Name of the element. For example used by the server to identify the fields
in form submits. For `button`, `form`, `fieldset`, `iframe`, `input`, `keygen`,
`object`, `output`, `select`, `textarea`, `map`, `meta`, and `param`.
-}
name : String -> Attribute c m
name value =
    stringProperty "name" value


{-| This attribute indicates that a `form` shouldn't be validated when
submitted.
-}
novalidate : Bool -> Attribute c m
novalidate bool =
    boolProperty "noValidate" bool


{-| Defines a regular expression which an `input`'s value will be validated
against.
-}
pattern : String -> Attribute c m
pattern value =
    stringProperty "pattern" value


{-| Indicates whether an `input` or `textarea` can be edited.
-}
readonly : Bool -> Attribute c m
readonly bool =
    boolProperty "readOnly" bool


{-| Indicates whether this element is required to fill out or not.
For `input`, `select`, and `textarea`.
-}
required : Bool -> Attribute c m
required bool =
    boolProperty "required" bool


{-| For `input` specifies the width of an input in characters.
For `select` specifies the number of visible options in a drop-down list.
-}
size : Int -> Attribute c m
size n =
    attribute "size" (toString n)


{-| The element ID described by this `label` or the element IDs that are used
for an `output`.
-}
for : String -> Attribute c m
for value =
    stringProperty "htmlFor" value


{-| Indicates the element ID of the `form` that owns this particular `button`,
`fieldset`, `input`, `keygen`, `label`, `meter`, `object`, `output`,
`progress`, `select`, or `textarea`.
-}
form : String -> Attribute c m
form value =
    attribute "form" value



-- RANGES


{-| Indicates the maximum value allowed. When using an input of type number or
date, the max value must be a number or date. For `input`, `meter`, and `progress`.
-}
max : String -> Attribute c m
max value =
    stringProperty "max" value


{-| Indicates the minimum value allowed. When using an input of type number or
date, the min value must be a number or date. For `input` and `meter`.
-}
min : String -> Attribute c m
min value =
    stringProperty "min" value


{-| Add a step size to an `input`. Use `step "any"` to allow any floating-point
number to be used in the input.
-}
step : String -> Attribute c m
step n =
    stringProperty "step" n



--------------------------


{-| Defines the number of columns in a `textarea`.
-}
cols : Int -> Attribute c m
cols n =
    attribute "cols" (toString n)


{-| Defines the number of rows in a `textarea`.
-}
rows : Int -> Attribute c m
rows n =
    attribute "rows" (toString n)


{-| Indicates whether the text should be wrapped in a `textarea`. Possible
values are "hard" and "soft".
-}
wrap : String -> Attribute c m
wrap value =
    stringProperty "wrap" value



-- MAPS


{-| When an `img` is a descendent of an `a` tag, the `ismap` attribute
indicates that the click location should be added to the parent `a`'s href as
a query string.
-}
ismap : Bool -> Attribute c m
ismap value =
    boolProperty "isMap" value


{-| Specify the hash name reference of a `map` that should be used for an `img`
or `object`. A hash name reference is a hash symbol followed by the element's name or id.
E.g. `"#planet-map"`.
-}
usemap : String -> Attribute c m
usemap value =
    stringProperty "useMap" value


{-| Declare the shape of the clickable area in an `a` or `area`. Valid values
include: default, rect, circle, poly. This attribute can be paired with
`coords` to create more particular shapes.
-}
shape : String -> Attribute c m
shape value =
    stringProperty "shape" value


{-| A set of values specifying the coordinates of the hot-spot region in an
`area`. Needs to be paired with a `shape` attribute to be meaningful.
-}
coords : String -> Attribute c m
coords value =
    stringProperty "coords" value



-- KEY GEN


{-| A challenge string that is submitted along with the public key in a `keygen`.
-}
challenge : String -> Attribute c m
challenge value =
    attribute "challenge" value


{-| Specifies the type of key generated by a `keygen`. Possible values are:
rsa, dsa, and ec.
-}
keytype : String -> Attribute c m
keytype value =
    stringProperty "keytype" value



-- REAL STUFF


{-| Specifies the horizontal alignment of a `caption`, `col`, `colgroup`,
`hr`, `iframe`, `img`, `table`, `tbody`, `td`, `tfoot`, `th`, `thead`, or
`tr`.
-}
align : String -> Attribute c m
align value =
    stringProperty "align" value


{-| Contains a URI which points to the source of the quote or change in a
`blockquote`, `del`, `ins`, or `q`.
-}
cite : String -> Attribute c m
cite value =
    stringProperty "cite" value



-- LINKS AND AREAS


{-| The URL of a linked resource, such as `a`, `area`, `base`, or `link`.
-}
href : String -> Attribute c m
href value =
    stringProperty "href" value


{-| Specify where the results of clicking an `a`, `area`, `base`, or `form`
should appear. Possible special values include:

  - _blank &mdash; a new window or tab
  - _self &mdash; the same frame (this is default)
  - _parent &mdash; the parent frame
  - _top &mdash; the full body of the window
    You can also give the name of any `frame` you have created.

-}
target : String -> Attribute c m
target value =
    stringProperty "target" value


{-| Indicates that clicking an `a` and `area` will download the resource
directly.
-}
download : Bool -> Attribute c m
download bool =
    boolProperty "download" bool


{-| Indicates that clicking an `a` and `area` will download the resource
directly, and that the downloaded resource with have the given filename.
-}
downloadAs : String -> Attribute c m
downloadAs value =
    stringProperty "download" value


{-| Two-letter language code of the linked resource of an `a`, `area`, or `link`.
-}
hreflang : String -> Attribute c m
hreflang value =
    stringProperty "hreflang" value


{-| Specifies a hint of the target media of a `a`, `area`, `link`, `source`,
or `style`.
-}
media : String -> Attribute c m
media value =
    attribute "media" value


{-| Specify a URL to send a short POST request to when the user clicks on an
`a` or `area`. Useful for monitoring and tracking.
-}
ping : String -> Attribute c m
ping value =
    stringProperty "ping" value


{-| Specifies the relationship of the target object to the link object.
For `a`, `area`, `link`.
-}
rel : String -> Attribute c m
rel value =
    attribute "rel" value



-- CRAZY STUFF


{-| Indicates the date and time associated with the element.
For `del`, `ins`, `time`.
-}
datetime : String -> Attribute c m
datetime value =
    attribute "datetime" value


{-| Indicates whether this date and time is the date of the nearest `article`
ancestor element. For `time`.
-}
pubdate : String -> Attribute c m
pubdate value =
    attribute "pubdate" value



-- ORDERED LISTS


{-| Indicates whether an ordered list `ol` should be displayed in a descending
order instead of a ascending.
-}
reversed : Bool -> Attribute c m
reversed bool =
    boolProperty "reversed" bool


{-| Defines the first number of an ordered list if you want it to be something
besides 1.
-}
start : Int -> Attribute c m
start n =
    stringProperty "start" (toString n)



-- TABLES


{-| The colspan attribute defines the number of columns a cell should span.
For `td` and `th`.
-}
colspan : Int -> Attribute c m
colspan n =
    attribute "colspan" (toString n)


{-| A space separated list of element IDs indicating which `th` elements are
headers for this cell. For `td` and `th`.
-}
headers : String -> Attribute c m
headers value =
    stringProperty "headers" value


{-| Defines the number of rows a table cell should span over.
For `td` and `th`.
-}
rowspan : Int -> Attribute c m
rowspan n =
    attribute "rowspan" (toString n)


{-| Specifies the scope of a header cell `th`. Possible values are: col, row,
colgroup, rowgroup.
-}
scope : String -> Attribute c m
scope value =
    stringProperty "scope" value


{-| Specifies the URL of the cache manifest for an `html` tag.
-}
manifest : String -> Attribute c m
manifest value =
    attribute "manifest" value