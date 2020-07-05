#lang info
(define collection "icu")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/icu.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(griswold))
(define copy-foreign-libs '("lib/libicudata.dylib" "lib/libicuuc.dylib"))
