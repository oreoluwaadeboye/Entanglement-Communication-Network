;; Message Encoding and Decoding Contract

(define-data-var message-counter uint u0)

(define-map encoded-messages uint {
    sender: principal,
    pair-id: uint,
    encoded-data: (buff 1024),
    timestamp: uint,
    status: (string-ascii 20)
})

(define-public (encode-message (pair-id uint) (message (string-utf8 1000)))
    (let
        ((new-id (+ (var-get message-counter) u1))
         (encoded (hash message)))
        (map-set encoded-messages new-id {
            sender: tx-sender,
            pair-id: pair-id,
            encoded-data: encoded,
            timestamp: block-height,
            status: "encoded"
        })
        (var-set message-counter new-id)
        (ok new-id)
    )
)

(define-public (update-message-status (message-id uint) (new-status (string-ascii 20)))
    (let
        ((message (unwrap! (map-get? encoded-messages message-id) (err u404))))
        (asserts! (is-eq tx-sender (get sender message)) (err u403))
        (ok (map-set encoded-messages message-id
            (merge message { status: new-status })))
    )
)

(define-read-only (get-encoded-message (message-id uint))
    (map-get? encoded-messages message-id)
)

(define-read-only (get-message-count)
    (var-get message-counter)
)

