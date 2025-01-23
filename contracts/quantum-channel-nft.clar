;; Quantum Channel NFT Contract

(define-non-fungible-token quantum-channel-nft uint)

(define-data-var token-id-counter uint u0)

(define-map token-metadata uint {
    creator: principal,
    channel-type: (string-ascii 50),
    entanglement-quality: uint,
    created-at: uint
})

(define-public (mint-quantum-channel-nft (channel-type (string-ascii 50)) (entanglement-quality uint))
    (let
        ((new-id (+ (var-get token-id-counter) u1)))
        (try! (nft-mint? quantum-channel-nft new-id tx-sender))
        (map-set token-metadata new-id {
            creator: tx-sender,
            channel-type: channel-type,
            entanglement-quality: entanglement-quality,
            created-at: block-height
        })
        (var-set token-id-counter new-id)
        (ok new-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) (err u403))
        (nft-transfer? quantum-channel-nft token-id sender recipient)
    )
)

(define-read-only (get-token-metadata (token-id uint))
    (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
    (var-get token-id-counter)
)

