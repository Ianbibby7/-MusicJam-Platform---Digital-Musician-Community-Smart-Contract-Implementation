;; MusicJam - Digital Musician Community Platform
;; A blockchain-based platform for jam sessions, practice logs,
;; and musician community rewards

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))

;; Token constants
(define-constant token-name "MusicJam Groove Token")
(define-constant token-symbol "MGT")
(define-constant token-decimals u6)
(define-constant token-max-supply u53000000000) ;; 53k tokens with 6 decimals

;; Reward amounts (in micro-tokens)
(define-constant reward-practice u2000000) ;; 2.0 MGT
(define-constant reward-session u3600000) ;; 3.6 MGT
(define-constant reward-milestone u8100000) ;; 8.1 MGT

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var next-session-id uint u1)
(define-data-var next-practice-id uint u1)

;; Token balances
(define-map token-balances principal uint)

;; Musician profiles
(define-map musician-profiles
  principal
  {
    username: (string-ascii 24),
    instrument: (string-ascii 12), ;; "guitar", "piano", "drums", "bass", "vocal"
    practices-logged: uint,
    sessions-hosted: uint,
    skill-level: uint, ;; 1-5
    total-hours: uint,
    join-date: uint
  }
)

;; Jam sessions
(define-map jam-sessions
  uint
  {
    session-title: (string-ascii 12),
    genre: (string-ascii 8), ;; "rock", "jazz", "blues", "pop", "folk"
    tempo: uint, ;; BPM
    key-signature: (string-ascii 4), ;; "Cmaj", "Gmin", etc
    max-players: uint,
    session-length: uint, ;; minutes
    host: principal,
    participant-count: uint,
    groove-rating: uint ;; average rating
  }
)

;; Practice logs
(define-map practice-logs
  uint
  {
    session-id: uint,
    musician: principal,
    instrument-used: (string-ascii 12),
    practice-time: uint, ;; minutes
    technique-focus: (string-ascii 10), ;; "scales", "chords", "rhythm", "improv"
    tempo-bpm: uint,
    quality-rating: uint, ;; 1-5
    practice-notes: (string-ascii 25),
    practice-date: uint,
    productive: bool
  }
)

;; Session reviews
(define-map session-reviews
  { session-id: uint, reviewer: principal }
  {
    rating: uint, ;; 1-10
    review-text: (string-ascii 25),
    energy-level: (string-ascii 6), ;; "mellow", "medium", "high"
    review-date: uint,
    groove-votes: uint
  }
)

;; Musician milestones
(define-map musician-milestones
  { musician: principal, milestone: (string-ascii 12) }
  {
    achievement-date: uint,
    practice-count: uint
  }
)

;; Helper function to get or create profile
(define-private (get-or-create-profile (musician principal))
  (match (map-get? musician-profiles musician)
    profile profile
    {
      username: "",
      instrument: "guitar",
      practices-logged: u0,
      sessions-hosted: u0,
      skill-level: u1,
      total-hours: u0,
      join-date: stacks-block-height
    }
  )
)

;; Token functions
(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-decimals)
  (ok token-decimals)
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? token-balances user)))
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let (
    (current-balance (default-to u0 (map-get? token-balances recipient)))
    (new-balance (+ current-balance amount))
    (new-total-supply (+ (var-get total-supply) amount))
  )
    (asserts! (<= new-total-supply token-max-supply) err-invalid-input)
    (map-set token-balances recipient new-balance)
    (var-set total-supply new-total-supply)
    (ok amount)
  )
)

;; Create jam session
(define-public (create-jam-session (session-title (string-ascii 12)) (genre (string-ascii 8)) (tempo uint) (key-signature (string-ascii 4)) (max-players uint) (session-length uint))
  (let (
    (session-id (var-get next-session-id))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len session-title) u0) err-invalid-input)
    (asserts! (and (>= tempo u60) (<= tempo u200)) err-invalid-input)
    (asserts! (> max-players u0) err-invalid-input)
    (asserts! (> session-length u0) err-invalid-input)
    
    (map-set jam-sessions session-id {
      session-title: session-title,
      genre: genre,
      tempo: tempo,
      key-signature: key-signature,
      max-players: max-players,
      session-length: session-length,
      host: tx-sender,
      participant-count: u0,
      groove-rating: u0
    })
    
    ;; Update profile
    (map-set musician-profiles tx-sender
      (merge profile {sessions-hosted: (+ (get sessions-hosted profile) u1)})
    )
    
    ;; Award session creation tokens
    (try! (mint-tokens tx-sender reward-session))
    
    (var-set next-session-id (+ session-id u1))
    (print {action: "jam-session-created", session-id: session-id, host: tx-sender})
    (ok session-id)
  )
)

;; Log practice session
(define-public (log-practice (session-id uint) (instrument-used (string-ascii 12)) (practice-time uint) (technique-focus (string-ascii 10)) (tempo-bpm uint) (quality-rating uint) (practice-notes (string-ascii 25)) (productive bool))
  (let (
    (practice-id (var-get next-practice-id))
    (jam-session (unwrap! (map-get? jam-sessions session-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> practice-time u0) err-invalid-input)
    (asserts! (and (>= tempo-bpm u40) (<= tempo-bpm u250)) err-invalid-input)
    (asserts! (and (>= quality-rating u1) (<= quality-rating u5)) err-invalid-input)
    
    (map-set practice-logs practice-id {
      session-id: session-id,
      musician: tx-sender,
      instrument-used: instrument-used,
      practice-time: practice-time,
      technique-focus: technique-focus,
      tempo-bpm: tempo-bpm,
      quality-rating: quality-rating,
      practice-notes: practice-notes,
      practice-date: stacks-block-height,
      productive: productive
    })
    
    ;; Update session participant count if productive
    (if productive
      (map-set jam-sessions session-id
        (merge jam-session {participant-count: (+ (get participant-count jam-session) u1)})
      )
      true
    )
    
    ;; Update profile
    (if productive
      (begin
        (map-set musician-profiles tx-sender
          (merge profile {
            practices-logged: (+ (get practices-logged profile) u1),
            total-hours: (+ (get total-hours profile) (/ practice-time u60)),
            skill-level: (+ (get skill-level profile) (/ quality-rating u15))
          })
        )
        (try! (mint-tokens tx-sender reward-practice))
        true
      )
      (begin
        (try! (mint-tokens tx-sender (/ reward-practice u3)))
        true
      )
    )
    
    (var-set next-practice-id (+ practice-id u1))
    (print {action: "practice-logged", practice-id: practice-id, session-id: session-id})
    (ok practice-id)
  )
)

;; Write session review
(define-public (write-review (session-id uint) (rating uint) (review-text (string-ascii 25)) (energy-level (string-ascii 6)))
  (let (
    (jam-session (unwrap! (map-get? jam-sessions session-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (and (>= rating u1) (<= rating u10)) err-invalid-input)
    (asserts! (> (len review-text) u0) err-invalid-input)
    (asserts! (is-none (map-get? session-reviews {session-id: session-id, reviewer: tx-sender})) err-already-exists)
    
    (map-set session-reviews {session-id: session-id, reviewer: tx-sender} {
      rating: rating,
      review-text: review-text,
      energy-level: energy-level,
      review-date: stacks-block-height,
      groove-votes: u0
    })
    
    ;; Update session groove rating (simplified calculation)
    (let (
      (current-groove (get groove-rating jam-session))
      (participant-count (get participant-count jam-session))
      (new-groove (if (> participant-count u0)
                    (/ (+ (* current-groove participant-count) rating) (+ participant-count u1))
                    rating))
    )
      (map-set jam-sessions session-id (merge jam-session {groove-rating: new-groove}))
    )
    
    (print {action: "review-written", session-id: session-id, reviewer: tx-sender})
    (ok true)
  )
)

;; Vote review groove
(define-public (vote-groove (session-id uint) (reviewer principal))
  (let (
    (review (unwrap! (map-get? session-reviews {session-id: session-id, reviewer: reviewer}) err-not-found))
  )
    (asserts! (not (is-eq tx-sender reviewer)) err-unauthorized)
    
    (map-set session-reviews {session-id: session-id, reviewer: reviewer}
      (merge review {groove-votes: (+ (get groove-votes review) u1)})
    )
    
    (print {action: "review-voted-groove", session-id: session-id, reviewer: reviewer})
    (ok true)
  )
)

;; Update instrument
(define-public (update-instrument (new-instrument (string-ascii 12)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-instrument) u0) err-invalid-input)
    
    (map-set musician-profiles tx-sender (merge profile {instrument: new-instrument}))
    
    (print {action: "instrument-updated", musician: tx-sender, instrument: new-instrument})
    (ok true)
  )
)

;; Claim milestone
(define-public (claim-milestone (milestone (string-ascii 12)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (is-none (map-get? musician-milestones {musician: tx-sender, milestone: milestone})) err-already-exists)
    
    ;; Check milestone requirements
    (let (
      (milestone-met
        (if (is-eq milestone "player-105") (>= (get practices-logged profile) u105)
        (if (is-eq milestone "host-20") (>= (get sessions-hosted profile) u20)
        false)))
    )
      (asserts! milestone-met err-unauthorized)
      
      ;; Record milestone
      (map-set musician-milestones {musician: tx-sender, milestone: milestone} {
        achievement-date: stacks-block-height,
        practice-count: (get practices-logged profile)
      })
      
      ;; Award milestone tokens
      (try! (mint-tokens tx-sender reward-milestone))
      
      (print {action: "milestone-claimed", musician: tx-sender, milestone: milestone})
      (ok true)
    )
  )
)

;; Update username
(define-public (update-username (new-username (string-ascii 24)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-username) u0) err-invalid-input)
    (map-set musician-profiles tx-sender (merge profile {username: new-username}))
    (print {action: "username-updated", musician: tx-sender})
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-musician-profile (musician principal))
  (map-get? musician-profiles musician)
)

(define-read-only (get-jam-session (session-id uint))
  (map-get? jam-sessions session-id)
)

(define-read-only (get-practice-log (practice-id uint))
  (map-get? practice-logs practice-id)
)

(define-read-only (get-session-review (session-id uint) (reviewer principal))
  (map-get? session-reviews {session-id: session-id, reviewer: reviewer})
)

(define-read-only (get-milestone (musician principal) (milestone (string-ascii 12)))
  (map-get? musician-milestones {musician: musician, milestone: milestone})
)