package Pod::CopyrightYears;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Error::Pure qw(err);
use Pod::Abstract;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Pod file to update.
	$self->{'pod_file'} = undef;

	# Section names to update.
	$self->{'section_names'} = [
		'LICENSE AND COPYRIGHT',
	];

	# Process parameters.
	set_params($self, @params);

	if (! defined $self->{'pod_file'}) {
		err "Parameter 'pod_file' is required.";
	}
	$self->{'pod_abstract'} = Pod::Abstract->load_file($self->{'pod_file'});

	return $self;
}

sub change_years {
	my ($self, $year) = @_;

	if (! defined $year) {
		$year = (localtime(time))[5] + 1900;
	}

	foreach my $pod_node ($self->license_sections) {
		$self->_iterate_node($pod_node, $year);
	}

	return;
}

sub license_sections {
	my $self = shift;

	my @pod_nodes;
	foreach my $section (@{$self->{'section_names'}}) {
		my ($pod_node) = $self->{'pod_abstract'}->select('/head1[@heading =~ {'.$section.'}]');
		if (defined $pod_node) {
			push @pod_nodes, $pod_node;
		}
	}

	return @pod_nodes;
}

sub pod {
	my $self = shift;

	my $pod = $self->{'pod_abstract'}->pod;
	chomp $pod;
	my $ret = substr $pod, 0, -2;
	$ret .= "\n";

	return $ret;
}

sub _iterate_node {
	my ($self, $pod_node, $year) = @_;

	if (defined $pod_node->children) {
		foreach my $child ($pod_node->children) {
			if ($child->type eq ':text') {
				$self->_change_years($child, $year);
			} else {
				$self->_iterate_node($child, $year);
			}
		}
	}

	return;
}

sub _change_years {
	my ($self, $pod_node, $year) = @_;

	my $text = $pod_node->pod;
	if ($text =~ m/^(.*)(\d{4})-(\d{4})(.*)$/ms) {
		my $pre = $1;
		my $first_year = $2;
		my $last_year = $3;
		my $post = $4;
		if ($last_year != $year) {
			my $new_text = $pre.$first_year.'-'.$year.$post;
			$pod_node->body($new_text);
		}
	} elsif ($text =~ m/^(.*)(\d{4})(.*)$/ms) {
		my $pre = $1;
		my $first_year = $2;
		my $post = $3;
		if ($first_year != $year) {
			my $new_text = $pre.$first_year.'-'.$year.$post;
			$pod_node->body($new_text);
		}
	}

	return;
}

1;
