package Treex::Block::My::ExtractAnimacyTable;

use Moose;
use utf8;

use Treex::Tool::ML::VowpalWabbit::Util;
use Data::Dumper;

extends 'Treex::Block::Write::BaseTextWriter';

has 'labeled' => ( is => 'ro', isa => 'Bool', default => '1' );

my $classes = [
    "class animacy=0",
    "class animacy=1",
];
my $classes_comments = [
    "", ""
];

sub process_tnode {
    my ($self, $tnode) = @_;

    # not a verb
    return if (($tnode->gram_sempos // "") !~ /^v/);

    my @children;
    if ($self->labeled) {
        @children = grep {$_->t_lemma eq "#PersPron" && ($_->gram_person // "") eq "3" && ($_->gram_number // "") eq "sg" } $tnode->get_echildren;
    }
    else {
        @children = grep {$_->t_lemma ne "#PersPron" && ($_->gram_sempos // "") =~ /^n\.denot/} $tnode->get_echildren;
    }

    foreach my $kid (@children) {
        my $common_feats = _extract_feats($tnode, $kid);
        my $feats = [ $classes, $common_feats ];
        #print STDERR Dumper($feats);
        my $losses;
        if ($self->labeled) {
            $losses = ($kid->gram_gender // "") =~ /^[faim]/ ? [1, 0] : [0, 1];
        }
        my $comments = [ $classes_comments, $tnode->get_address ];
        my $instance_str = Treex::Tool::ML::VowpalWabbit::Util::format_multiline($feats, $losses, $comments);

        print {$self->_file_handle} $instance_str;
    }
}

sub _extract_feats {
    my ($verb, $kid) = @_;

    my @feats = ();
    push @feats, [ 'verb_lemma', $verb->t_lemma ];
    push @feats, [ 'functor', $kid->functor ];
    push @feats, [ 'kid_lemma', $kid->t_lemma ];
    push @feats, [ 'verb_lemma_functor', $verb->t_lemma . "_" . $kid->functor ];

    return \@feats;
}

1;
