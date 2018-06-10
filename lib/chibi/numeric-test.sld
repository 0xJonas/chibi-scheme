(define-library (chibi numeric-test)
  (export run-tests)
  (import (scheme base) (scheme inexact) (chibi test))
  (begin
    (define (integer-neighborhoods x)
      (list x (+ 1 x) (+ -1 x) (- x) (- 1 x) (- -1 x)))
    (define (factorial n) (if (= n 0) 1 (* n (factorial (- n 1)))))
    (define (atanh z) (/ (- (log (+ 1 z)) (log (- 1 z))) 2))
    (define (integer-arithmetic-combinations a b)
      (list (+ a b) (- a b) (* a b) (quotient a b) (remainder a b)))
    (define (sign-combinations a b)
      (list (integer-arithmetic-combinations a b)
            (integer-arithmetic-combinations (- a) b)
            (integer-arithmetic-combinations a (- b))
            (integer-arithmetic-combinations (- a) (- b))))
    (define (run-tests)
      (test-begin "numbers")

      (test 3 (expt 3 1))
      ;(test 1/3 (expt 3 -1))
      (test 1/300000000000000000000 (expt 300000000000000000000 -1))

      (test '(536870912 536870913 536870911 -536870912 -536870911 -536870913)
          (integer-neighborhoods (expt 2 29)))

      (test '(1073741824 1073741825 1073741823
                         -1073741824 -1073741823 -1073741825)
          (integer-neighborhoods (expt 2 30)))

      (test '(2147483648 2147483649 2147483647
                         -2147483648 -2147483647 -2147483649)
          (integer-neighborhoods (expt 2 31)))

      (test '(4294967296 4294967297 4294967295
                         -4294967296 -4294967295 -4294967297)
          (integer-neighborhoods (expt 2 32)))

      (test '(4611686018427387904 4611686018427387905 4611686018427387903
                                  -4611686018427387904 -4611686018427387903 -4611686018427387905)
          (integer-neighborhoods (expt 2 62)))

      (test '(9223372036854775808 9223372036854775809 9223372036854775807
                                  -9223372036854775808 -9223372036854775807 -9223372036854775809)
          (integer-neighborhoods (expt 2 63)))

      (test '(18446744073709551616 18446744073709551617 18446744073709551615
                                   -18446744073709551616 -18446744073709551615 -18446744073709551617)
          (integer-neighborhoods (expt 2 64)))

      (test '(85070591730234615865843651857942052864
              85070591730234615865843651857942052865
              85070591730234615865843651857942052863
              -85070591730234615865843651857942052864
              -85070591730234615865843651857942052863
              -85070591730234615865843651857942052865)
          (integer-neighborhoods (expt 2 126)))

      (test '(170141183460469231731687303715884105728
              170141183460469231731687303715884105729
              170141183460469231731687303715884105727
              -170141183460469231731687303715884105728
              -170141183460469231731687303715884105727
              -170141183460469231731687303715884105729)
          (integer-neighborhoods (expt 2 127)))

      (test '(340282366920938463463374607431768211456
              340282366920938463463374607431768211457
              340282366920938463463374607431768211455
              -340282366920938463463374607431768211456
              -340282366920938463463374607431768211455
              -340282366920938463463374607431768211457)
          (integer-neighborhoods (expt 2 128)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;; fix x fix
      (test '((1 -1 0 0 0) (1 -1 0 0 0) (-1 1 0 0 0) (-1 1 0 0 0))
          (sign-combinations 0 1))
      (test '((2 0 1 1 0) (0 -2 -1 -1 0) (0 2 -1 -1 0) (-2 0 1 1 0))
          (sign-combinations 1 1))
      (test '((59 25 714 2 8) (-25 -59 -714 -2 -8)
              (25 59 -714 -2 8) (-59 -25 714 2 -8))
          (sign-combinations 42 17))

      ;; fix x big
      (test '((4294967338 -4294967254 180388626432 0 42)
              (4294967254 -4294967338 -180388626432 0 -42)
              (-4294967254 4294967338 -180388626432 0 42)
              (-4294967338 4294967254 180388626432 0 -42))
          (sign-combinations 42 (expt 2 32)))

      ;; big x fix
      (test '((4294967338 4294967254 180388626432 102261126 4)
              (-4294967254 -4294967338 -180388626432 -102261126 -4)
              (4294967254 4294967338 -180388626432 -102261126 4)
              (-4294967338 -4294967254 180388626432 102261126 -4))
          (sign-combinations (expt 2 32) 42))

      ;; big x bigger
      (test '((12884901889 -4294967297 36893488151714070528 0 4294967296)
              (4294967297 -12884901889 -36893488151714070528 0 -4294967296)
              (-4294967297 12884901889 -36893488151714070528 0 4294967296)
              (-12884901889 4294967297 36893488151714070528 0 -4294967296))
          (sign-combinations (expt 2 32) (+ 1 (expt 2 33))))

      (test '((18446744078004518913 -18446744069414584321
                                    79228162514264337597838917632
                                    0 4294967296)
              (18446744069414584321 -18446744078004518913
                                    -79228162514264337597838917632
                                    0 -4294967296)
              (-18446744069414584321 18446744078004518913
                                     -79228162514264337597838917632
                                     0 4294967296)
              (-18446744078004518913 18446744069414584321
                                     79228162514264337597838917632
                                     0 -4294967296))
          (sign-combinations (expt 2 32) (+ 1 (expt 2 64))))

      ;; bigger x big
      (test '((12884901889 4294967297 36893488151714070528 2 1)
              (-4294967297 -12884901889 -36893488151714070528 -2 -1)
              (4294967297 12884901889 -36893488151714070528 -2 1)
              (-12884901889 -4294967297 36893488151714070528 2 -1))
          (sign-combinations (+ 1 (expt 2 33)) (expt 2 32)))

      (test '((18446744078004518913 18446744069414584321
                                    79228162514264337597838917632
                                    4294967296 1)
              (-18446744069414584321 -18446744078004518913
                                     -79228162514264337597838917632
                                     -4294967296 -1)
              (18446744069414584321 18446744078004518913
                                    -79228162514264337597838917632
                                    -4294967296 1)
              (-18446744078004518913 -18446744069414584321
                                     79228162514264337597838917632
                                     4294967296 -1))
          (sign-combinations (+ 1 (expt 2 64)) (expt 2 32)))

      (test '((170141183460469231750134047789593657344
               170141183460469231713240559642174554110
               3138550867693340382088035895064302439764418281874191810559
               9223372036854775807
               9223372036854775808)
              (-170141183460469231713240559642174554110
               -170141183460469231750134047789593657344
               -3138550867693340382088035895064302439764418281874191810559
               -9223372036854775807
               -9223372036854775808)
              (170141183460469231713240559642174554110
               170141183460469231750134047789593657344
               -3138550867693340382088035895064302439764418281874191810559
               -9223372036854775807
               9223372036854775808)
              (-170141183460469231750134047789593657344
               -170141183460469231713240559642174554110
               3138550867693340382088035895064302439764418281874191810559
               9223372036854775807
               -9223372036854775808))
          (sign-combinations (- (expt 2 127) 1) (+ 1 (expt 2 64))))

      ;; fixnum-bignum boundaries (machine word - 1 bit for sign - 2
      ;; bits for tag)

      (test 8191 (- -8191))
      (test 8192 (- -8192))
      (test 8193 (- -8193))

      (test 536870911 (- -536870911))
      (test 536870912 (- -536870912))
      (test 536870913 (- -536870913))

      (test 2305843009213693951 (- -2305843009213693951))
      (test 2305843009213693952 (- -2305843009213693952))
      (test 2305843009213693953 (- -2305843009213693953))

      (test 42535295865117307932921825928971026431
          (- -42535295865117307932921825928971026431))
      (test 42535295865117307932921825928971026432
          (- -42535295865117307932921825928971026432))
      (test 42535295865117307932921825928971026433
          (- -42535295865117307932921825928971026433))

      (test '((536879104 -536862720 4398046511104 0 8192)
              (536862720 -536879104 -4398046511104 0 -8192)
              (-536862720 536879104 -4398046511104 0 8192)
              (-536879104 536862720 4398046511104 0 -8192))
          (sign-combinations (expt 2 13) (expt 2 29)))

      (test '((536879104 536862720 4398046511104 65536 0)
              (-536862720 -536879104 -4398046511104 -65536 0)
              (536862720 536879104 -4398046511104 -65536 0)
              (-536879104 -536862720 4398046511104 65536 0))
          (sign-combinations (expt 2 29) (expt 2 13)))

      (test '((2305843009750564864 -2305843008676823040
                                   1237940039285380274899124224 0 536870912)
              (2305843008676823040 -2305843009750564864
                                   -1237940039285380274899124224 0 -536870912)
              (-2305843008676823040 2305843009750564864
                                    -1237940039285380274899124224 0 536870912)
              (-2305843009750564864 2305843008676823040
                                    1237940039285380274899124224 0 -536870912))
          (sign-combinations (expt 2 29) (expt 2 61)))

      (test '((2305843009750564864 2305843008676823040
                                   1237940039285380274899124224 4294967296 0)
              (-2305843008676823040 -2305843009750564864
                                    -1237940039285380274899124224 -4294967296 0)
              (2305843008676823040 2305843009750564864
                                   -1237940039285380274899124224 -4294967296 0)
              (-2305843009750564864 -2305843008676823040
                                    1237940039285380274899124224 4294967296 0))
          (sign-combinations (expt 2 61) (expt 2 29)))

      (test '((42535295865117307935227668938184720384
               -42535295865117307930615982919757332480
               98079714615416886934934209737619787751599303819750539264
               0
               2305843009213693952)
              (42535295865117307930615982919757332480
               -42535295865117307935227668938184720384
               -98079714615416886934934209737619787751599303819750539264
               0
               -2305843009213693952)
              (-42535295865117307930615982919757332480
               42535295865117307935227668938184720384
               -98079714615416886934934209737619787751599303819750539264
               0
               2305843009213693952)
              (-42535295865117307935227668938184720384
               42535295865117307930615982919757332480
               98079714615416886934934209737619787751599303819750539264
               0
               -2305843009213693952))
          (sign-combinations (expt 2 61) (expt 2 125)))

      (test '((42535295865117307935227668938184720384
               42535295865117307930615982919757332480
               98079714615416886934934209737619787751599303819750539264
               18446744073709551616
               0)
              (-42535295865117307930615982919757332480
               -42535295865117307935227668938184720384
               -98079714615416886934934209737619787751599303819750539264
               -18446744073709551616
               0)
              (42535295865117307930615982919757332480
               42535295865117307935227668938184720384
               -98079714615416886934934209737619787751599303819750539264
               -18446744073709551616
               0)
              (-42535295865117307935227668938184720384
               -42535295865117307930615982919757332480
               98079714615416886934934209737619787751599303819750539264
               18446744073709551616
               0))
          (sign-combinations (expt 2 125) (expt 2 61)))

      ;; Regression tests for an overflow in bignum addition
      (test 8589869056
          (+ 4294934528 4294934528))
      (test 36893488143124135936
          (+ 18446744071562067968 18446744071562067968))
      (test 680564733841876926908302470789826871296
          (+ 340282366920938463454151235394913435648
             340282366920938463454151235394913435648))
      (test 231584178474632390847141970017375815706199686964360189615451793408394491068416
          (+ 115792089237316195423570985008687907853099843482180094807725896704197245534208
             115792089237316195423570985008687907853099843482180094807725896704197245534208))

      (test #f (< +nan.0 +nan.0))
      (test #f (<= +nan.0 +nan.0))
      (test #f (= +nan.0 +nan.0))
      (test #f (>= +nan.0 +nan.0))
      (test #f (> +nan.0 +nan.0))

      (test #f (< +inf.0 +inf.0))
      (test #t (<= +inf.0 +inf.0))
      (test #t (= +inf.0 +inf.0))
      (test #t (>= +inf.0 +inf.0))
      (test #f (> +inf.0 +inf.0))

      (test #f (< -inf.0 -inf.0))
      (test #t (<= -inf.0 -inf.0))
      (test #t (= -inf.0 -inf.0))
      (test #t (>= -inf.0 -inf.0))
      (test #f (> -inf.0 -inf.0))

      (test #t (< -inf.0 +inf.0))
      (test #t (<= -inf.0 +inf.0))
      (test #f (= -inf.0 +inf.0))
      (test #f (>= -inf.0 +inf.0))
      (test #f (> -inf.0 +inf.0))

      (test 88962710306127702866241727433142015
          (string->number "#x00112233445566778899aabbccddeeff"))

      (test (expt 10 154) (sqrt (expt 10 308)))

      (test 36893488147419103231
          (- 340282366920938463463374607431768211456
             340282366920938463426481119284349108225))

      (test '(10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 0)
          (call-with-values (lambda () (exact-integer-sqrt (expt 10 308)))
            list))
      (test '(31622776601683793319988935444327185337195551393252168268575048527925944386392382213442481083793002951873472841528400551485488560304538800146905195967001539 2115514206302273599980766398157920200790560418205865231071804946360990550570367022991069288361418688781500755061112588417520206827470474760717813571631479)
          (call-with-values (lambda () (exact-integer-sqrt (expt 10 309)))
            list))

      ;; Steele's three-part test.
      (test #t #t)
      (test 100 (/ (factorial 100) (factorial 99)))
      (test -0.549306144334055+1.5707963267949i (atanh -2))

      ;; ... and variants
      (test -9900 (/ (- (factorial 100)) (factorial 98)))
      (test -10100 (/ (factorial 101) (- (factorial 99))))
      (test 100 (/ (- (factorial 100)) (- (factorial 98)) 99))

      (test #t (< 1/2 1.0))
      (test #t (< 1.0 3/2))
      (test #t (< 1/2 1.5))
      (test #t (< 1/2 2.0))
      (test 1.0 (max 1/2 1.0))
      (test 18446744073709551617 (numerator (/ 18446744073709551617 2)))
      (test "18446744073709551617/2" (number->string (/ 18446744073709551617 2)))
      (let ((a 1000000000000000000000000000000000000000)
            (b 31622776601683794000))
        (test 31622776601683792639 (quotient a b))
        (test 30922992657207634000 (remainder a b)))
      (let ((g 18446744073709551616/6148914691236517205))
        (test 36893488147419103231/113427455640312821148309287786019553280
            (- g (/ 9 g))))
      (let ((r  (/ (expt 2 61) 3)))
        (test 0 (- r r))
        (test 2305843009213693952/3 r))
      (let ((x (+ (expt 2 32) +2))
            (y (+ (expt 2 32) -1)))
        (test 0(remainder (* x y) y))
        (test 0(remainder (* x y) x)))
      (let ((x (+ (expt 2 64) +2))
            (y (+ (expt 2 64) -1)))
        (test 0(remainder (* x y) y))
        (test 0(remainder (* x y) x)))

      (test-end))))
