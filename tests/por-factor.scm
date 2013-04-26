(define num (+ (band (time-ms) 32767) 2))

(define por-opts 
   (map 
      (λ (try) (λ () (ediv num try)))
      (iota 2 1 (isqrt num))))

(define (xor a b)
   (if a b (if b #false (not a))))

(print
   (xor
      (prime? num)
      (not (por* por-opts))))
