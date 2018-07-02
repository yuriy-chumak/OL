;;;; random number generator
(define-library (otus random!)

   (export
      rand!)

   (import
      (scheme core)
      (owl math)
      (owl time))

(begin

; (rand limit)
;(define rand!
;   (let* ((ss ms (clock))
;          (seed (cons ms ss)))
;      (lambda (limit)
;         (let* ((x (car seed))
;                (a _ (vm:mul x 214013))
;                (b _ (vm:add a 2531011))
;                (c _ (vm:shr b 16))
;                (o p d (vm:div 0 c limit)))
;            (set-car! seed c)
;            d))))

(define rand!
   (let* ((ss ms (clock))
          (seed (band (+ ss ms) #xffffffff))
          (seed (cons (band seed #xffffff) (>> seed 24))))
      (lambda (limit)
         (let*((next (+ (car seed) (<< (cdr seed) 24)))
               (next (+ (* next 1103515245) 12345)))
            (set-car! seed (band     next     #xffffff))
            (set-cdr! seed (band (>> next 24) #xffffff))

            (mod (mod (floor (/ next 65536)) 32768) limit)))))

; based on Marsaglia's letter: http://www.cse.yorku.ca/~oz/marsaglia-rng.html

; The MWC generator concatenates two 16-bit multiply-
;   with-carry generators, x(n)=36969x(n-1) + carry,
;   y(n)=18000y(n-1)+carry mod 2^16, has period about
;   2^60 and seems to pass all tests of randomness. A
;   favorite stand-alone generator.
; #define znew (z=36969*(z&65535)+(z>>16))
; #define wnew (w=18000*(w&65535)+(w>>16))
; #define MWC ((znew<<16)+wnew)

;      (define rand!
;         (let* ((ss ms (clock))
;                (seed (cons ms ss)))
;            (lambda (limit)
;               (let* ((x (car seed))
;                      (a _ (vm:mul x 214013))
;                      (b _ (vm:add a 2531011))
;                      (c _ (vm:shr b 16))
;                      (o p d (vm:div 0 c limit)))
;                  (set-car! seed c)
;                  d))))


))
