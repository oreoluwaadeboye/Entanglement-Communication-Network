;; Network Node Operations Contract

(define-data-var node-counter uint u0)

(define-map network-nodes uint {
    operator: principal,
    location: (string-ascii 100),
    public-key: (buff 33),
    status: (string-ascii 20),
    last-active: uint
})

(define-public (register-node (location (string-ascii 100)) (public-key (buff 33)))
    (let
        ((new-id (+ (var-get node-counter) u1)))
        (map-set network-nodes new-id {
            operator: tx-sender,
            location: location,
            public-key: public-key,
            status: "active",
            last-active: block-height
        })
        (var-set node-counter new-id)
        (ok new-id)
    )
)

(define-public (update-node-status (node-id uint) (new-status (string-ascii 20)))
    (let
        ((node (unwrap! (map-get? network-nodes node-id) (err u404))))
        (asserts! (is-eq tx-sender (get operator node)) (err u403))
        (ok (map-set network-nodes node-id
            (merge node {
                status: new-status,
                last-active: block-height
            })))
    )
)

(define-read-only (get-network-node (node-id uint))
    (map-get? network-nodes node-id)
)

(define-read-only (get-node-count)
    (var-get node-counter)
)

