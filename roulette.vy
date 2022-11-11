players : public(DynArray[address, 100])
losers : public(DynArray[address, 100])
odds: public(uint256)
playersTurn : public(uint256)
creator : public(address)
bigPrime1 : public(uint256)
bigPrime2 : public(uint256)
currentSeed : public(uint256)

@external
def __init__(p : DynArray[address, 100], l : DynArray[address, 100], o : uint256):
    self.players = p
    self.losers = l
    self.odds = o
    self.playersTurn = 0
    self.creator = msg.sender

    # Private instance variables that determine randomness
    # These have been tested in a separate program to show that they generate somewhat random-looking results and are close enough to being even (for a few different tested odds)
    self.bigPrime1 = 8713
    self.bigPrime2 = 9857
    # currentSeed doesn't really matter and it'll change as the game goes on
    self.currentSeed = 12345

@external
def setOdds(newOdds : uint256):
    self.odds = newOdds

@external
def addPlayer(newPlayer : address):
    found : bool = False

    for player in self.losers:
        if player == newPlayer:
            found = True

    for player in self.players:
        if player == newPlayer:
            found = True
    
    if not found:
        self.players.append(newPlayer)

@internal
def lose (player : address):
    newPlayers : DynArray[address, 100] = []
    for person in self.players:
        if person != player:
            newPlayers.append(person)
    self.players = newPlayers

@internal
def random() -> uint256:
    self.currentSeed = self.currentSeed * self.bigPrime1 % self.bigPrime2

    return self.currentSeed % self.odds


@external
def play():
    if self.random() == 0:
        self.lose(self.players[self.playersTurn])
    else:
        self.playersTurn += 1
    
    if self.playersTurn >= len(self.players):
        self.playersTurn = 0

@external
def isALoser(player : address) -> bool:
    if player in self.players:
        return True
    return False

