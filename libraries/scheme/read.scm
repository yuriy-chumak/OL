(define-library (scheme read)
(export
   read)

(import
   (scheme core)
   (owl interop) (owl io)
   (owl vector)
   (only (lang sexp) get-sexp))

(begin
; --------------------------

   ; math + simplification (hope we not use larger than max number of bytes files?)
   (define (+ n x)
      (values-apply (vm:add n x) (lambda (n carry) n)))
   (define (<< n x)
      (values-apply (vm:shl n x) (lambda (overflow n) n)))

   (define (read-impl port)
      (define server ['read])
      (fork-server server (lambda ()
         (let this ((cache #(0 0 0 0 0)) (pos 0))
            (let*((envelope (wait-mail))
                  (sender msg envelope))
               (if msg ; #false to stop the thread, else - number of character
                  (let loop ((cache cache) (pos pos))
                     (cond
                        ((eq? pos (size cache)) ; надо ли увеличить размер кеша?
                           (let ((cache (vm:makeb type-bytevector (vector->list cache) (<< (size cache) 1))))
                              (loop cache pos)))
                        ((less? msg pos)
                           (mail sender (ref cache msg)))
                        (else
                           ; let's read new byte..
                           (define char (syscall 0 port 1 #f))
                           (if (memq char '(#f #t #eof))
                              (mail sender char)
                              (begin
                                 (set-ref! cache pos (ref char 0))
                                 (loop cache (+ pos 1))))))
                     (this cache pos)))))))

      (define (non-buffered-input-stream-n n)
         (lambda ()
            (define in (interact server n))
            (case in
               (#f #null) ; port error
               (#t ; input not ready
                  (interact 'io 5)
                  (non-buffered-input-stream-n n))
               (#eof ; end-of-file
                  (close-port port)
                  #null)
               (else
                  (cons in (non-buffered-input-stream-n (+ n 1)))))))

      ((get-sexp)
            (non-buffered-input-stream-n 0)
            (λ (data fail val pos) ; ok
               (mail server #false)
               val)
            (λ (pos reason) ; fail
               (mail server #false)
               reason)
            0))

   ; public function
   (define read (case-lambda
      ((port)
         (read-impl port))
      (()
         (read-impl stdin))))

))
