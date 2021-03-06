#!/usr/bin/env ol

(define all (iota 999 2))

(print
   (let main ((left '()) (right all))
      (if (null? right)
         (reverse left)
         (if (not (car right))
            (main left (cdr right))
            (let loop ((l '()) (r right) (n 0) (every (car right)))
               (if (null? r)
                  (let ((l (reverse l)))
                     (main (cons (car l) left) (cdr l)))
                  (if (eq? n every)
                     (loop (cons #false l) (cdr r) 1 every)
                     (loop (cons (car r) l) (cdr r) (+ n 1) every)))))))
)
