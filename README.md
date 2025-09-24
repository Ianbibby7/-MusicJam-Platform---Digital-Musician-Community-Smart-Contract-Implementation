# MusicJam - Digital Musician Community Platform

A blockchain-based platform built on Stacks that connects musicians through jam sessions, practice tracking, and community-driven skill development, rewarding musical engagement with tokenized incentives.

## Overview

MusicJam creates a vibrant digital ecosystem where:
- **Musicians create jam sessions** with specific tempo, key, and genre requirements
- **Practice sessions are logged** with detailed technique focus and quality assessments
- **Community reviews** help identify the most engaging musical sessions
- **Skills develop** through tracked practice time and quality progression
- **Musical collaboration thrives** through shared sessions and peer feedback

## Key Features

### Musician Profiles
- Customizable usernames and primary instrument specialization
- Skill level progression (1-5) based on practice quality and consistency
- Track practices logged, sessions hosted, and total playing hours
- Support for major instruments: Guitar, Piano, Drums, Bass, Vocals

### Jam Session Creation
- Detailed session setup with musical specifications:
  - Genre classification (Rock, Jazz, Blues, Pop, Folk)
  - Tempo requirements (60-200 BPM)
  - Key signature specifications (Cmaj, Gmin, etc.)
  - Maximum player limits and session duration
- Host tracking and participant management
- Community groove rating system

### Practice Log System
- Comprehensive practice documentation:
  - Instrument used and technique focus (scales, chords, rhythm, improv)
  - Practice duration and tempo (40-250 BPM range)
  - Quality self-assessment (1-5 scale)
  - Productivity tracking for skill development
- Personal practice notes for reflection and improvement

### Community Review System
- 10-point rating system for jam session experiences
- Energy level assessments (mellow, medium, high)
- Groove voting system for highlighting exceptional reviews
- Anti-spam protection (one review per session per musician)

### Achievement System
- **player-105**: Dedicated Player (105+ practice sessions logged)
- **host-20**: Session Master (20+ jam sessions hosted)
- Milestone rewards: 8.1 MGT tokens per achievement

## MusicJam Groove Token (MGT)

### Token Economics
- **Symbol**: MGT
- **Decimals**: 6
- **Max Supply**: 53,000 MGT
- **Distribution**: Merit-based rewards for musical participation

### Reward Structure
- **Jam Session Creation**: 3.6 MGT tokens
- **Productive Practice**: 2.0 MGT tokens
- **Milestone Achievement**: 8.1 MGT tokens
- **Practice Attempt**: 0.67 MGT tokens (encouragement for effort)

## Technical Architecture

### Smart Contract Functions

#### Public Functions
- `create-jam-session`: Host new musical collaboration opportunities
- `log-practice`: Record practice sessions with detailed musical parameters
- `write-review`: Share session experiences with community ratings
- `vote-groove`: Highlight exceptional session reviews
- `update-instrument`: Change primary instrument specialization
- `claim-milestone`: Unlock achievement rewards
- `update-username`: Personalize musician identity

#### Read-Only Functions
- `get-musician-profile`: Retrieve musician statistics and specializations
- `get-jam-session`: Access session details and community ratings
- `get-practice-log`: View practice session records
- `get-session-review`: Read community session feedback
- `get-milestone`: Check achievement status

### Data Structures

#### Musician Profile
```clarity
{
  username: (string-ascii 24),
  instrument: (string-ascii 12),
  practices-logged: uint,
  sessions-hosted: uint,
  skill-level: uint,
  total-hours: uint,
  join-date: uint
}
```

#### Jam Session
```clarity
{
  session-title: (string-ascii 12),
  genre: (string-ascii 8),
  tempo: uint,
  key-signature: (string-ascii 4),
  max-players: uint,
  session-length: uint,
  host: principal,
  participant-count: uint,
  groove-rating: uint
}
```

#### Practice Log
```clarity
{
  session-id: uint,
  musician: principal,
  instrument-used: (string-ascii 12),
  practice-time: uint,
  technique-focus: (string-ascii 10),
  tempo-bpm: uint,
  quality-rating: uint,
  practice-notes: (string-ascii 25),
  productive: bool
}
```

## Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) development environment
- Stacks wallet for blockchain interactions
- Basic understanding of musical terminology (tempo, key signatures, genres)

### Installation
```bash
# Clone the repository
git clone https://github.com/your-org/musicjam-platform
cd musicjam-platform

# Install dependencies
clarinet install

# Run tests
clarinet test

# Deploy to testnet
clarinet deploy --testnet
```

### Usage Examples

#### Create a Jam Session
```clarity
(contract-call? .musicjam create-jam-session 
  "Jazz Night" 
  "jazz" 
  u120 
  "Cmaj" 
  u4 
  u90)
```

#### Log a Practice Session
```clarity
(contract-call? .musicjam log-practice
  u1
  "guitar"
  u45
  "scales"
  u100
  u4
  "Worked on pentatonic patterns"
  true)
```

#### Write a Session Review
```clarity
(contract-call? .musicjam write-review
  u1
  u9
  "Amazing energy and flow!"
  "high")
```

#### Claim an Achievement
```clarity
(contract-call? .musicjam claim-milestone "player-105")
```

## Platform Features

### Musical Session Management
- Tempo and key signature specifications for proper musical coordination
- Genre-based session organization for stylistic compatibility
- Maximum player limits to ensure quality jam experiences
- Session length planning for structured musical collaboration

### Practice Development Tracking
- Technique focus categories for targeted skill improvement
- Tempo tracking for technical development progression
- Quality self-assessment for honest skill evaluation
- Productivity distinction between practice attempts and productive sessions

### Community Quality Assurance
- Groove rating calculation based on participant feedback
- Energy level assessment for session atmosphere evaluation
- Voting system to surface exceptional session experiences
- Review authenticity through one-review-per-session policy

### Skill Progression System
- Dynamic skill level calculation based on practice quality
- Total hours tracking for dedication measurement
- Achievement milestones for long-term engagement recognition
- Practice consistency rewards for habit formation

## Security Features

- **Input validation** on all musical parameters (tempo ranges, rating scales)
- **Duplicate prevention** for reviews per session per musician
- **Bounds checking** for realistic musical values (BPM, quality ratings)
- **Supply cap protection** for token minting
- **Authorization verification** for profile updates

## Use Cases

### For Individual Musicians
- Track practice sessions with detailed technique focus
- Discover jam sessions matching skill level and musical interests
- Build reputation through consistent practice logging and session participation
- Earn rewards for musical dedication and community engagement

### For Music Teachers and Students
- Monitor student practice consistency and quality progression
- Organize structured jam sessions for educational purposes
- Track skill development through quantified practice metrics
- Build portfolio of musical activities and achievements

### For Musical Groups and Bands
- Coordinate practice sessions with detailed musical specifications
- Track group rehearsal productivity and engagement
- Build community reputation through quality session hosting
- Connect with compatible musicians for collaboration opportunities

### For Music Venues and Organizations
- Access verified musician skill levels and experience data
- Coordinate community jam sessions with established parameters
- Identify active musicians for performance opportunities
- Support local music community through tokenized incentives

## Future Enhancements

- **Live Session Integration**: Real-time jam session coordination tools
- **Recording Integration**: Audio/video session recording and sharing
- **Skill Assessment**: Automated practice quality evaluation
- **Booking System**: Venue integration for live performance scheduling
- **Educational Content**: Music theory and technique learning resources

## Contributing

We welcome contributions from the music community! Areas for contribution include:

### Musical Domain Expertise
- Music theory accuracy validation and improvement
- Genre and technique categorization refinement
- Skill progression algorithm enhancement
- Educational content development for music learning

### Technical Development
- Smart contract optimization and feature enhancement
- Frontend development for user interface improvement
- Mobile application development for practice logging
- Integration development for music software and hardware

### Community Building
- Beta testing with music groups and educational institutions
- Content creation for music community engagement
- Partnership development with music venues and organizations
- Community moderation and quality assurance

## Technical Considerations

### Musical Parameter Validation
- Tempo ranges (60-200 BPM for sessions, 40-250 BPM for practice) ensure realistic musical parameters
- Quality rating scales (1-5, 1-10) provide consistent assessment metrics
- Key signature format validation maintains musical accuracy
- Practice time validation prevents unrealistic session logging

### Gas Optimization
- Efficient storage patterns minimize transaction costs for frequent practice logging
- Simplified groove rating calculations reduce computational overhead
- Profile lazy loading for cost-effective musician onboarding
- String length optimization balances descriptiveness with storage costs

### Scalability
- Modular genre and instrument categories support platform expansion
- Extensible technique focus system for detailed practice tracking
- Efficient mapping patterns for quick session and practice data retrieval

## Community Guidelines

### Quality Standards
- Honest practice logging reflecting actual musical development efforts
- Constructive session reviews that help improve musical experiences
- Realistic tempo and timing specifications for achievable jam sessions
- Supportive feedback that encourages musical growth and learning

### Platform Etiquette
- Respect for different musical genres, skill levels, and learning approaches
- One review per session to prevent spam while encouraging genuine feedback
- Accurate self-assessment in practice logs for meaningful skill tracking
- Recognition of diverse musical backgrounds and cultural traditions

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Community

- **Discord**: Join musician discussions and coordinate jam sessions
- **Twitter**: Follow @MusicJamDAO for platform updates and featured sessions
- **Blog**: Read about musician stories and platform development

---

*MusicJam: Where musical passion meets digital innovation, creating harmonious communities that reward dedication and celebrate collaboration.*
