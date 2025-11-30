#lang racket/base

(require racket/async-channel
         web-server/servlet
         web-server/servlet-dispatch
         web-server/web-server)

(provide start)

(define (start)
  (define confirmation-ch
    (make-async-channel))
  (define stop
    (serve
     #:port 0
     #:dispatch (dispatch/servlet
                 (lambda (_req)
                   (response/output
                    #:headers (list (make-header #"X-Example" #"Found"))
                    (lambda (out)
                      (displayln "hello" out)))))
     #:confirmation-channel confirmation-ch))
  (define port-or-exn
    (sync confirmation-ch))
  (when (exn:fail? port-or-exn)
    (raise port-or-exn))
  (values stop port-or-exn))
