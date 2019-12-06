(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement.

(define (cons-all first rests)
  (map 
    (lambda (x) (append (list first) x))
    rests
  )
)

(define (zip pairs)
  (list (map car pairs) (map cadr pairs))
)
;(zip '((1 2) (3 4) (5 6)))
;; Problem 16
;; Returns a list of two-element lists
(define (enumerate s)
  ; BEGIN PROBLEM 16
  (define (helper s i) 
    (if (null? s) 
      nil 
      (cons (cons i (cons (car s) nil)) (helper (cdr s) (+ i 1)))))
  (helper s 0)
)
  ; END PROBLEM 16
;(enumerate '(3 4 5 6))
;(enumerate '())

;; Problem 17
;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
  ; BEGIN PROBLEM 17
  (if (null? denoms)
    nil
    (if (= total 0) (list nil) 
      (let ((x (car denoms))) 
        (if (< total x) 
          (list-change total (cdr denoms))
          (append
            (cons-all x 
              (list-change (- total x) denoms)
            )
            (list-change total (cdr denoms))
          )
        )
      )
    )
  )
)
; END PROBLEM 17

;(list-change 10 '(25 10 5 1))

;; Problem 18
;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond 
    ((atom? expr)
      ; BEGIN PROBLEM 18
      expr
      ; END PROBLEM 18
    )
    ((quoted? expr)
      ; BEGIN PROBLEM 18
      expr
      ; END PROBLEM 18
    )
    ((or (lambda? expr)
          (define? expr))
      (let ((form (car expr))
            (params (cadr expr))
            (body   (cddr expr)))
        ; BEGIN PROBLEM 18
        (cons form (cons params (map let-to-lambda body)))
        ; END PROBLEM 18
      )
    )
    ((let? expr)
      (let ((values (cadr expr))
            (body   (cddr expr)))
        ; BEGIN PROBLEM 18
        (cons 
          (cons 'lambda (cons (car (zip values)) (map let-to-lambda body))) 
          (map let-to-lambda (cadr (zip values)))
        )
        ; END PROBLEM 18
      )
    )
    (else
      ; BEGIN PROBLEM 18
      (cons (car expr) (map let-to-lambda (cdr expr)))
      ; END PROBLEM 18
    )
  )
)

(define let-to-lambda-code 
 '(define (let-to-lambda expr)
    (cond 
      ((atom? expr) expr)
      ((quoted? expr) expr)
      ((or (lambda? expr)
            (define? expr))
        (let ((form (car expr))
              (params (cadr expr))
              (body   (cddr expr)))
          (cons form (cons params (map let-to-lambda body)))
        )
      )
      ((let? expr)
        (let ((values (cadr expr))
              (body   (cddr expr)))
          (cons 
            (cons 'lambda (cons (car (zip values)) (map let-to-lambda body))) 
            (map let-to-lambda (cadr (zip values)))
          )
        )
      )
      (else 
        (cons (car expr) (map let-to-lambda (cdr expr)))
      )
    )
  )
)

(define let-to-lambda-without-let
  (let-to-lambda let-to-lambda-code))

(let-to-lambda '(let ((a 1) (b 2)) (+ (- a 1) b)))

(let-to-lambda '(let ((a 1)) (let ((b a)) b)))

(eval let-to-lambda-without-let)

(let-to-lambda '(let ((a 1) (b 2)) (+ (- a 1) b)))

(let-to-lambda '(let ((a 1)) (let ((b a)) b)))
