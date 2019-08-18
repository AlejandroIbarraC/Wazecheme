#|------------------------------------------------------------------------------
                            WAZESCHEME PATH ENGINE

  Implementation of path search algorithms in graphs, used to show routes on
  maps.

  The search algorithms implemented are:
    * Deep First Search
    * Breadh First Search

  The functions implemented were inspired by the book: "Introducción a la
  programación en Scheme"(José E. Helio Guzmán)

  Developed by @estalvgs1999 and @shuzz22260427
------------------------------------------------------------------------------|#
#lang racket

(require "graph-lib.rkt"
         "../util-src/util.rkt")
         
(provide get-path)

;; (DFS start end graph)
;; Search for a route by searching in depth
;; * Based on book page 382
> (define (DFS start end graph)
    (cond ((equal? start end)
            (list start))
          (else
            (DFS-aux (list (list start)) end graph))))

> (define (DFS-aux paths end graph)
    (cond ((null? paths)
            '())
          ((equal? end (caar paths))
            (reverse (car paths)))
          (else
            (DFS-aux (append (extend (car paths) graph)
                             (cdr paths))
                     end
                     graph))))

;;------------------------------------------------------------------------------
;; (DFS-ALL start end graph)
;; Search for a route by depth search first
;; * Based on book pages 383 - 384
> (define (DFS-ALL start end graph)
    (cond ((equal? start end)
            (list start))
          (else
            (DFS-ALL-aux (list (list start)) end graph '()))))

> (define (DFS-ALL-aux paths end graph total)
    (cond ((null? paths)
            (apply-fun reverse total)) ;; Coincidentally, applying the reverse results in the list with the routes ordered from least to greatest.
          ((solution? end (car paths))
            (DFS-ALL-aux (cdr paths)
                         end
                         graph
                         (cons (car paths) total)))
          (else
            (DFS-ALL-aux (append (extend (car paths) graph)
                             (cdr paths))
                         end
                         graph
                         total))))

;;------------------------------------------------------------------------------
;; (BFS-ALL start end graph)
;; Search for a route by breadth search first
;; * Based on book page 384
> (define (BFS-ALL start end graph)
    (cond ((equal? start end)
            (list start))
          (else
            (BFS-ALL-aux (list (list start)) end graph '()))))

> (define (BFS-ALL-aux paths end graph total)
    (cond ((null? paths)
            (apply-fun reverse total))
          ((solution? end (car paths))
            (BFS-ALL-aux (cdr paths)
                         end
                         graph
                         (cons (car paths) total)))
          ;; The implementation between DFS and BFS only differs in this line of code
          (else
            (BFS-ALL-aux (append (cdr paths)
                                 (extend (car paths) graph))
                         end
                         graph
                         total))))

;;------------------------------------------------------------------------------

> (define (get-path start end graph)
      (sort-by-weight (DFS-ALL start end graph) graph))