module PlayingCards

import Base.show

import Random: shuffle!

export Card, Hand, isFullHouse, isRoyalFlush, runTrials

ranks = ['A','2','3','4','5','6','7','8','9','T','J','Q','K']
suits = ['\u2660','\u2661','\u2662','\u2663']

"""
    Card(r::Int, s::Int)
    Card(i::Int)
    Card(str::String)

Create a Card object that represents a playing card with rank `r` and suit `s`.  The rank must satisfy `1<=r<=13` and
the suit represents `1<=s<=4`.   In addition, one can make a Card with a single integer `n`
that satifies `1<=n<=52`. Lastly, You can create a Card with a string consisting of the rank as `A,1,2,3,...,9,T,J,Q,K`
and the suit ♣,♠,♡,♢.

# Examples
```julia-repl
julia> Card(10,3)
T♡

julia> Card(33)
7♢

julia> Card("J♠")
J♠
```
"""
struct Card
    rank::Int
    suit::Int

    # construct a card based on the rank and suit
    function Card(r::Int,s::Int)
        1 <= r <=13  || throw(ArgumentError("The rank must be an integer between 1 and 13."))
        1 <= s <= 4  || throw(ArgumentError("The suit must be an integer between 1 and 4."))
        new(r,s)
    end

    # construct a card based on the number in a deck
    function Card(i::Int)
        1 <= i <= 52 || throw(ArgumentError("The argument must be an integer between 1 and 52"))
        i%13==0 ? new(13,div(i,13)) : new(i%13,div(i,13)+1)
    end

    # construct a card based on a string representation of the card
    function Card(str::String)
        length(str)==2 || throw(ArgumentError("The string should only be 2 characters"))
        local r = findfirst(a->a==str[1],ranks)
        !isnothing(r) &&  1 <= r <= 13 || throw(ArgumentError(string("The first character should be one of ",join(ranks,","))))
        local s=findfirst(a->a==str[2],suits)
        !isnothing(s) && 1<= s <= 4 || throw(ArgumentError(string("The second character should be one of ",join(suits,","))))
        new(r,s)
    end
end

"""
  Hand(cards::Vector{Card})
  Hand(cards::Vector{String})
  Hand(str::String)

Create a Hand (set of cards) from either a vector of cards, a Vector of Strings or a String.  The argument for `Hand` can
be a Vector of Cards or a Vector of Strings (if each string can create a Card).  Also, if a string consists of Cards separated by
  commas, then a Hand can be created.

# Examples
```julia-repl
julia> Hand([Card(10,3), Card(11,3), Card(5,2), Card(5,3), Card(1,1)])
[T♢,J♢,5♡,5♢,A♠]

julia> Hand(["T♢","J♢","5♡","5♢","A♠"])
[T♢,J♢,5♡,5♢,A♠]

julia> Hand("T♢,J♢,5♡,5♢,A♠")
[T♢,J♢,5♡,5♢,A♠]
```
"""
struct Hand
    cards::Vector{Card}

    Hand(cards::Vector{Card}) = new(cards)
    Hand(cards::Vector{String}) = new(map(Card,cards))
    Hand(s::String) = new(map(Card,map(String,split(s,','))))
end

function Base.show(io::IO, c::Card)
  print(io,string(ranks[c.rank],suits[c.suit]))
end

function Base.show(io::IO, h::Hand)
  print(io,string("[",join(map(c->string(ranks[c.rank], suits[c.suit]), h.cards), ",")), "]")
end

"""
    isFullHouse(h::Hand)

Returns true if a given hand, `h` is a full house hand.  It returns false otherwise.
"""
function isFullHouse(h::Hand)
    local r=sort(map(c->c.rank,h.cards))
    r[2]==r[1] && r[5]==r[4] && (r[3]==r[2] || r[4]==r[3]) && r[2] != r[4]
end

"""
    isOneSuit(h::Hand)

Returns a true if for a given hand, `h` all cards in the Hand are the same suit.  It returns false otherwise.
"""
function isOneSuit(h::Hand)
  local s = map(c->c.suit,h.cards)
  s[1]==s[2]==s[3]==s[4]==s[5]
end

"""
    isRun(h::Hand)

Returns true if for a given hand, `h` all cards in the Hand are the same suit.  It returns false otherwise.
"""
function isRun(h::Hand)
  local r = sort(map(c->c.rank,h.cards))
  r[2]==r[1]+1 && r[3]==r[2]+1 && r[4]==r[3]+1 && r[5]==r[4]+1 ||
  r[1]==1 && r[2]==10 && r[3]==11 && r[4]==12 && r[5]==13 ## ace high run
end

"""
    isRoyalFlush(h::Hand)

Returns a boolean if the given hand, `h`, is a RoyalFlush
"""
function isRoyalFlush(h::Hand)
  local r = sort(map(c->c.rank,h.cards))
  r[1]==1 && r[2]==10 && r[3]==11 && r[4]==12 && r[5]==13 && isOneSuit(h)
end

"""
    runTrials(f::Function, trials::Integer)

For `trials` randomly selected hands, run the function `f` on each hand.  The fraction of hands where `f` is true is returned.

### Example
```julia-repl
runTrials(isFullHouse, 10_000_000)
```
"""
function runTrials(f::Function, trials::Integer)
  local deck=collect(1:52) # creates the array [1,2,3,...,52]
  local num_hands=0
  for i=1:trials
    shuffle!(deck)
    h = Hand(map(Card,deck[1:5])) # creates a hand of the first five cards of the shuffled deck
    if f(h)
      num_hands+=1
    end
  end
  num_hands/trials
end

end #module PlayingCards
