@routing @car @restrictions
Feature: Car - Turn restrictions
# Handle turn restrictions as defined by http://wiki.openstreetmap.org/wiki/Relation:restriction
# Note that if u-turns are allowed, turn restrictions can lead to suprising, but correct, routes.

    Background: Use car routing
        Given the profile "car"
        Given a grid size of 200 meters

    @no_turning
    Scenario: Car - No left turn
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction  |
            | restriction | sj       | wj     | j        | no_left_turn |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  | sj,nj,nj |
            | s    | e  | sj,ej,ej |

    @no_turning
    Scenario: Car - No straight on
        Given the node map
            """
            a b j d e
            v       z
              w x y
            """

        And the ways
            | nodes | oneway |
            | ab    | no     |
            | bj    | no     |
            | jd    | no     |
            | de    | no     |
            | av    | yes    |
            | vw    | yes    |
            | wx    | yes    |
            | xy    | yes    |
            | yz    | yes    |
            | ze    | yes    |

        And the relations
            | type        | way:from | way:to | node:via | restriction    |
            | restriction | bj       | jd     | j        | no_straight_on |

        When I route I should get
            | from | to | route                |
            | a    | e  | av,vw,wx,xy,yz,ze,ze |

    @no_turning
    Scenario: Car - No right turn
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction   |
            | restriction | sj       | ej     | j        | no_right_turn |

        When I route I should get
            | from | to | route    |
            | s    | w  | sj,wj,wj |
            | s    | n  | sj,nj,nj |
            | s    | e  |          |

    @no_turning
    Scenario: Car - No u-turn
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction |
            | restriction | sj       | wj     | j        | no_u_turn   |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  | sj,nj,nj |
            | s    | e  | sj,ej,ej |

    @no_turning
    Scenario: Car - Handle any no_* relation
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      |
            | restriction | sj       | wj     | j        | no_weird_zigzags |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  | sj,nj,nj |
            | s    | e  | sj,ej,ej |

    @only_turning
    Scenario: Car - Only left turn
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction    |
            | restriction | sj       | wj     | j        | only_left_turn |

    Scenario: Car - Only right turn, invalid
        Given the node map
            """
              n
            w j e r
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |
            | re    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction   |
            | restriction | sj       | er     | j        | only_right_on |

        When I route I should get
            | from | to | route       |
            | s    | r  | sj,ej,re,re |

    @only_turning
    Scenario: Car - Only right turn
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction     |
            | restriction | sj       | ej     | j        | only_right_turn |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  |          |
            | s    | e  | sj,ej,ej |

    @only_turning
    Scenario: Car - Only straight on
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      |
            | restriction | sj       | nj     | j        | only_straight_on |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  | sj,nj,nj |
            | s    | e  |          |

    @no_turning
    Scenario: Car - Handle any only_* restriction
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction        |
            | restriction | sj       | nj     | j        | only_weird_zigzags |

        When I route I should get
            | from | to | route    |
            | s    | w  |          |
            | s    | n  | sj,nj,nj |
            | s    | e  |          |

    @specific
    Scenario: Car - :hgv-qualified on a standard turn restriction
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction:hgv |
            | restriction | sj       | nj     | j        | no_straight_on  |

        When I route I should get
            | from | to | route    |
            | s    | w  | sj,wj,wj |
            | s    | n  | sj,nj,nj |
            | s    | e  | sj,ej,ej |

    @specific
    Scenario: Car - :motorcar-qualified on a standard turn restriction
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction:motorcar |
            | restriction | sj       | nj     | j        | no_straight_on       |

        When I route I should get
            | from | to | route    |
            | s    | w  | sj,wj,wj |
            | s    | n  |          |
            | s    | e  | sj,ej,ej |

    @except
    Scenario: Car - Except tag and on no_ restrictions
        Given the node map
            """
            b x c
            a j d
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | no     |
            | xj    | -1     |
            | aj    | -1     |
            | bj    | no     |
            | cj    | no     |
            | dj    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction   | except   |
            | restriction | sj       | aj     | j        | no_left_turn  | motorcar |
            | restriction | sj       | bj     | j        | no_left_turn  |          |
            | restriction | sj       | cj     | j        | no_right_turn |          |
            | restriction | sj       | dj     | j        | no_right_turn | motorcar |

        When I route I should get
            | from | to | route    |
            | s    | a  | sj,aj,aj |
            | s    | b  |          |
            | s    | c  |          |
            | s    | d  | sj,dj,dj |

    @except
    Scenario: Car - Except tag and on only_ restrictions
        Given the node map
            """
            a   b
              j
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | aj    | no     |
            | bj    | no     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      | except   |
            | restriction | sj       | aj     | j        | only_straight_on | motorcar |

        When I route I should get
            | from | to | route    |
            | s    | a  | sj,aj,aj |
            | s    | b  | sj,bj,bj |

    @except
    Scenario: Car - Several only_ restrictions at the same segment
        Given the node map
            """
                    y
            i j f b x a e g h

                  c   d
            """

        And the ways
            | nodes | oneway |
            | fb    | no     |
            | bx    | -1     |
            | xa    | no     |
            | ae    | no     |
            | cb    | no     |
            | dc    | -1     |
            | da    | no     |
            | fj    | no     |
            | jf    | no     |
            | ge    | no     |
            | hg    | no     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      |
            | restriction | ae       | xa     | a        | only_straight_on |
            | restriction | xb       | fb     | b        | only_straight_on |
            | restriction | cb       | bx     | b        | only_right_turn  |
            | restriction | da       | ae     | a        | only_right_turn  |

        When I route I should get
            | from | to | route                               |
            | e    | f  | ae,xa,bx,fb,fb                      |
            | c    | f  | dc,da,ae,ge,hg,hg,ge,ae,xa,bx,fb,fb |
            | d    | f  | da,ae,ge,hg,hg,ge,ae,xa,bx,fb,fb    |

    @except
    Scenario: Car - two only_ restrictions share same to-way
        Given the node map
            """
                e       f
                    a

                c   x   d
                    y

                    b
            """

        And the ways
            | nodes | oneway |
            | ef    | no     |
            | ce    | no     |
            | fd    | no     |
            | ca    | no     |
            | ad    | no     |
            | ax    | no     |
            | xy    | no     |
            | yb    | no     |
            | cb    | no     |
            | db    | no     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      |
            | restriction | ax       | xy     | x        | only_straight_on |
            | restriction | by       | xy     | y        | only_straight_on |

        When I route I should get
            | from | to | route       |
            | a    | b  | ax,xy,yb,yb |
            | b    | a  | yb,xy,ax,ax |

    @except
    Scenario: Car - two only_ restrictions share same from-way
        Given the node map
            """
                e       f
                    a

                c   x   d
                    y

                    b
            """

        And the ways
            | nodes | oneway |
            | ef    | no     |
            | ce    | no     |
            | fd    | no     |
            | ca    | no     |
            | ad    | no     |
            | ax    | no     |
            | xy    | no     |
            | yb    | no     |
            | cb    | no     |
            | db    | no     |

        And the relations
            | type        | way:from | way:to | node:via | restriction      |
            | restriction | xy       | xa     | x        | only_straight_on |
            | restriction | xy       | yb     | y        | only_straight_on |

        When I route I should get
            | from | to | route       |
            | a    | b  | ax,xy,yb,yb |
            | b    | a  | yb,xy,ax,ax |

    @specific
    Scenario: Car - Ignore unrecognized restriction
        Given the node map
            """
              n
            w j e
              s
            """

        And the ways
            | nodes | oneway |
            | sj    | yes    |
            | nj    | -1     |
            | wj    | -1     |
            | ej    | -1     |

        And the relations
            | type        | way:from | way:to | node:via | restriction  |
            | restriction | sj       | wj     | j        | yield        |

        When I route I should get
            | from | to | route    |
            | s    | w  | sj,wj,wj |
            | s    | n  | sj,nj,nj |
            | s    | e  | sj,ej,ej |

    @restriction @compression
    Scenario: Restriction On Compressed Geometry
        Given the node map
            """
                        i
                        |
                    f - e
                    |   |
            a - b - c - d
                    |
                    g
                    |
                    h
            """

        And the ways
            | nodes |
            | abc   |
            | cde   |
            | efc   |
            | cgh   |
            | ei    |

        And the relations
            | type        | way:from | node:via | way:to | restriction   |
            | restriction | abc      | c        | cgh    | no_right_turn |

        When I route I should get
            | from | to | route               |
            | a    | h  | abc,cde,efc,cgh,cgh |

    @restriction
    Scenario: Car - prohibit turn
        Given the node map
            """
            c
            |
            |   f
            |   |
            b---e
            |   |
            a   d
            """

        And the ways
            | nodes |
            | ab    |
            | bc    |
            | be    |
            | de    |
            | ef    |

        And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | ab       | be      | de     | no_right_turn |

        When I route I should get
            | from | to | route       |
            | a    | d  | ab,be,de,de |
            | a    | f  | ab,be,ef,ef |

    @restriction @overlap
    Scenario: Car - prohibit turn
        Given the node map
            """
            c
            |
            |   f
            |   |
            b---e
            |   |
            |   d
            |
            a

            """

        And the ways
            | nodes |
            | ab    |
            | bc    |
            | be    |
            | de    |
            | ef    |

        And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | ab       | be      | de     | no_right_turn |
            | restriction | bc       | be      | ef     | no_left_turn  |

        When I route I should get
            | from | to | route       |
            | a    | d  | ab,be,de,de |
            | a    | f  | ab,be,ef,ef |
            | c    | d  | bc,be,de,de |
            | c    | f  | bc,be,ef,ef |

    @restriction-way @overlap
    Scenario: Two times same way
        Given the node map
            """
                h   g
                |   |
                |   |
                |   |
                |   |
                |   |
                |   |
                |   |
                |   |
                |   |
                |   |
            a - b - c - f
                |   | \ |
                i - d - e
            """

        And the ways
            | nodes | oneway |
            | ab    | no     |
            | bc    | no     |
            | cd    | yes    |
            | ce    | yes    |
            | cf    | yes    |
            | cg    | yes    |
            | bh    | no     |
            | fedib | yes    |

       And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | ab       | bc      | ce     | no_right_turn |
            | restriction | ab       | bc      | cd     | no_right_turn |

       When I route I should get
            | from | to | route                |
            | a    | i  | ab,bc,cd,fedib,fedib |


    @restriction-way @overlap
    Scenario: Car - prohibit turn
        Given the node map
            """
            a   j
            |   |
            b---i
            |   |
            c---h
            |   |
            d---g
            |   |
            e   f
            """

        And the ways
            | nodes | name   | oneway |
            | ab    | left   | yes    |
            | bc    | left   | yes    |
            | cd    | left   | yes    |
            | de    | left   | yes    |
            | fg    | right  | yes    |
            | gh    | right  | yes    |
            | hi    | right  | yes    |
            | ij    | right  | yes    |
            | dg    | first  | no     |
            | ch    | second | no     |
            | bi    | third  | no     |

        And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | ab       | bi      | ij     | no_u_turn     |
            | restriction | bc       | ch      | hi     | no_u_turn     |
            | restriction | fg       | dg      | de     | no_u_turn     |
            | restriction | gh       | ch      | cd     | no_u_turn     |

        When I route I should get
            | from | to | route                  |
            | a    | j  | left,third,right,right |
            | f    | e  | right,first,left,left  |

    @restriction
    Scenario: Car - allow only turn
        Given the node map
            """
            c
            |
            |   f
            |   |
            b---e
            |   |
            a   d
            """

        And the ways
            | nodes |
            | ab    |
            | bc    |
            | be    |
            | de    |
            | ef    |

        And the relations
            | type        | way:from | way:via | way:to | restriction  |
            | restriction | ab       | be      | ef     | only_left_on |

        When I route I should get
            | from | to | route       |
            | a    | d  | ab,be,de,de |


    @restriction
    Scenario: Car - allow only turn
        Given the node map
            """
            c
            |
            |   f
            |   |
            b---e
            |   |
            a   d
            """

        And the ways
            | nodes |
            | ab    |
            | bc    |
            | be    |
            | de    |
            | ef    |

        And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | ab       | be      | ed     | only_right_on |

        When I route I should get
            | from | to | route       |
            | a    | d  | ab,be,de,de |

    @restriction
    Scenario: Multi Way restriction
        Given the node map
            """
                  k   j
                  |   |
            h - - g - f - - e
                  |   |
                  |   |
            a - - b - c - - d
                  |   |
                  l   i
            """

        And the ways
            | nodes | name  | oneway |
            | ab    | horiz | yes    |
            | bc    | horiz | yes    |
            | cd    | horiz | yes    |
            | ef    | horiz | yes    |
            | fg    | horiz | yes    |
            | gh    | horiz | yes    |
            | ic    | vert  | yes    |
            | cf    | vert  | yes    |
            | fj    | vert  | yes    |
            | kg    | vert  | yes    |
            | gb    | vert  | yes    |
            | bl    | vert  | yes    |

        And the relations
            | type        | way:from | way:via  | way:to | restriction |
            | restriction | ab       | bc,cf,fg | gh     | no_u_turn   |

        When I route I should get
            | from | to | route                  |
            | a    | h  | horiz,vert,horiz,horiz |

    @restriction
    Scenario: Multi-Way overlapping single-way
        Given the node map
            """
                    e
                    |
            a - b - c - d
                |
                f - g
                |
                h
            """

        And the ways
            | nodes | name |
            | ab    | abcd |
            | bc    | abcd |
            | cd    | abcd |
            | hf    | hfb  |
            | fb    | hfb  |
            | gf    | gf   |
            | ce    | ce   |

        And the relations
            | type        | way:from | way:via | way:to | restriction    |
            | restriction | ab       | bc      | ce     | only_left_turn |
            | restriction | gf       | fb,bc   | cd     | only_u_turn    |

        When I route I should get
            | from | to | route             |
            | a    | d  | abcd,abcd         |
            | a    | e  | abcd,ce,ce        |
            | a    | f  | abcd,hfb,hfb      |
            | g    | e  | gf,hfb,abcd,ce,ce |
            | g    | d  | gf,hfb,abcd,abcd  |
            | h    | e  | hfb,abcd,ce,ce    |
            | h    | d  | hfb,abcd,abcd     |

    @restriction
    Scenario: Car - prohibit turn, traffic lights
        Given the node map
            """
            c
            |
            |   f
            |   |
            b---e
            |   |
            a   d
            |   |
            g   i
            |   |
            h   j
            """

        And the ways
            | nodes | name |
            | hgab  | ab   |
            | bc    | bc   |
            | be    | be   |
            | jide  | de   |
            | ef    | ef   |

        And the relations
            | type        | way:from | way:via | way:to | restriction   |
            | restriction | hgab     | be      | jide   | no_right_turn |

        And the nodes
            | node | highway         |
            | g    | traffic_signals |
            | i    | traffic_signals |


        When I route I should get
            | from | to | route       |
            | h    | j  | ab,be,de,de |
            | h    | f  | ab,be,ef,ef |

