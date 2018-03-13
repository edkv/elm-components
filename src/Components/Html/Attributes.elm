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
        , map
        , max
        , maxlength
        , media
        , method
        , min
        , minlength
        , multiple
        , name
        , none
        , novalidate
        , pattern
        , ping
        , placeholder
        , plain
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

{-| Differences from the `elm-lang/html` package:

  - New functions: [`none`](#none), [`plain`](#plain) and [`styles`](#styles).
    The last one allows you to specify dynamic styles via the
    [`elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest)
    package.
  - The
    [`style`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-Attributes#style)
    function is renamed to [`inlineStyles`](#inlineStyles).


# Primitives

@docs property, attribute, none, plain, map


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

import Components exposing (Signal)
import Components.Html exposing (Attribute)
import Components.Internal.Core as Core
import Components.Internal.Shared as Shared
import Css
import Json.Encode as Json
import VirtualDom


{-| Create _properties_, like saying `domNode.className = 'greeting'` in
JavaScript.

    import Json.Encode

    class : String -> Attribute msg parts
    class name =
        property "className" (Json.Encode.string name)

Read more about the difference between properties and attributes [here].
[here]: <https://github.com/elm-lang/html/blob/master/properties-vs-attributes.md>

-}
property : String -> Json.Value -> Attribute msg parts
property name value =
    VirtualDom.property name value
        |> Core.PlainAttribute


stringProperty : String -> String -> Attribute msg parts
stringProperty name string =
    property name (Json.string string)


boolProperty : String -> Bool -> Attribute msg parts
boolProperty name bool =
    property name (Json.bool bool)


{-| Create _attributes_, like saying `domNode.setAttribute('class', 'greeting')`
in JavaScript.

    class : String -> Attribute msg parts
    class name =
        attribute "class" name

Read more about the difference between properties and attributes [here].
[here]: <https://github.com/elm-lang/html/blob/master/properties-vs-attributes.md>

-}
attribute : String -> String -> Attribute msg parts
attribute name value =
    VirtualDom.attribute name value
        |> Core.PlainAttribute


{-| Don't generate any attribute.

    let
        class =
            if someCondition then
                Attributes.class "someClass"
            else
                Attributes.none

    in
    button [ class ] [ ...  ]

-}
none : Attribute msg parts
none =
    Core.NullAttribute


{-| Use an attribute that was created with another package like
[`elm-lang/html`](http://package.elm-lang.org/packages/elm-lang/html/latest).
-}
plain : VirtualDom.Property msg -> Attribute msg parts
plain =
    VirtualDom.mapProperty Core.LocalMsg
        >> Core.PlainAttribute


{-| Transform the [`Signal`s](Components#Signal) produced by an `Attribute`.
-}
map : (Signal a b -> Signal c d) -> Attribute a b -> Attribute c d
map =
    Shared.mapAttribute


{-| Apply styles to an element.

Styles are created with the help of
[`rtfeldman/elm-css`](http://package.elm-lang.org/packages/rtfeldman/elm-css/latest/Css)
package, so you need to install it.

-}
styles : List Css.Style -> Attribute msg parts
styles =
    Core.Styles Core.ClassNameProperty


{-| Specify a list of inline styles. This will generate a `style` attribute in
the DOM.

    myStyle : Attribute msg parts
    myStyle =
        inlineStyles
            [ ( "backgroundColor", "red" )
            , ( "height", "90px" )
            , ( "width", "100%" )
            ]

    greeting : Html msg parts
    greeting =
        div [ myStyle ] [ text "Hello!" ]

-}
inlineStyles : List ( String, String ) -> Attribute msg parts
inlineStyles =
    VirtualDom.style >> Core.PlainAttribute


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with. For example, maybe we want a way to view notices:

    viewNotice : Notice -> Html msg parts
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
classList : List ( String, Bool ) -> Attribute msg parts
classList list =
    list
        |> List.filter Tuple.second
        |> List.map Tuple.first
        |> String.join " "
        |> class



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.
-}
class : String -> Attribute msg parts
class name =
    stringProperty "className" name


{-| Indicates the relevance of an element.
-}
hidden : Bool -> Attribute msg parts
hidden bool =
    boolProperty "hidden" bool


{-| Often used with CSS to style a specific element. The value of this
attribute must be unique.
-}
id : String -> Attribute msg parts
id name =
    stringProperty "id" name


{-| Text to be displayed in a tooltip when hovering over the element.
-}
title : String -> Attribute msg parts
title name =
    stringProperty "title" name



-- LESS COMMON GLOBAL ATTRIBUTES


{-| Defines a keyboard shortcut to activate or add focus to the element.
-}
accesskey : Char -> Attribute msg parts
accesskey char =
    stringProperty "accessKey" (String.fromChar char)


{-| Indicates whether the element's content is editable.
-}
contenteditable : Bool -> Attribute msg parts
contenteditable bool =
    boolProperty "contentEditable" bool


{-| Defines the ID of a `menu` element which will serve as the element's
context menu.
-}
contextmenu : String -> Attribute msg parts
contextmenu value =
    attribute "contextmenu" value


{-| Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl
(Right-To-Left).
-}
dir : String -> Attribute msg parts
dir value =
    stringProperty "dir" value


{-| Defines whether the element can be dragged.
-}
draggable : String -> Attribute msg parts
draggable value =
    attribute "draggable" value


{-| Indicates that the element accept the dropping of content on it.
-}
dropzone : String -> Attribute msg parts
dropzone value =
    stringProperty "dropzone" value


{-| -}
itemprop : String -> Attribute msg parts
itemprop value =
    attribute "itemprop" value


{-| Defines the language used in the element.
-}
lang : String -> Attribute msg parts
lang value =
    stringProperty "lang" value


{-| Indicates whether spell checking is allowed for the element.
-}
spellcheck : Bool -> Attribute msg parts
spellcheck bool =
    boolProperty "spellcheck" bool


{-| Overrides the browser's default tab order and follows the one specified
instead.
-}
tabindex : Int -> Attribute msg parts
tabindex n =
    attribute "tabIndex" (toString n)



-- HEADER STUFF


{-| Indicates that the `script` should be executed asynchronously.
-}
async : Bool -> Attribute msg parts
async bool =
    boolProperty "async" bool


{-| Declares the character encoding of the page or script. Common values include:

  - UTF-8 - Character encoding for Unicode
  - ISO-8859-1 - Character encoding for the Latin alphabet
    For `meta` and `script`.

-}
charset : String -> Attribute msg parts
charset value =
    attribute "charset" value


{-| A value associated with http-equiv or name depending on the context. For
`meta`.
-}
content : String -> Attribute msg parts
content value =
    stringProperty "content" value


{-| Indicates that a `script` should be executed after the page has been
parsed.
-}
defer : Bool -> Attribute msg parts
defer bool =
    boolProperty "defer" bool


{-| This attribute is an indicator that is paired with the `content` attribute,
indicating what that content means. `httpEquiv` can take on three different
values: content-type, default-style, or refresh. For `meta`.
-}
httpEquiv : String -> Attribute msg parts
httpEquiv value =
    stringProperty "httpEquiv" value


{-| Defines the script language used in a `script`.
-}
language : String -> Attribute msg parts
language value =
    stringProperty "language" value


{-| Indicates that a `style` should only apply to its parent and all of the
parents children.
-}
scoped : Bool -> Attribute msg parts
scoped bool =
    boolProperty "scoped" bool



-- EMBEDDED CONTENT


{-| The URL of the embeddable content. For `audio`, `embed`, `iframe`, `img`,
`input`, `script`, `source`, `track`, and `video`.
-}
src : String -> Attribute msg parts
src value =
    stringProperty "src" value


{-| Declare the height of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
height : Int -> Attribute msg parts
height value =
    attribute "height" (toString value)


{-| Declare the width of a `canvas`, `embed`, `iframe`, `img`, `input`,
`object`, or `video`.
-}
width : Int -> Attribute msg parts
width value =
    attribute "width" (toString value)


{-| Alternative text in case an image can't be displayed. Works with `img`,
`area`, and `input`.
-}
alt : String -> Attribute msg parts
alt value =
    stringProperty "alt" value



-- AUDIO and VIDEO


{-| The `audio` or `video` should play as soon as possible.
-}
autoplay : Bool -> Attribute msg parts
autoplay bool =
    boolProperty "autoplay" bool


{-| Indicates whether the browser should show playback controls for the `audio`
or `video`.
-}
controls : Bool -> Attribute msg parts
controls bool =
    boolProperty "controls" bool


{-| Indicates whether the `audio` or `video` should start playing from the
start when it's finished.
-}
loop : Bool -> Attribute msg parts
loop bool =
    boolProperty "loop" bool


{-| Control how much of an `audio` or `video` resource should be preloaded.
-}
preload : String -> Attribute msg parts
preload value =
    stringProperty "preload" value


{-| A URL indicating a poster frame to show until the user plays or seeks the
`video`.
-}
poster : String -> Attribute msg parts
poster value =
    stringProperty "poster" value


{-| Indicates that the `track` should be enabled unless the user's preferences
indicate something different.
-}
default : Bool -> Attribute msg parts
default bool =
    boolProperty "default" bool


{-| Specifies the kind of text `track`.
-}
kind : String -> Attribute msg parts
kind value =
    stringProperty "kind" value


{-| A two letter language code indicating the language of the `track` text data.
-}
srclang : String -> Attribute msg parts
srclang value =
    stringProperty "srclang" value



-- IFRAMES


{-| A space separated list of security restrictions you'd like to lift for an
`iframe`.
-}
sandbox : String -> Attribute msg parts
sandbox value =
    stringProperty "sandbox" value


{-| Make an `iframe` look like part of the containing document.
-}
seamless : Bool -> Attribute msg parts
seamless bool =
    boolProperty "seamless" bool


{-| An HTML document that will be displayed as the body of an `iframe`. It will
override the content of the `src` attribute if it has been specified.
-}
srcdoc : String -> Attribute msg parts
srcdoc value =
    stringProperty "srcdoc" value



-- INPUT


{-| Defines the type of a `button`, `input`, `embed`, `object`, `script`,
`source`, `style`, or `menu`.
-}
type_ : String -> Attribute msg parts
type_ value =
    stringProperty "type" value


{-| Defines a default value which will be displayed in a `button`, `option`,
`input`, `li`, `meter`, `progress`, or `param`.
-}
value : String -> Attribute msg parts
value value =
    stringProperty "value" value


{-| Defines an initial value which will be displayed in an `input` when that
`input` is added to the DOM. Unlike `value`, altering `defaultValue` after the
`input` element has been added to the DOM has no effect.
-}
defaultValue : String -> Attribute msg parts
defaultValue value =
    stringProperty "defaultValue" value


{-| Indicates whether an `input` of type checkbox is checked.
-}
checked : Bool -> Attribute msg parts
checked bool =
    boolProperty "checked" bool


{-| Provides a hint to the user of what can be entered into an `input` or
`textarea`.
-}
placeholder : String -> Attribute msg parts
placeholder value =
    stringProperty "placeholder" value


{-| Defines which `option` will be selected on page load.
-}
selected : Bool -> Attribute msg parts
selected bool =
    boolProperty "selected" bool



-- INPUT HELPERS


{-| List of types the server accepts, typically a file type.
For `form` and `input`.
-}
accept : String -> Attribute msg parts
accept value =
    stringProperty "accept" value


{-| List of supported charsets in a `form`.
-}
acceptCharset : String -> Attribute msg parts
acceptCharset value =
    stringProperty "acceptCharset" value


{-| The URI of a program that processes the information submitted via a `form`.
-}
action : String -> Attribute msg parts
action value =
    stringProperty "action" value


{-| Indicates whether a `form` or an `input` can have their values automatically
completed by the browser.
-}
autocomplete : Bool -> Attribute msg parts
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
autofocus : Bool -> Attribute msg parts
autofocus bool =
    boolProperty "autofocus" bool


{-| Indicates whether the user can interact with a `button`, `fieldset`,
`input`, `keygen`, `optgroup`, `option`, `select` or `textarea`.
-}
disabled : Bool -> Attribute msg parts
disabled bool =
    boolProperty "disabled" bool


{-| How `form` data should be encoded when submitted with the POST method.
Options include: application/x-www-form-urlencoded, multipart/form-data, and
text/plain.
-}
enctype : String -> Attribute msg parts
enctype value =
    stringProperty "enctype" value


{-| Indicates the action of an `input` or `button`. This overrides the action
defined in the surrounding `form`.
-}
formaction : String -> Attribute msg parts
formaction value =
    attribute "formAction" value


{-| Associates an `input` with a `datalist` tag. The datalist gives some
pre-defined options to suggest to the user as they interact with an input.
The value of the list attribute must match the id of a `datalist` node.
For `input`.
-}
list : String -> Attribute msg parts
list value =
    attribute "list" value


{-| Defines the minimum number of characters allowed in an `input` or
`textarea`.
-}
minlength : Int -> Attribute msg parts
minlength n =
    attribute "minLength" (toString n)


{-| Defines the maximum number of characters allowed in an `input` or
`textarea`.
-}
maxlength : Int -> Attribute msg parts
maxlength n =
    attribute "maxlength" (toString n)


{-| Defines which HTTP method to use when submitting a `form`. Can be GET
(default) or POST.
-}
method : String -> Attribute msg parts
method value =
    stringProperty "method" value


{-| Indicates whether multiple values can be entered in an `input` of type
email or file. Can also indicate that you can `select` many options.
-}
multiple : Bool -> Attribute msg parts
multiple bool =
    boolProperty "multiple" bool


{-| Name of the element. For example used by the server to identify the fields
in form submits. For `button`, `form`, `fieldset`, `iframe`, `input`, `keygen`,
`object`, `output`, `select`, `textarea`, `map`, `meta`, and `param`.
-}
name : String -> Attribute msg parts
name value =
    stringProperty "name" value


{-| This attribute indicates that a `form` shouldn't be validated when
submitted.
-}
novalidate : Bool -> Attribute msg parts
novalidate bool =
    boolProperty "noValidate" bool


{-| Defines a regular expression which an `input`'s value will be validated
against.
-}
pattern : String -> Attribute msg parts
pattern value =
    stringProperty "pattern" value


{-| Indicates whether an `input` or `textarea` can be edited.
-}
readonly : Bool -> Attribute msg parts
readonly bool =
    boolProperty "readOnly" bool


{-| Indicates whether this element is required to fill out or not.
For `input`, `select`, and `textarea`.
-}
required : Bool -> Attribute msg parts
required bool =
    boolProperty "required" bool


{-| For `input` specifies the width of an input in characters.
For `select` specifies the number of visible options in a drop-down list.
-}
size : Int -> Attribute msg parts
size n =
    attribute "size" (toString n)


{-| The element ID described by this `label` or the element IDs that are used
for an `output`.
-}
for : String -> Attribute msg parts
for value =
    stringProperty "htmlFor" value


{-| Indicates the element ID of the `form` that owns this particular `button`,
`fieldset`, `input`, `keygen`, `label`, `meter`, `object`, `output`,
`progress`, `select`, or `textarea`.
-}
form : String -> Attribute msg parts
form value =
    attribute "form" value



-- RANGES


{-| Indicates the maximum value allowed. When using an input of type number or
date, the max value must be a number or date. For `input`, `meter`, and `progress`.
-}
max : String -> Attribute msg parts
max value =
    stringProperty "max" value


{-| Indicates the minimum value allowed. When using an input of type number or
date, the min value must be a number or date. For `input` and `meter`.
-}
min : String -> Attribute msg parts
min value =
    stringProperty "min" value


{-| Add a step size to an `input`. Use `step "any"` to allow any floating-point
number to be used in the input.
-}
step : String -> Attribute msg parts
step n =
    stringProperty "step" n



--------------------------


{-| Defines the number of columns in a `textarea`.
-}
cols : Int -> Attribute msg parts
cols n =
    attribute "cols" (toString n)


{-| Defines the number of rows in a `textarea`.
-}
rows : Int -> Attribute msg parts
rows n =
    attribute "rows" (toString n)


{-| Indicates whether the text should be wrapped in a `textarea`. Possible
values are "hard" and "soft".
-}
wrap : String -> Attribute msg parts
wrap value =
    stringProperty "wrap" value



-- MAPS


{-| When an `img` is a descendent of an `a` tag, the `ismap` attribute
indicates that the click location should be added to the parent `a`'s href as
a query string.
-}
ismap : Bool -> Attribute msg parts
ismap value =
    boolProperty "isMap" value


{-| Specify the hash name reference of a `map` that should be used for an `img`
or `object`. A hash name reference is a hash symbol followed by the element's name or id.
E.g. `"#planet-map"`.
-}
usemap : String -> Attribute msg parts
usemap value =
    stringProperty "useMap" value


{-| Declare the shape of the clickable area in an `a` or `area`. Valid values
include: default, rect, circle, poly. This attribute can be paired with
`coords` to create more particular shapes.
-}
shape : String -> Attribute msg parts
shape value =
    stringProperty "shape" value


{-| A set of values specifying the coordinates of the hot-spot region in an
`area`. Needs to be paired with a `shape` attribute to be meaningful.
-}
coords : String -> Attribute msg parts
coords value =
    stringProperty "coords" value



-- KEY GEN


{-| A challenge string that is submitted along with the public key in a `keygen`.
-}
challenge : String -> Attribute msg parts
challenge value =
    attribute "challenge" value


{-| Specifies the type of key generated by a `keygen`. Possible values are:
rsa, dsa, and ec.
-}
keytype : String -> Attribute msg parts
keytype value =
    stringProperty "keytype" value



-- REAL STUFF


{-| Specifies the horizontal alignment of a `caption`, `col`, `colgroup`,
`hr`, `iframe`, `img`, `table`, `tbody`, `td`, `tfoot`, `th`, `thead`, or
`tr`.
-}
align : String -> Attribute msg parts
align value =
    stringProperty "align" value


{-| Contains a URI which points to the source of the quote or change in a
`blockquote`, `del`, `ins`, or `q`.
-}
cite : String -> Attribute msg parts
cite value =
    stringProperty "cite" value



-- LINKS AND AREAS


{-| The URL of a linked resource, such as `a`, `area`, `base`, or `link`.
-}
href : String -> Attribute msg parts
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
target : String -> Attribute msg parts
target value =
    stringProperty "target" value


{-| Indicates that clicking an `a` and `area` will download the resource
directly.
-}
download : Bool -> Attribute msg parts
download bool =
    boolProperty "download" bool


{-| Indicates that clicking an `a` and `area` will download the resource
directly, and that the downloaded resource with have the given filename.
-}
downloadAs : String -> Attribute msg parts
downloadAs value =
    stringProperty "download" value


{-| Two-letter language code of the linked resource of an `a`, `area`, or `link`.
-}
hreflang : String -> Attribute msg parts
hreflang value =
    stringProperty "hreflang" value


{-| Specifies a hint of the target media of a `a`, `area`, `link`, `source`,
or `style`.
-}
media : String -> Attribute msg parts
media value =
    attribute "media" value


{-| Specify a URL to send a short POST request to when the user clicks on an
`a` or `area`. Useful for monitoring and tracking.
-}
ping : String -> Attribute msg parts
ping value =
    stringProperty "ping" value


{-| Specifies the relationship of the target object to the link object.
For `a`, `area`, `link`.
-}
rel : String -> Attribute msg parts
rel value =
    attribute "rel" value



-- CRAZY STUFF


{-| Indicates the date and time associated with the element.
For `del`, `ins`, `time`.
-}
datetime : String -> Attribute msg parts
datetime value =
    attribute "datetime" value


{-| Indicates whether this date and time is the date of the nearest `article`
ancestor element. For `time`.
-}
pubdate : String -> Attribute msg parts
pubdate value =
    attribute "pubdate" value



-- ORDERED LISTS


{-| Indicates whether an ordered list `ol` should be displayed in a descending
order instead of a ascending.
-}
reversed : Bool -> Attribute msg parts
reversed bool =
    boolProperty "reversed" bool


{-| Defines the first number of an ordered list if you want it to be something
besides 1.
-}
start : Int -> Attribute msg parts
start n =
    stringProperty "start" (toString n)



-- TABLES


{-| The colspan attribute defines the number of columns a cell should span.
For `td` and `th`.
-}
colspan : Int -> Attribute msg parts
colspan n =
    attribute "colspan" (toString n)


{-| A space separated list of element IDs indicating which `th` elements are
headers for this cell. For `td` and `th`.
-}
headers : String -> Attribute msg parts
headers value =
    stringProperty "headers" value


{-| Defines the number of rows a table cell should span over.
For `td` and `th`.
-}
rowspan : Int -> Attribute msg parts
rowspan n =
    attribute "rowspan" (toString n)


{-| Specifies the scope of a header cell `th`. Possible values are: col, row,
colgroup, rowgroup.
-}
scope : String -> Attribute msg parts
scope value =
    stringProperty "scope" value


{-| Specifies the URL of the cache manifest for an `html` tag.
-}
manifest : String -> Attribute msg parts
manifest value =
    attribute "manifest" value
