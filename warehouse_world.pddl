(define (domain warehouse)
  (:requirements :typing)
  (:types robot pallette - bigobject
          location shipment order saleitem)

    (:predicates
      (ships ?s - shipment ?o - order)
      (orders ?o - order ?si - saleitem)
      (unstarted ?s - shipment)
      (started ?s - shipment)
      (complete ?s - shipment)
      (includes ?s - shipment ?si - saleitem)

      (free ?r - robot)
      (has ?r - robot ?p - pallette)

      (packing-location ?l - location)
      (packing-at ?s - shipment ?l - location)
      (available ?l - location)
      (connected ?l - location ?l - location)
      (at ?bo - bigobject ?l - location)
      (no-robot ?l - location)
      (no-pallette ?l - location)

      (contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?ls - location ?le - location)
      :precondition (and (connected ?ls ?le) (no-robot ?le) (not(at ?r ?le)) (at ?r ?ls) (not (no-robot ?ls)))
      :effect (and (no-robot ?ls) (not (no-robot ?le)) (at ?r ?le) (not(at ?r ?ls)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?ls - location ?le - location ?p - pallette)
      :precondition (and (no-pallette ?le) (not(at ?r ?le)) (at ?r ?ls) (not(at ?p ?le)) (at ?p ?ls)(connected ?ls ?le) (no-robot ?le) (not (no-robot ?ls)) (not (no-pallette ?ls)))
      :effect (and (no-pallette ?ls) (not(at ?r ?ls)) (at ?r ?le) (not(at ?p ?ls)) (at ?p ?le)(not (no-pallette ?le)) (no-robot ?ls) (not (no-robot ?le)) (has ?r ?p))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (not (no-pallette ?l)) (at ?p ?l) (not (includes ?s ?si)) (contains ?p ?si) (packing-at ?s ?l) (not (complete ?s)) (ships ?s ?o) (started ?s) (packing-location ?l) (not (available ?l)))
      :effect (and (includes ?s ?si) (at ?p ?l) (not (contains ?p ?si)) (not (no-pallette ?l)) (not (complete ?s)) (ships ?s ?o) (started ?s) (not (available ?l)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (not (available ?l)) (packing-at ?s ?l) (packing-location ?l))
      :effect (and (not (started ?s)) (complete ?s) (not (packing-at ?s ?l)) (available ?l) (not (no-pallette ?l)))
   )
   
)
