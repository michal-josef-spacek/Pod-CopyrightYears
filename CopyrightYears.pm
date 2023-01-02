package Pod::CopyrightYears;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Pod::Abstract;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	$self->{'section_names'} = [
		'LICENSE AND COPYRIGHT',
	];

	# Process parameters.
	set_params($self, @params);

	return $self;
}

sub change_years {
	my ($self, $pod_node) = @_;

	# TODO
}

sub license_sections {
	my ($self, $pod_file) = @_;

	my $pod_abstract = Pod::Abstract->load_file($pod_file);

	my @pod_nodes;
	foreach my $section (@{$self->{'section_names'}}) {
		my ($pod_node) = $pod_abstract->select('/head1[@heading =~ {'.$section.'}]');
		if (defined $pod_node) {
			push @pod_nodes, $pod_node;
		}
	}

	return @pod_nodes;
}

1;
