use v6;

class ScaleVec::Chord::System {
  use ScaleVec::Chord::Graph;
  use ScaleVec::Chord::Map;
  use Result;

  has ScaleVec::Chord::Graph %.graph;
  has ScaleVec::Chord::Map   $.map handles <sv pv sym> is required;

  method merge-graphs( --> ScaleVec::Chord::Graph) {
    reduce { $^a.graph-union($^b) }, $_[0], |$_[1..*] given %!graph.values
  }

  method merge-systems(ScaleVec::Chord::System $other --> Result::Any) {
    for $other.graph.keys -> $symbol {
      return Err "Conflicting graphs identified by symbol '$symbol' in ScaleVec::Chord::System merge."
        if $symbol ~~ any(%!graph.keys)
    }

    Ok ScaleVec::Chord::System.new(
      :map( $!map.merge($other.map) )
      :graph( %(|$other.graph, |%!graph) )
    )
  }
}