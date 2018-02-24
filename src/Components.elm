module Components
    exposing
        ( Attribute
        , Component
        , ComponentInternalStuff
        , Container
        , Msg
        , Node
        , Self
        , Signal
        , Slot
        , State
        , dictSlot
        , init
        , send
        , sendToPart
        , slot
        , subscriptions
        , update
        , view
        , wrapMsg
        , x1
        , x10
        , x11
        , x12
        , x13
        , x14
        , x15
        , x16
        , x17
        , x18
        , x19
        , x2
        , x20
        , x21
        , x22
        , x23
        , x24
        , x25
        , x26
        , x27
        , x28
        , x29
        , x3
        , x30
        , x31
        , x32
        , x33
        , x34
        , x35
        , x36
        , x37
        , x38
        , x39
        , x4
        , x40
        , x41
        , x42
        , x43
        , x44
        , x45
        , x46
        , x47
        , x48
        , x49
        , x5
        , x50
        , x6
        , x7
        , x8
        , x9
        )

import Components.Internal.Core as Core
import Components.Internal.Run as Run
import Components.Internal.Shared exposing (toOwnerSignal)
import Dict exposing (Dict)
import VirtualDom


type alias Node v w m p =
    Core.Node v w m p


type alias Component v w container m p =
    Core.Component v w container m p


type alias Container s m p =
    Core.Container s m p


type alias Signal m p =
    Core.Signal m p


type alias Slot container p =
    Core.Slot container p


type alias Attribute v m p =
    Core.Attribute v m p


type alias Self a s m p oP =
    { a
        | internal : ComponentInternalStuff s m p oP
    }


type alias ComponentInternalStuff s m p oP =
    Core.ComponentInternalStuff s m p oP


type alias State container outMsg =
    Run.State container outMsg


type alias Msg container outMsg =
    Run.Msg container outMsg


send : m -> Signal m p
send =
    Core.LocalMsg


sendToPart :
    Self a s m p oP
    -> Slot (Container pS pM pP) p
    -> pM
    -> Signal oM oP
sendToPart self partSlot partMsg =
    let
        (Core.ComponentInternalStuff internal) =
            self.internal
    in
    partMsg
        |> Core.LocalMsg
        |> toOwnerSignal partSlot internal.freshContainers
        |> toOwnerSignal internal.slot internal.freshOwnerContainers


slot :
    Slot (Container s m p) oP
    -> Component v w (Container s m p) oM oP
    -> Node v w oM oP
slot slot_ (Core.Component component) =
    component slot_


dictSlot :
    Slot (Dict comparable (Container s m p)) oP
    -> comparable
    -> Slot (Container s m p) oP
dictSlot ( getDict, setDict ) key =
    let
        get =
            getDict
                >> Dict.get key
                >> Maybe.withDefault Core.EmptyContainer

        set container parts =
            setDict
                (Dict.insert key container (getDict parts))
                parts
    in
    ( get, set )


init :
    Component v w (Container s m p) outMsg (Container s m p)
    -> ( State (Container s m p) outMsg, Cmd (Msg (Container s m p) outMsg) )
init =
    Run.init


update :
    Msg (Container s m p) outMsg
    -> State (Container s m p) outMsg
    -> ( State (Container s m p) outMsg, Cmd (Msg (Container s m p) outMsg), List outMsg )
update =
    Run.update


subscriptions :
    State (Container s m p) outMsg
    -> Sub (Msg (Container s m p) outMsg)
subscriptions =
    Run.subscriptions


view :
    State (Container s m p) outMsg
    -> VirtualDom.Node (Msg (Container s m p) outMsg)
view =
    Run.view


wrapMsg : m -> Msg (Container s m p) outMsg
wrapMsg =
    Run.wrapMsg


x1 : (Container s m p -> parts) -> parts
x1 fn =
    fn Core.EmptyContainer


x2 : (Container s1 m1 p1 -> Container s2 m2 p2 -> parts) -> parts
x2 =
    x1 >> x1


x3 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> parts
    )
    -> parts
x3 =
    x2 >> x1


x4 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> parts
    )
    -> parts
x4 =
    x3 >> x1


x5 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> parts
    )
    -> parts
x5 =
    x4 >> x1


x6 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> parts
    )
    -> parts
x6 =
    x5 >> x1


x7 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> parts
    )
    -> parts
x7 =
    x6 >> x1


x8 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> parts
    )
    -> parts
x8 =
    x7 >> x1


x9 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> parts
    )
    -> parts
x9 =
    x8 >> x1


x10 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> parts
    )
    -> parts
x10 =
    x9 >> x1


x11 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> parts
    )
    -> parts
x11 =
    x10 >> x1


x12 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> parts
    )
    -> parts
x12 =
    x11 >> x1


x13 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> parts
    )
    -> parts
x13 =
    x12 >> x1


x14 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> parts
    )
    -> parts
x14 =
    x13 >> x1


x15 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> parts
    )
    -> parts
x15 =
    x14 >> x1


x16 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> parts
    )
    -> parts
x16 =
    x15 >> x1


x17 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> parts
    )
    -> parts
x17 =
    x16 >> x1


x18 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> parts
    )
    -> parts
x18 =
    x17 >> x1


x19 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> parts
    )
    -> parts
x19 =
    x18 >> x1


x20 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> parts
    )
    -> parts
x20 =
    x19 >> x1


x21 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> parts
    )
    -> parts
x21 =
    x20 >> x1


x22 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> parts
    )
    -> parts
x22 =
    x21 >> x1


x23 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> parts
    )
    -> parts
x23 =
    x22 >> x1


x24 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> parts
    )
    -> parts
x24 =
    x23 >> x1


x25 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> parts
    )
    -> parts
x25 =
    x24 >> x1


x26 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> parts
    )
    -> parts
x26 =
    x25 >> x1


x27 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> parts
    )
    -> parts
x27 =
    x26 >> x1


x28 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> parts
    )
    -> parts
x28 =
    x27 >> x1


x29 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> parts
    )
    -> parts
x29 =
    x28 >> x1


x30 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> parts
    )
    -> parts
x30 =
    x29 >> x1


x31 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> parts
    )
    -> parts
x31 =
    x30 >> x1


x32 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> parts
    )
    -> parts
x32 =
    x31 >> x1


x33 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> parts
    )
    -> parts
x33 =
    x32 >> x1


x34 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> parts
    )
    -> parts
x34 =
    x33 >> x1


x35 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> parts
    )
    -> parts
x35 =
    x34 >> x1


x36 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> parts
    )
    -> parts
x36 =
    x35 >> x1


x37 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> parts
    )
    -> parts
x37 =
    x36 >> x1


x38 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> parts
    )
    -> parts
x38 =
    x37 >> x1


x39 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> parts
    )
    -> parts
x39 =
    x38 >> x1


x40 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> parts
    )
    -> parts
x40 =
    x39 >> x1


x41 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> parts
    )
    -> parts
x41 =
    x40 >> x1


x42 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> parts
    )
    -> parts
x42 =
    x41 >> x1


x43 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> parts
    )
    -> parts
x43 =
    x42 >> x1


x44 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> parts
    )
    -> parts
x44 =
    x43 >> x1


x45 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> parts
    )
    -> parts
x45 =
    x44 >> x1


x46 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> parts
    )
    -> parts
x46 =
    x45 >> x1


x47 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> parts
    )
    -> parts
x47 =
    x46 >> x1


x48 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> parts
    )
    -> parts
x48 =
    x47 >> x1


x49 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> Container s49 m49 p49
     -> parts
    )
    -> parts
x49 =
    x48 >> x1


x50 :
    (Container s1 m1 p1
     -> Container s2 m2 p2
     -> Container s3 m3 p3
     -> Container s4 m4 p4
     -> Container s5 m5 p5
     -> Container s6 m6 p6
     -> Container s7 m7 p7
     -> Container s8 m8 p8
     -> Container s9 m9 p9
     -> Container s10 m10 p10
     -> Container s11 m11 p11
     -> Container s12 m12 p12
     -> Container s13 m13 p13
     -> Container s14 m14 p14
     -> Container s15 m15 p15
     -> Container s16 m16 p16
     -> Container s17 m17 p17
     -> Container s18 m18 p18
     -> Container s19 m19 p19
     -> Container s20 m20 p20
     -> Container s21 m21 p21
     -> Container s22 m22 p22
     -> Container s23 m23 p23
     -> Container s24 m24 p24
     -> Container s25 m25 p25
     -> Container s26 m26 p26
     -> Container s27 m27 p27
     -> Container s28 m28 p28
     -> Container s29 m29 p29
     -> Container s30 m30 p30
     -> Container s31 m31 p31
     -> Container s32 m32 p32
     -> Container s33 m33 p33
     -> Container s34 m34 p34
     -> Container s35 m35 p35
     -> Container s36 m36 p36
     -> Container s37 m37 p37
     -> Container s38 m38 p38
     -> Container s39 m39 p39
     -> Container s40 m40 p40
     -> Container s41 m41 p41
     -> Container s42 m42 p42
     -> Container s43 m43 p43
     -> Container s44 m44 p44
     -> Container s45 m45 p45
     -> Container s46 m46 p46
     -> Container s47 m47 p47
     -> Container s48 m48 p48
     -> Container s49 m49 p49
     -> Container s50 m50 p50
     -> parts
    )
    -> parts
x50 =
    x49 >> x1
